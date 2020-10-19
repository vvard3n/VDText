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

- (void)vd_setTextBackedString:(VDTextBackedString *)textBackedString range:(NSRange)range {
    [self vd_setAttribute:VDTextBackedStringAttributeName value:textBackedString range:range];
}

- (void)vd_setTextBinding:(VDTextBinding *)textBinding range:(NSRange)range {
    [self vd_setAttribute:VDTextBindingAttributeName value:textBinding range:range];
}

- (void)vd_setTextHighlight:(VDTextHighlight *)textHighlight range:(NSRange)range {
    [self vd_setAttribute:VDTextHighlightAttributeName value:textHighlight range:range];
}

- (void)vd_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo
                       tapAction:(VDTextAction)tapAction
                 longPressAction:(VDTextAction)longPressAction {
    VDTextHighlight *highlight = [VDTextHighlight highlightWithBackgroundColor:backgroundColor];
    highlight.userInfo = userInfo;
    highlight.tapAction = tapAction;
    highlight.longPressAction = longPressAction;
    if (color) [self yy_setColor:color range:range];
    [self vd_setTextHighlight:highlight range:range];
}

- (void)vd_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(YYTextAction)tapAction {
    [self vd_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:nil
                     tapAction:tapAction
               longPressAction:nil];
}

- (void)vd_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                        userInfo:(NSDictionary *)userInfo {
    [self vd_setTextHighlightRange:range
                         color:color
               backgroundColor:backgroundColor
                      userInfo:userInfo
                     tapAction:nil
               longPressAction:nil];
}

- (void)vd_setAttribute:(NSString *)name value:(id)value {
    [self vd_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)vd_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}


//    func sizeFittingWidth(_ w: CGFloat) -> CGSize {
//        let textStorage = NSTextStorage(attributedString: self)
//        let size = CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)
//        let boundingRect = CGRect(origin: .zero, size: size)
//
//        let textContainer = NSTextContainer(size: size)
//        textContainer.lineFragmentPadding = 0
//
//        let layoutManager = NSLayoutManager()
//        layoutManager.addTextContainer(textContainer)
//
//        textStorage.addLayoutManager(layoutManager)
//
//        layoutManager.glyphRange(forBoundingRect: boundingRect, in: textContainer)
//
//        let rect = layoutManager.usedRect(for: textContainer)
//
//        return rect.integral.size
//    }

- (CGSize)vd_sizeFittingWithWidth:(CGFloat)width {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGRect boundingRect = CGRectMake(0, 0, size.width, size.height);
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    textContainer.lineFragmentPadding = 0;
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [layoutManager addTextContainer:textContainer];
    
    [textStorage addLayoutManager:layoutManager];
    
    [layoutManager glyphRangeForBoundingRect:boundingRect inTextContainer:textContainer];
    
    CGRect rect = [layoutManager usedRectForTextContainer:textContainer];
    
    return CGRectIntegral(rect).size;
}

@end
