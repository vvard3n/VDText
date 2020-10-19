//
//  UIColor+VDAdd.h
//  VDText
//
//  Created by Harwyn T'an on 2017/6/6.
//  Copyright © 22020 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VDAdd)

+ (UIColor *)vd_colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)vd_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
