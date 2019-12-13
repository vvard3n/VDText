//
//  VDTextKVO.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import "VDTextKVO.h"

@implementation VDTextKVO

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
//    if (context == VDTextViewObserverSelectedTextRange && [path isEqual:@"selectedTextRange"] && !self.enableEditInsterText){
    if ([path isEqualToString:@"selectedTextRange"] && self.listeningObj && [self.listeningObj isKindOfClass:[VDTextView class]]) {
        VDTextView *textView = (VDTextView *)self.listeningObj;
        UITextRange *newSelectedTextRange = [change objectForKey:@"new"];
        UITextRange *oldSelectedTextRange = [change objectForKey:@"old"];
        NSRange newRange = [self convertSelectedTextRange:newSelectedTextRange toTextView:textView];
        NSRange oldRange = [self convertSelectedTextRange:oldSelectedTextRange toTextView:textView];
        if (newRange.location != oldRange.location) {

            //判断光标移动，光标不能处在特殊文本内
            [textView.attributedText enumerateAttribute:VDTextBindingAttributeName inRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
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
                        textView.selectedRange = NSMakeRange(leftLocation, rightLocation - leftLocation);
                        NSLog(@"⚠️重新设置Range %ld  -  %ld", leftLocation, rightLocation);
                    }
                }

            }];
        }
    }else{
//        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
//    self.typingAttributes = self.defaultAttributes;
}

- (NSRange)convertSelectedTextRange:(UITextRange *)textRange toTextView:(UITextView *)textView {
    UITextPosition* beginning = textView.beginningOfDocument;
    //获取textField选中选中范围 @“UITextRange”
//    UITextRange* selectedRange = self.selectedTextRange;
    //获取开始点@“3”的位置
    UITextPosition *selectionStart = textRange.start;
    //结束点@"7"的位置
    UITextPosition *selectionEnd = textRange.end;
    //计算NSRange
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    //返回范围
    return NSMakeRange(location, length);
}

@end
