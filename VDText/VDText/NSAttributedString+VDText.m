//
//  NSAttributedString+VDText.m
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import "NSAttributedString+VDText.h"


@implementation NSAttributedString (VDText)

@end

@implementation NSMutableAttributedString (VDText)

- (void)vd_setTextBinding:(VDTextBinding *)textBinding range:(NSRange)range {
    [self vd_setAttribute:VDTextBindingAttributeName value:textBinding range:range];
}

- (void)vd_setAttribute:(NSString *)name value:(id)value {
    [self vd_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)vd_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

@end
