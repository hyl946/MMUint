//
//  UIColor+Addition.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

/**
 可传整数rgb值,并返回color对象

 @param red red description
 @param green green description
 @param blue blue description
 @return color
 */
+ (UIColor *)mm_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 可传整数rgb值,并返回color对象 可加alpha

 @param red red description
 @param green green description
 @param blue blue description
 @param alpha alpha description
 @return color
 */
+ (UIColor *)mm_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

/**
 “0xFFFFFF” -> rgb 255 255 255
 
 @param hex hexString
 @return color
 */
+ (UIColor *)mm_hexStringConverColor:(NSString *)hex;
@end
