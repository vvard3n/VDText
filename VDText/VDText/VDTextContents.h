//
//  VDTextContents.h
//  VDText
//
//  Created by Harwyn on 2017/4/27.
//

#ifndef VDTextContents_h
#define VDTextContents_h

//color
/*
 Create UIColor with a hex string.
 Example: UIColorHex(0xF0F), UIColorHex(66ccff), UIColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor vd_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

#define RGBColor(x,y,z) [UIColor colorWithRed:x / 255.0 green:y / 255.0 blue:z / 255.0 alpha:1.00]
#define RGBAColor(x,y,z,a) [UIColor colorWithRed:x / 255.0 green:y / 255.0 blue:z / 255.0 alpha:a]
#define MAIN_COLOR UIColorHex(e63130)
#define HIGHLIGHT_RED_COLOR UIColorHex(E55C5C)
#define RED_LABEL_BACKGROUND_COLOR UIColorHex(FFFAFA)
#define HIGHLIGHT_BLUE_COLOR UIColorHex(3D9CCC)
#define ORANGE_COLOR_F58631 UIColorHex(F58631)
#define BLUE_LABEL_BACKGROUND_COLOR RGBColor(250, 253, 255)
#define BLUE_COLOR_F0F7FB UIColorHex(F0F7FB)
#define STOCK_DOWN_GREEN RGBColor(14, 174, 78)
#define LIGHT_LINE_COLOR UIColorHex(eeeeee)
#define DARK_LINE_COLOR UIColorHex(dbdbdb)
#define GRAY_COLOR_E2E2E2 UIColorHex(E2E2E2)
#define MAIN_BACKGROUND_COLOR UIColorHex(f7f8fa)
#define TITLE_TEXT_COLOR CONTENT_TEXT_COLOR_1F1D1D
#define CONTENT_TEXT_COLOR_1F1D1D UIColorHex(1f1d1d)
#define CONTENT_TEXT_COLOR_333131 UIColorHex(333131)
#define CONTENT_TEXT_COLOR_666060 UIColorHex(666060)
#define CONTENT_TEXT_COLOR_C7BBBB UIColorHex(C7BBBB)
#define CONTENT_TEXT_COLOR_999090 UIColorHex(999090)
#define TIME_TEXT_COLOR UIColorHex(999090)
#define BLUR_DARK_LINE_COLOR UIColorHex(bdbdbd)

//font
//#define TOP_NEWS_FONT [UIFont systemFontOfSize:20]
//#define NAV_TITLE_FONT [UIFont systemFontOfSize:18]
//#define NAV_TITLE_BOLD_FONT [UIFont boldSystemFontOfSize:18]
//#define CONTENT_TEXT_SIZE_17 [UIFont systemFontOfSize:17]
//#define NAV_UNSELECT_FONT [UIFont systemFontOfSize:15]
//#define TIME_TEXT_FONT [UIFont systemFontOfSize:12]
//#define FLAG_TEXT_FONT [UIFont systemFontOfSize:11]
//#define TOOLBAR_TEXT_FONT [UIFont systemFontOfSize:10]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* VDTextContents_h */
