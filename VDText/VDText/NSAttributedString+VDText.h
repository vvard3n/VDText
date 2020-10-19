//
//  NSAttributedString+VDText.h
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<VDText/VDText.h>)
#import <VDText/VDTextAttribute.h>
#else
#import "VDTextAttribute.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (VDText)

@end


@interface NSMutableAttributedString (VDText)

- (void)vd_setTextBackedString:(nullable VDTextBackedString *)textBackedString range:(NSRange)range;
- (void)vd_setTextBinding:(VDTextBinding *)textBinding range:(NSRange)range;
- (void)vd_setTextBackedString:(nullable VDTextBackedString *)textBackedString range:(NSRange)range;

/**
 Convenience method to set text highlight
 
 @param range           text range
 @param color           text color (pass nil to ignore)
 @param backgroundColor text background color when highlight
 @param userInfo        tap action when user tap the highlight (pass nil to ignore)
 */
- (void)vd_setTextHighlightRange:(NSRange)range
                           color:(nullable UIColor *)color
                 backgroundColor:(nullable UIColor *)backgroundColor
                        userInfo:(nullable NSDictionary *)userInfo;

- (void)vd_setAttribute:(NSString *)name value:(id)value;
- (void)vd_setAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/// Get Height with width
/// @param width maxWidth
- (CGSize)vd_sizeFittingWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
