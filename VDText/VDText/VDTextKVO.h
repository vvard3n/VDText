//
//  VDTextKVO.h
//  VDText
//
//  Created by Harwyn T'an on 2019/12/13.
//  Copyright © 2019 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<VDText/VDText.h>)
#import <VDText/VDTextView.h>
#else
#import "VDTextView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface VDTextKVO : NSObject

@property (nonatomic, weak) id listeningObj;

@end

NS_ASSUME_NONNULL_END
