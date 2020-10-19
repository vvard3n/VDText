//
//  VDTextAttribute.m
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import "VDTextAttribute.h"

NSString *const VDTextBindingAttributeName = @"VDTextBinding";
NSString *const VDTextHighlightAttributeName = @"VDTextHighlight";
NSString *const VDTextBackedStringAttributeName = @"VDTextBackedString";

@implementation VDTextBackedString

+ (instancetype)stringWithString:(NSString *)string {
    VDTextBackedString *one = [self new];
    one.string = string;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.string forKey:@"string"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _string = [aDecoder decodeObjectForKey:@"string"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.string = self.string;
    return one;
}

@end

@implementation VDTextBinding

+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm {
    VDTextBinding *one = [self new];
    one.deleteConfirm = deleteConfirm;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.deleteConfirm) forKey:@"deleteConfirm"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _deleteConfirm = ((NSNumber *)[aDecoder decodeObjectForKey:@"deleteConfirm"]).boolValue;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.deleteConfirm = self.deleteConfirm;
    return one;
}

@end

@implementation VDTextHighlight

+ (instancetype)highlightWithAttributes:(NSDictionary *)attributes {
    VDTextHighlight *one = [self new];
    one.attributes = attributes;
    return one;
}

+ (instancetype)highlightWithBackgroundColor:(UIColor *)color {
//    VDTextBorder *highlightBorder = [VDTextBorder new];
//    highlightBorder.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
//    highlightBorder.cornerRadius = 3;
//    highlightBorder.fillColor = color;
    
    VDTextHighlight *one = [self new];
//    [one setBackgroundBorder:highlightBorder];
    return one;
}

- (void)setAttributes:(NSDictionary *)attributes {
    _attributes = attributes.mutableCopy;
}

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    NSData *data = nil;
//    @try {
//        data = [YYTextArchiver archivedDataWithRootObject:self.attributes];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    [aCoder encodeObject:data forKey:@"attributes"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    NSData *data = [aDecoder decodeObjectForKey:@"attributes"];
//    @try {
//        _attributes = [YYTextUnarchiver unarchiveObjectWithData:data];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    return self;
//}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.attributes = self.attributes.mutableCopy;
    return one;
}

- (void)_makeMutableAttributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary new];
    } else if (![_attributes isKindOfClass:[NSMutableDictionary class]]) {
        _attributes = _attributes.mutableCopy;
    }
}

//- (void)setFont:(UIFont *)font {
//    [self _makeMutableAttributes];
//    if (font == (id)[NSNull null] || font == nil) {
//        ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = [NSNull null];
//    } else {
//        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
//        if (ctFont) {
//            ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = (__bridge id)(ctFont);
//            CFRelease(ctFont);
//        }
//    }
//}
//
//- (void)setColor:(UIColor *)color {
//    [self _makeMutableAttributes];
//    if (color == (id)[NSNull null] || color == nil) {
//        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = [NSNull null];
//        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = [NSNull null];
//    } else {
//        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = (__bridge id)(color.CGColor);
//        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = color;
//    }
//}

//- (void)setStrokeWidth:(NSNumber *)width {
//    [self _makeMutableAttributes];
//    if (width == (id)[NSNull null] || width == nil) {
//        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = [NSNull null];
//    } else {
//        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = width;
//    }
//}
//
//- (void)setStrokeColor:(UIColor *)color {
//    [self _makeMutableAttributes];
//    if (color == (id)[NSNull null] || color == nil) {
//        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = [NSNull null];
//        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = [NSNull null];
//    } else {
//        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = (__bridge id)(color.CGColor);
//        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = color;
//    }
//}

- (void)setTextAttribute:(NSString *)attribute value:(id)value {
    [self _makeMutableAttributes];
    if (value == nil) value = [NSNull null];
    ((NSMutableDictionary *)_attributes)[attribute] = value;
}

//- (void)setShadow:(YYTextShadow *)shadow {
//    [self setTextAttribute:YYTextShadowAttributeName value:shadow];
//}
//
//- (void)setInnerShadow:(YYTextShadow *)shadow {
//    [self setTextAttribute:YYTextInnerShadowAttributeName value:shadow];
//}
//
//- (void)setUnderline:(YYTextDecoration *)underline {
//    [self setTextAttribute:YYTextUnderlineAttributeName value:underline];
//}
//
//- (void)setStrikethrough:(YYTextDecoration *)strikethrough {
//    [self setTextAttribute:YYTextStrikethroughAttributeName value:strikethrough];
//}
//
//- (void)setBackgroundBorder:(YYTextBorder *)border {
//    [self setTextAttribute:YYTextBackgroundBorderAttributeName value:border];
//}
//
//- (void)setBorder:(YYTextBorder *)border {
//    [self setTextAttribute:YYTextBorderAttributeName value:border];
//}
//
//- (void)setAttachment:(YYTextAttachment *)attachment {
//    [self setTextAttribute:YYTextAttachmentAttributeName value:attachment];
//}

@end
