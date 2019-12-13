//
//  NSAttributedString+VDText.h
//  Ecompany
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2019 Shenzhen Securities Times Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<VDText/VDText.h>)
#import <VDText/VDTextHighlight.h>
#else
#import "VDTextHighlight.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (VDText)

@end


@interface NSMutableAttributedString (VDText)

- (void)vd_setTextBinding:(VDTextBinding *)textBinding range:(NSRange)range;
- (void)vd_setAttribute:(NSString *)name value:(id)value;
- (void)vd_setAttribute:(NSString *)name value:(id)value range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
