//
//  VDTextEditor.h
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDText.h"

NS_ASSUME_NONNULL_BEGIN

@class VDTextEditor, VDTextHighlight;

@protocol VDTextEditorDelegate <NSObject, UIScrollViewDelegate>

@optional

- (BOOL)textViewShouldBeginEditing:(VDTextEditor *)textView;
- (BOOL)textViewShouldEndEditing:(VDTextEditor *)textView;

- (void)textViewDidBeginEditing:(VDTextEditor *)textView;
- (void)textViewDidEndEditing:(VDTextEditor *)textView;

- (BOOL)textView:(VDTextEditor *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(VDTextEditor *)textView;

- (void)textViewDidChangeSelection:(VDTextEditor *)textView;

- (BOOL)textView:(VDTextEditor *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0));
- (BOOL)textView:(VDTextEditor *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0));

- (BOOL)textView:(VDTextEditor *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange API_DEPRECATED_WITH_REPLACEMENT("textView:shouldInteractWithURL:inRange:forInteractionType:", ios(7.0, 10.0));
- (BOOL)textView:(VDTextEditor *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange API_DEPRECATED_WITH_REPLACEMENT("textView:shouldInteractWithTextAttachment:inRange:forInteractionType:", ios(7.0, 10.0));


- (BOOL)textView:(VDTextEditor *)textView shouldTapHighlight:(VDTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(VDTextEditor *)textView didTapHighlight:(VDTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;
- (BOOL)textView:(VDTextEditor *)textView shouldLongPressHighlight:(VDTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(VDTextEditor *)textView didLongPressHighlight:(VDTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;

@end

@interface VDTextEditor : UIView

@property(nullable,nonatomic,weak) id<VDTextEditorDelegate> delegate;

@property (nonatomic, assign) BOOL scrollEnabled;
@property(nonatomic, strong, readonly) UIScrollView *scrollView;
@property(null_resettable,nonatomic,copy) NSString *text;
@property(nullable,nonatomic,strong) UIFont *font;
@property(nullable,nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;    // default is NSLeftTextAlignment
@property(nonatomic) NSRange selectedRange;
@property(nonatomic, strong, nullable) UITextRange *selectedTextRange;
@property(nonatomic,getter=isEditable) BOOL editable API_UNAVAILABLE(tvos);
@property(nonatomic,getter=isSelectable) BOOL selectable API_AVAILABLE(ios(7.0)); // toggle selectability, which controls the ability of the user to select content and interact with URLs & attachments. On tvOS this also makes the text view focusable.
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);

@property(nonatomic) BOOL allowsEditingTextAttributes API_AVAILABLE(ios(6.0)); // defaults to NO
@property(null_resettable,copy) NSAttributedString *attributedText API_AVAILABLE(ios(6.0));
@property(nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *typingAttributes API_AVAILABLE(ios(6.0)); // automatically resets when the selection changes

#pragma mark - Configuring the Placeholder
///=============================================================================
/// @name Configuring the Placeholder
///=============================================================================


@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
/**
 The placeholder text displayed by the text view (when the text view is empty).
 Set a new value to this property also replaces the text in `placeholderAttributedText`.
 Get the value returns the plain text in `placeholderAttributedText`.
 */
@property (nullable, nonatomic, copy) NSString *placeholderText;

/**
 The font of the placeholder text. Default is same as `font` property.
 Set a new value to this property also causes the new font to be applied to the entire `placeholderAttributedText`.
 Get the value returns the font at the head of `placeholderAttributedText`.
 */
@property (nullable, nonatomic, strong) UIFont *placeholderFont;

/**
 The color of the placeholder text. Default is gray.
 Set a new value to this property also causes the new color to be applied to the entire `placeholderAttributedText`.
 Get the value returns the color at the head of `placeholderAttributedText`.
 */
@property (nullable, nonatomic, strong) UIColor *placeholderTextColor;

/**
 The styled placeholder text displayed by the text view (when the text view is empty).
 Set a new value to this property also replaces the value of the `placeholderText`,
 `placeholderFont`, `placeholderTextColor`.
 
 @discussion It only support the attributes declared in CoreText and YYTextAttribute.
 See `NSAttributedString+YYText` for more convenience methods to set the attributes.
 */
@property (nullable, nonatomic, copy) NSAttributedString *placeholderAttributedText;

- (void)scrollRangeToVisible:(NSRange)range;


// Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
// set while first responder, will not take effect until reloadInputViews is called.
@property (nullable, readwrite, strong) UIView *inputView;
//@property (nullable, readwrite, strong) UIView *inputAccessoryView;

@property(nonatomic) BOOL clearsOnInsertion API_AVAILABLE(ios(6.0)); // defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.

// Create a new text view with the specified text container (can be nil) - this is the new designated initializer for this class
- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer API_AVAILABLE(ios(7.0)) NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

// Get the text container for the text view
@property(nonatomic,readonly) NSTextContainer *textContainer API_AVAILABLE(ios(7.0));
// Inset the text container's layout area within the text view's content area
@property(nonatomic, assign) UIEdgeInsets textContainerInset API_AVAILABLE(ios(7.0));

// Convenience accessors (access through the text container)
@property(nonatomic,readonly) NSLayoutManager *layoutManager API_AVAILABLE(ios(7.0));
@property(nonatomic,readonly,strong) NSTextStorage *textStorage API_AVAILABLE(ios(7.0));

// Style for links
@property(null_resettable, nonatomic, copy) NSDictionary<NSAttributedStringKey,id> *linkTextAttributes API_AVAILABLE(ios(7.0));

// When turned on, this changes the rendering scale of the text to match the standard text scaling and preserves the original font point sizes when the contents of the text view are copied to the pasteboard.  Apps that show a lot of text content, such as a text viewer or editor, should turn this on and use the standard text scaling.
@property (nonatomic) BOOL usesStandardTextScaling API_AVAILABLE(ios(13.0));

- (CGRect)caretRectForPosition:(UITextPosition *)position;

@end

NS_ASSUME_NONNULL_END
