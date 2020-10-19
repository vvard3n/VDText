//
//  ViewController.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import "ViewController.h"
#import "VDText/VDText.h"

#define kTextViewFontSize [UIFont systemFontOfSize:18]
#define kTextViewTextColor [UIColor blackColor]
#define HIGHLIGHT_BLUE_COLOR [UIColor blueColor]

@interface ViewController ()

@property (nonatomic, weak) VDTextEditor *textEditor;
@property (nonatomic, weak) VDTextEditor *textEditorXIB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VDTextEditor *textEditor = [[VDTextEditor alloc] init];
    self.textEditor = textEditor;
    textEditor.placeholderText = @"占位文本";
    textEditor.placeholderFont = kTextViewFontSize;
    textEditor.placeholderTextColor = [UIColor colorWithWhite:0 alpha:0.5];
    textEditor.textContainerInset = UIEdgeInsetsMake(15, 0, 15, 0);
    textEditor.textColor = [UIColor blackColor];
    textEditor.font = kTextViewFontSize;
    textEditor.backgroundColor = [UIColor redColor];
    [self.view addSubview:textEditor];
    textEditor.frame = CGRectMake(17, 100, UIScreen.mainScreen.bounds.size.width - 17 * 2, 200);
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [addBtn setTitle:@"添加链接" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addBtn.backgroundColor = [UIColor blueColor];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    addBtn.frame = CGRectMake(17, CGRectGetMaxY(textEditor.frame) + 20, 88, 44);
    [addBtn addTarget:self action:@selector(addBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *endEditingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [endEditingBtn setTitle:@"停止输入" forState:UIControlStateNormal];
    endEditingBtn.frame = CGRectMake(CGRectGetMaxX(addBtn.frame) + 10, CGRectGetMaxY(textEditor.frame) + 20, 88, 44);
    [self.view addSubview:endEditingBtn];
    [endEditingBtn addTarget:self action:@selector(endEditingBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addBtnDidClick:(UIButton *)sender {
    NSMutableAttributedString *mattStr = self.textEditor.attributedText.mutableCopy;
    //替换文本
    NSMutableAttributedString *replaceText = [[NSMutableAttributedString alloc] initWithString:@" "];
    replaceText.vd_color = kTextViewTextColor;
    replaceText.vd_font = kTextViewFontSize;
    NSMutableAttributedString *displayName = [[NSMutableAttributedString alloc] initWithString:@"高亮链接"];
    displayName.vd_color = HIGHLIGHT_BLUE_COLOR;
    displayName.vd_font = kTextViewFontSize;
    [replaceText appendAttributedString:displayName];
    NSMutableAttributedString *blackSpace = [[NSMutableAttributedString alloc] initWithString:@" "];
    blackSpace.vd_color = kTextViewTextColor;
    blackSpace.vd_font = kTextViewFontSize;
    [replaceText appendAttributedString:blackSpace];
    [replaceText vd_setTextBinding:[VDTextBinding bindingWithDeleteConfirm:YES] range:NSMakeRange(0, replaceText.length)];
    

    [replaceText vd_setTextHighlightRange:NSMakeRange(0, replaceText.length - 1) color:HIGHLIGHT_BLUE_COLOR backgroundColor:nil userInfo:@{@"type" : @"url", @"text" : @"anyText"}];
    
    // 添加被替换的原始字符串，用于复制
    VDTextBackedString *backed = [VDTextBackedString stringWithString:@"高亮链接"];
    [replaceText vd_setTextBackedString:backed range:NSMakeRange(0, replaceText.length)];
    
    NSRange selectedRange = self.textEditor.selectedRange;
    [mattStr insertAttributedString:replaceText atIndex:selectedRange.location];
    [mattStr addAttributes:@{NSForegroundColorAttributeName:HIGHLIGHT_BLUE_COLOR, NSFontAttributeName:kTextViewFontSize} range:selectedRange];
    
    self.textEditor.attributedText = mattStr.copy;
    
    self.textEditor.selectedRange = NSMakeRange(selectedRange.location + replaceText.length, 0);
}

- (void)endEditingBtnDidClick:(UIButton *)sender {
    [self.view endEditing:YES];
}

@end
