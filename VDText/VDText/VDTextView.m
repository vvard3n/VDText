//
//  VDTextView.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2020 vvard3n. All rights reserved.
//

#import "VDTextView.h"
#import "VDTextKVO.h"

@interface VDTextView ()// <UITextViewDelegate>

@property (nonatomic, assign) NSRange preSelecteRanget;
@property (nonatomic, assign) BOOL delConform;
@property (nonatomic, strong) VDTextKVO *kvo;

@end

@implementation VDTextView

- (void)resetDelConform {
    self.delConform = NO;
}

-(void)dealloc {
//    [self removeObserver:self forKeyPath:@"selectedRange"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.kvo = [VDTextKVO new];
        [self addObserver:self.kvo forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"selectedRange") {
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)textDidChange:(NSNotification *)noti {
    NSLog(@"修改文字");
}

//-(void)setPlaceholder:(NSString *)placeholder {
//    _placeholder = placeholder;
//    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
//    [self setNeedsDisplay];
//}

-(void)setText:(NSString *)text {
    [super setText:text];
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect {
//
//    // 如果有输入文字，就直接返回，不画占位文字
//    if (self.hasText) return;
//    //设置文字属性
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = self.font;
//    attributes[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor lightGrayColor];
//    //画文字
//    CGFloat x = 5;
//    CGFloat width = rect.size.width -2 * x;
//    CGFloat y = 8;
//    CGFloat height = rect.size.height - 2 * y;
//    CGRect placeholderRect = CGRectMake(x, y, width, height);
//    [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
//}


- (BOOL)becomeFirstResponder {
    self.delConform = NO;
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.delConform = NO;
    
    return [super resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.delConform = NO;
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Public Set Get

- (void)deleteBackward {
    NSRange effectiveRange;
    if (self.selectedRange.location == 0) {
        [super deleteBackward];
        return;
    }
    VDTextBinding *binding = [self.attributedText attribute:VDTextBindingAttributeName atIndex:self.selectedRange.location - 1 longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, self.attributedText.length)];
    if (!binding) {
        [super deleteBackward];
    }
    else {
        NSMutableAttributedString *attrbuteString = self.attributedText.mutableCopy;
        self.preSelecteRanget = self.selectedRange;
        
        if (self.selectedRange.length > 0) {
            NSMutableAttributedString *attrbuteString = self.attributedText.mutableCopy;
            [attrbuteString replaceCharactersInRange:self.selectedRange withString:@""];
            self.attributedText = attrbuteString;
            self.preSelecteRanget = NSMakeRange(self.preSelecteRanget.location, 0);
            self.selectedRange = self.preSelecteRanget;
            if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                [self.delegate textViewDidChange:self];
            }
            return;
        }
        
        if (!self.delConform) {
            self.delConform = YES;
            
//            [attrbuteString addAttributes:@{NSBackgroundColorAttributeName : [UIColor blueColor]} range:effectiveRange];
            self.preSelecteRanget = effectiveRange;
        }
        else {
            self.delConform = NO;
            [attrbuteString replaceCharactersInRange:effectiveRange withString:@""];
            
            self.preSelecteRanget = effectiveRange;
            self.preSelecteRanget = NSMakeRange(self.preSelecteRanget.location, 0);
        }
        
        self.attributedText = attrbuteString;
        self.selectedRange = self.preSelecteRanget;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:self];
    }
    return YES;
}

@end
