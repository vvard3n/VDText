//
//  NSAttributedString+VDText.m
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2020 vvard3n. All rights reserved.
//

#import "NSAttributedString+VDText.h"
#import <CoreText/CoreText.h>
#import "VDTextContents.h"

static double _VDDeviceSystemVersion() {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

#ifndef kSystemVersion
#define kSystemVersion _VDDeviceSystemVersion()
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

@implementation NSAttributedString (VDText)

- (UIFont *)vd_font {
    return [self vd_fontAtIndex:0];
}

- (UIFont *)vd_fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self vd_attribute:NSFontAttributeName atIndex:index];
    if (kSystemVersion <= 6) {
        if (font) {
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
                CTFontRef CTFont = (__bridge CTFontRef)(font);
                CFStringRef name = CTFontCopyPostScriptName(CTFont);
                CGFloat size = CTFontGetSize(CTFont);
                if (!name) {
                    font = nil;
                } else {
                    font = [UIFont fontWithName:(__bridge NSString *)(name) size:size];
                    CFRelease(name);
                }
            }
        }
    }
    return font;
}

- (UIColor *)vd_color {
    return [self vd_colorAtIndex:0];
}

- (UIColor *)vd_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self vd_attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self vd_attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (id)vd_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSString *)vd_plainTextForRange:(NSRange)range {
    if (range.location == NSNotFound ||range.length == NSNotFound) return nil;
    NSMutableString *result = [NSMutableString string];
    if (range.length == 0) return result;
    NSString *string = self.string;
    [self enumerateAttribute:VDTextBackedStringAttributeName inRange:range options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        VDTextBackedString *backed = value;
        if (backed && backed.string) {
            [result appendString:backed.string];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}

@end

@implementation NSMutableAttributedString (VDText)

- (void)setVd_font:(UIFont *)font {
    [self vd_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)vd_setFont:(UIFont *)font range:(NSRange)range {
    [self vd_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)setVd_color:(UIColor *)color {
    [self vd_setColor:color range:NSMakeRange(0, self.length)];
}

- (void)vd_setColor:(UIColor *)color range:(NSRange)range {
//    [self vd_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self vd_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

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
    if (color) [self vd_setColor:color range:range];
    [self vd_setTextHighlight:highlight range:range];
}

- (void)vd_setTextHighlightRange:(NSRange)range
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(VDTextAction)tapAction {
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
