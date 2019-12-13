//
//  VDTextEditor.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import "VDTextEditor.h"

NSString *const VDTextViewObserverSelectedTextRange = @"VDTextViewObserverSelectedTextRange";

@interface VDTextEditor () <UITextViewDelegate>

@property (nonatomic, weak) VDTextView *textView;

@end

@implementation VDTextEditor

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setFont:(UIFont *)font {
    self.textView.font = font;
}

- (UIFont *)font {
    return self.textView.font;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textView.textColor = textColor;
}

- (UIColor *)textColor {
    return self.textView.textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.textView.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment {
    return self.textView.textAlignment;
}

- (void)setSelectedRange:(NSRange)selectedRange {
    self.textView.selectedRange = selectedRange;
}

- (NSRange)selectedRange {
    return self.textView.selectedRange;
}

- (void)scrollRangeToVisible:(NSRange)range {
    [self.textView scrollRangeToVisible:range];
}

- (void)setEditable:(BOOL)editable {
    self.textView.editable = editable;
}

- (BOOL)isEditable {
    return self.textView.isEditable;
}

- (void)setSelectable:(BOOL)selectable {
    self.textView.selectable = selectable;
}

- (BOOL)isSelectable {
    return self.textView.isSelectable;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    self.textView.dataDetectorTypes = dataDetectorTypes;
}

- (UIDataDetectorTypes)dataDetectorTypes {
    return self.textView.dataDetectorTypes;
}

- (void)setAllowsEditingTextAttributes:(BOOL)allowsEditingTextAttributes {
    self.textView.allowsEditingTextAttributes = allowsEditingTextAttributes;
}

- (BOOL)allowsEditingTextAttributes {
    return self.textView.allowsEditingTextAttributes;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.textView.attributedText = attributedText;
}

- (NSAttributedString *)attributedText {
    return self.textView.attributedText;
}

- (void)setTypingAttributes:(NSDictionary<NSAttributedStringKey,id> *)typingAttributes {
    self.textView.typingAttributes = typingAttributes;
}

- (NSDictionary<NSAttributedStringKey,id> *)typingAttributes {
    return self.textView.typingAttributes;
}

//// Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
//// set while first responder, will not take effect until reloadInputViews is called.
//@property (nullable, readwrite, strong) UIView *inputView;
- (void)setInputView:(UIView *)inputView {
    self.textView.inputView = inputView;
}

- (UIView *)inputView {
    return self.textView.inputView;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
    self.textView.inputAccessoryView = inputAccessoryView;
}

- (UIView *)inputAccessoryView {
    return self.textView.inputAccessoryView;
}

- (void)setClearsOnInsertion:(BOOL)clearsOnInsertion {
    self.textView.clearsOnInsertion = clearsOnInsertion;
}

- (BOOL)clearsOnInsertion {
    return self.textView.clearsOnInsertion;
}

- (NSTextContainer *)textContainer {
    return self.textView.textContainer;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    self.textView.textContainerInset = textContainerInset;
}

- (UIEdgeInsets)textContainerInset {
    return self.textView.textContainerInset;
}
//@property (nullable, readwrite, strong) UIView *inputAccessoryView;
//
//@property(nonatomic) BOOL clearsOnInsertion API_AVAILABLE(ios(6.0)); // defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.
//
//// Create a new text view with the specified text container (can be nil) - this is the new designated initializer for this class
//- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer API_AVAILABLE(ios(7.0)) NS_DESIGNATED_INITIALIZER;
//- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
//
//// Get the text container for the text view
//@property(nonatomic,readonly) NSTextContainer *textContainer API_AVAILABLE(ios(7.0));
//// Inset the text container's layout area within the text view's content area
//@property(nonatomic, assign) UIEdgeInsets textContainerInset API_AVAILABLE(ios(7.0));
//
//// Convenience accessors (access through the text container)
//@property(nonatomic,readonly) NSLayoutManager *layoutManager API_AVAILABLE(ios(7.0));
//@property(nonatomic,readonly,strong) NSTextStorage *textStorage API_AVAILABLE(ios(7.0));
//
//// Style for links
//@property(null_resettable, nonatomic, copy) NSDictionary<NSAttributedStringKey,id> *linkTextAttributes API_AVAILABLE(ios(7.0));
//
//// When turned on, this changes the rendering scale of the text to match the standard text scaling and preserves the original font point sizes when the contents of the text view are copied to the pasteboard.  Apps that show a lot of text content, such as a text viewer or editor, should turn this on and use the standard text scaling.
//@property (nonatomic) BOOL usesStandardTextScaling API_AVAILABLE(ios(13.0));

- (instancetype)initWithCoder:(NSCoder *)coder {
    
}

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"selectedTextRange"];
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame];
    if (self) {
        VDTextView *textView = [[VDTextView alloc] initWithFrame:self.bounds textContainer:textContainer];
        self.textView = textView;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:textView];
        [textView addObserver:self forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionNew context:@""];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"abc" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"#highlight#" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor],
                                                                                                              VDTextBindingAttributeName : [VDTextBinding bindingWithDeleteConfirm:YES]
        }]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"123" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"#highlight#" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor],
                                                                                                              VDTextBindingAttributeName : [VDTextBinding bindingWithDeleteConfirm:YES]
        }]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"defkdjhsfsdahjksadkfhjsadfads" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, attStr.length)];
        textView.attributedText = attStr;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame textContainer:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}

