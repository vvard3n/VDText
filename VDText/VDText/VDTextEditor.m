//
//  VDTextEditor.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import "VDTextEditor.h"

NSString *const VDTextViewObserverSelectedTextRange = @"VDTextViewObserverSelectedTextRange";

@interface VDTextEditor () <UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) VDTextView *textView;
@property (nonatomic, weak) UILabel *placeholderLbl;

@end

@implementation VDTextEditor

- (UILabel *)placeholderLbl {
    if (!_placeholderLbl) {
        UILabel *placeholderLbl = [[UILabel alloc] init];
        _placeholderLbl = placeholderLbl;
        _placeholderLbl.textColor = CONTENT_TEXT_COLOR_333131;
        _placeholderLbl.font = [UIFont systemFontOfSize:14];
        _placeholderLbl.numberOfLines = 0;
        [self.textView addSubview:_placeholderLbl];
        _placeholderLbl.frame = CGRectMake(self.bounds.origin.x + 3 + self.textContainerInset.left, self.bounds.origin.y + self.textContainerInset.top, self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right, 0);
        _placeholderLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (self.placeholderAttributedText) {
            _placeholderLbl.attributedText = self.placeholderAttributedText;
        }
    }
    return _placeholderLbl;
}

- (BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.textView.scrollEnabled = scrollEnabled;
}

- (UIScrollView *)scrollView {
    return self.textView;
}

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

- (UITextRange *)selectedTextRange {
    return self.textView.selectedTextRange;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {
    self.textView.selectedTextRange = selectedTextRange;
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

//- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
//    self.textView.inputAccessoryView = inputAccessoryView;
//}
//
//- (UIView *)inputAccessoryView {
//    return self.textView.inputAccessoryView;
//}

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

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    if (_placeholderAttributedText.length > 0) {
        if (placeholderText.length > 0) {
            [((NSMutableAttributedString *)_placeholderAttributedText) replaceCharactersInRange:NSMakeRange(0, _placeholderAttributedText.length) withString:placeholderText];
        } else {
            [((NSMutableAttributedString *)_placeholderAttributedText) replaceCharactersInRange:NSMakeRange(0, _placeholderAttributedText.length) withString:@""];
        }
        ((NSMutableAttributedString *)_placeholderAttributedText).yy_font = _placeholderFont;
        ((NSMutableAttributedString *)_placeholderAttributedText).yy_color = _placeholderTextColor;
    } else {
        if (placeholderText.length > 0) {
            NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderText];
//            if (!_placeholderFont) _placeholderFont = _font;
//            if (!_placeholderFont) _placeholderFont = [self _defaultFont];
//            if (!_placeholderTextColor) _placeholderTextColor = [self _defaultPlaceholderColor];
            atr.yy_font = _placeholderFont;
            atr.yy_color = _placeholderTextColor;
            _placeholderAttributedText = atr;
        }
    }
    _placeholderText = [_placeholderAttributedText yy_plainTextForRange:NSMakeRange(0, _placeholderAttributedText.length)];
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    ((NSMutableAttributedString *)_placeholderAttributedText).yy_font = _placeholderFont;
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    ((NSMutableAttributedString *)_placeholderAttributedText).yy_color = _placeholderTextColor;
    [self _commitPlaceholderUpdate];
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    _placeholderAttributedText = placeholderAttributedText.mutableCopy;
    _placeholderText = [_placeholderAttributedText yy_plainTextForRange:NSMakeRange(0, _placeholderAttributedText.length)];
    _placeholderFont = _placeholderAttributedText.yy_font;
    _placeholderTextColor = _placeholderAttributedText.yy_color;
    [self _commitPlaceholderUpdate];
}

- (void)_commitPlaceholderUpdate {
//#if !TARGET_INTERFACE_BUILDER
//    _state.placeholderNeedUpdate = YES;
//    [[YYTextTransaction transactionWithTarget:self selector:@selector(_updatePlaceholderIfNeeded)] commit];
//#else
    [self _updatePlaceholder];
//#endif
}

/// Update placeholder if needed.
- (void)_updatePlaceholderIfNeeded {
//    if (_state.placeholderNeedUpdate) {
//        _state.placeholderNeedUpdate = NO;
        [self _updatePlaceholder];
//    }
}

/// Update placeholder immediately.
- (void)_updatePlaceholder {
    CGRect frame = CGRectZero;
//    _placeHolderView.image = nil;
    _placeholderLbl.frame = frame;
    if (_placeholderAttributedText.length > 0) {
        _placeholderLbl.attributedText = self.placeholderAttributedText;
        [self layoutIfNeeded];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        
    }
    return self;
}

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"selectedTextRange"];
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame];
    if (self) {
        VDTextView *textView = [[VDTextView alloc] initWithFrame:self.bounds textContainer:textContainer];
        self.textView = textView;
        textView.delegate = self;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:textView];
        [textView addObserver:self forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionNew context:@""];
        [textView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:@""];
        
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"abc" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"#highlight#" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor],
//                                                                                                              VDTextBindingAttributeName : [VDTextBinding bindingWithDeleteConfirm:YES]
//        }]];
//        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"123" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
//        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"#highlight#" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor],
//                                                                                                              VDTextBindingAttributeName : [VDTextBinding bindingWithDeleteConfirm:YES]
//        }]];
//        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"defkdjhsfsdahjksadkfhjsadfads" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
//        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, attStr.length)];
//        textView.attributedText = attStr;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame textContainer:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    
    CGSize placeholderLblSize = [self.placeholderLbl sizeThatFits:CGSizeMake(self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right, HUGE)];
    self.placeholderLbl.frame = CGRectIntegral(CGRectMake(self.bounds.origin.x + 3 + self.textContainerInset.left, self.bounds.origin.y + self.textContainerInset.top, placeholderLblSize.width, placeholderLblSize.height));
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return [self.textView caretRectForPosition:position];
}

#pragma mark - Private
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
//    if (context == VDTextViewObserverSelectedTextRange && [path isEqual:@"selectedTextRange"] && !self.enableEditInsterText){
    if ([path isEqualToString:@"attributedText"]) {
        self.placeholderLbl.hidden = self.textView.attributedText.length > 0;
    }
    else if ([path isEqualToString:@"selectedTextRange"]) {
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
    }
    else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
//    self.typingAttributes = self.defaultAttributes;
}

- (NSRange)convertSelectedTextRange:(UITextRange *)textRange toTextView:(UITextView *)textView {
    UITextPosition* beginning = self.textView.beginningOfDocument;
    //获取textField选中选中范围 @“UITextRange”
//    UITextRange* selectedRange = self.selectedTextRange;
    //获取开始点@“3”的位置
    if ([textRange.start isKindOfClass:[NSNull class]]) {
        return NSMakeRange(0, 0);
    }
    UITextPosition *selectionStart = textRange.start;
    //结束点@"7"的位置
    UITextPosition *selectionEnd = textRange.end;
    //计算NSRange
    const NSInteger location = [self.textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self.textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    //返回范围
    return NSMakeRange(location, length);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//        [[YYTextEffectWindow sharedWindow] showSelectionDot:_selectionView];
//    }
//
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    } else {
        return nil;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.textView) {
        self.placeholderLbl.hidden = textView.attributedText.length > 0;
    }
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:self];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegate textViewShouldEndEditing:self];
    }
    else {
        return YES;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        [self.delegate textViewShouldBeginEditing:self];
    }
    return YES;
}

@end
