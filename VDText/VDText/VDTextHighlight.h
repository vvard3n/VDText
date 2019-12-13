//
//  VDTextHighlight.h
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const VDTextBindingAttributeName;

typedef void(^VDTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);

@interface VDTextBinding : NSObject <NSCoding, NSCopying>
+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm;
@property (nonatomic) BOOL deleteConfirm; ///< confirm the range when delete in VDTextView
@end

@interface VDTextHighlight : NSObject <NSCoding, NSCopying>

/**
 Attributes that you can apply to text in an attributed string when highlight.
 Key:   Same as CoreText/VDText Attribute Name.
 Value: Modify attribute value when highlight (NSNull for remove attribute).
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *attributes;

/**
 Creates a highlight object with specified attributes.
 
 @param attributes The attributes which will replace original attributes when highlight,
        If the value is NSNull, it will removed when highlight.
 */
+ (instancetype)highlightWithAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 Convenience methods to create a default highlight with the specifeid background color.
 
 @param color The background border color.
 */
+ (instancetype)highlightWithBackgroundColor:(nullable UIColor *)color;

// Convenience methods below to set the `attributes`.
- (void)setFont:(nullable UIFont *)font;
- (void)setColor:(nullable UIColor *)color;
//- (void)setStrokeWidth:(nullable NSNumber *)width;
//- (void)setStrokeColor:(nullable UIColor *)color;
//- (void)setShadow:(nullable YYTextShadow *)shadow;
//- (void)setInnerShadow:(nullable YYTextShadow *)shadow;
//- (void)setUnderline:(nullable YYTextDecoration *)underline;
//- (void)setStrikethrough:(nullable YYTextDecoration *)strikethrough;
//- (void)setBackgroundBorder:(nullable YYTextBorder *)border;
//- (void)setBorder:(nullable YYTextBorder *)border;
//- (void)setAttachment:(nullable YYTextAttachment *)attachment;

/**
 The user information dictionary, default is nil.
 */
@property (nullable, nonatomic, copy) NSDictionary *userInfo;

/**
 Tap action when user tap the highlight, default is nil.
 If the value is nil, YYTextView or YYLabel will ask it's delegate to handle the tap action.
 */
@property (nullable, nonatomic, copy) VDTextAction tapAction;

/**
 Long press action when user long press the highlight, default is nil.
 If the value is nil, YYTextView or YYLabel will ask it's delegate to handle the long press action.
 */
@property (nullable, nonatomic, copy) VDTextAction longPressAction;

@end

NS_ASSUME_NONNULL_END