#pragma mark - Private
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
//    if (context == VDTextViewObserverSelectedTextRange && [path isEqual:@"selectedTextRange"] && !self.enableEditInsterText){
    if ([path isEqualToString:@"selectedTextRange"]) {
        [self.textView resetDelConform];
        UITextRange *newSelectedTextRange = [change objectForKey:@"new"];
        UITextRange *oldSelectedTextRange = [change objectForKey:@"old"];
        NSRange newRange = [self convertSelectedTextRange:newSelectedTextRange toTextView:self.textView];
        NSRange oldRange = [self convertSelectedTextRange:oldSelectedTextRange toTextView:self.textView];
        if (newRange.location != oldRange.location) {

            //判断光标移动，光标不能处在特殊文本内
            [self.textView.attributedText enumerateAttribute:VDTextBindingAttributeName inRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                if (attrs != nil && attrs != 0) {
                    NSLog(@"光标 %ld  -  %ld", newRange.location, newRange.length);
                    NSLog(@"高亮 %ld  -  %ld", range.location, range.length);
                    if ((newRange.location > range.location && newRange.location < range.location + range.length) || ((newRange.location + newRange.length) < (range.location + range.length) && (newRange.location + newRange.length) > range.location)) {
                        NSUInteger leftLocation = newRange.location;
                        NSUInteger rightLocation = newRange.location + newRange.length;
                        //左光标
                        if (newRange.location > range.location && newRange.location < range.location + range.length) {
                            if (newRange.location > range.location + range.length / 2) {
                                leftLocation = range.location + range.length;
                            }
                            else {
                                leftLocation = range.location;
                            }
                        }
                        if ((newRange.location + newRange.length) < (range.location + range.length) && (newRange.location + newRange.length) > range.location) {
                            if ((newRange.location + newRange.length) > range.location + range.length / 2) {
                                rightLocation = range.location + range.length;
                            }
                            else {
                                rightLocation = range.location;
                            }
                        }
                        self.textView.selectedRange = NSMakeRange(leftLocation, rightLocation - leftLocation);
                        NSLog(@"⚠️重新设置Range %ld  -  %ld", leftLocation, rightLocation);
                    }
                }

            }];
        }
    }else{
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
//    self.typingAttributes = self.defaultAttributes;
}

- (NSRange)convertSelectedTextRange:(UITextRange *)textRange toTextView:(UITextView *)textView {
    UITextPosition* beginning = self.textView.beginningOfDocument;
    //获取textField选中选中范围 @“UITextRange”
//    UITextRange* selectedRange = self.selectedTextRange;
    //获取开始点@“3”的位置
    UITextPosition *selectionStart = textRange.start;
    //结束点@"7"的位置
    UITextPosition *selectionEnd = textRange.end;
    //计算NSRange
    const NSInteger location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    //返回范围
    return NSMakeRange(location, length);
}

@end
