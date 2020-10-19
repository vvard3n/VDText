//
//  VDTextView.h
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2020 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<VDText/VDText.h>)
#import <VDText/VDTextAttribute.h>
#else
#import "VDTextAttribute.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface VDTextView : UITextView

- (void)resetDelConform;
//@property(nonatomic,assign)NSRange selectedRange;

//@property (nonatomic, copy) NSString *placeholder;
//@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
