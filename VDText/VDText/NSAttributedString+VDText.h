//
//  NSAttributedString+VDText.h
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 vvard3n All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<VDText/VDText.h>)
#import <VDText/VDTextAttribute.h>
#else
#import "VDTextAttribute.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (VDText)

@property (nullable, nonatomic, strong, readonly) UIFont *vd_font;
@property (nullable, nonatomic, strong, readonly) UIColor *vd_color;

///=============================================================================
/// @name Query for VDText
///=============================================================================

/**
 Returns the plain text from a range.
 If there's `VDTextBackedStringAttributeName` attribute, the backed string will
 replace the attributed string range.
 
 @param range A range in receiver.
 @return The plain text.
 */
- (NSString *)vd_plainTextForRange:(NSRange)range;

@end


@interface NSMutableAttributedString (VDText)

@property (nullable, nonatomic, strong, readwrite) UIFont *vd_font;
@property (nullable, nonatomic, strong, readwrite) UIColor *vd_color;

- (void)vd_setTextBackedString:(nullable VDTextBackedString *)textBackedString range:(NSRange)range;
- (void)vd_setTextBinding:(VDTextBinding *)textBinding range:(NSRange)range;

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
