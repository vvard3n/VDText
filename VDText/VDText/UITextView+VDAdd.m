//
//  UITextView+VDAdd.m
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/11.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import "UITextView+VDAdd.h"
#if !TARGET_OS_IOS
#import <AppKit/AppKit.h>
#endif


@implementation UITextView (VDAdd)

/**
 通过我们传递的范围，在textField中选中字符串
 @param selectedRange 在字符串中要去选中的范围
 *NSRange -> UITextRange
 */
- (void)setSelectedRange:(NSRange)selectedRange{
    //beginningOfDocument 文本的开始位置，也就是123456789abcdefg，@“1”这个位置
    UITextPosition* beginning = self.beginningOfDocument;
    //positionFromPosition 通过这个方法，我们先取得@“3”这个位置
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:selectedRange.location];
    //获取@“7”这个位置
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    //通过连个 @“UITextPostion”获取到UITextRage
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    //让textField选中具体位置
    [self setSelectedTextRange:selectionRange];
}


/**
 获取当前textField的选中字符串的范围
 *UITextRange -> NSRange
 */
- (NSRange)selectedRange{
    //获取textField中文本开始点 @"1"这个位置
    UITextPosition* beginning = self.beginningOfDocument;
    //获取textField选中选中范围 @“UITextRange”
    UITextRange* selectedRange = self.selectedTextRange;
    //获取开始点@“3”的位置
    UITextPosition* selectionStart = selectedRange.start;
    //结束点@"7"的位置
    UITextPosition* selectionEnd = selectedRange.end;
    //计算NSRange
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    //返回范围
    return NSMakeRange(location, length);
}

@end
