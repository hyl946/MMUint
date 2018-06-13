//
//  UIColor+Addition.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "UIColor+Addition.h"
#import "MMConverDataUnit.h"

@implementation UIColor (Addition)

+ (UIColor *)mm_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue{
    return [[self class] mm_colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)mm_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)mm_hexStringConverColor:(NSString *)hex{
    NSString * hexString = [MMConverDataUnit mm_hexConverHexString:hex];
    if (hexString.length != 6) {
        return nil;
    }
    hexString = [hexString lowercaseString];
    NSMutableArray * rgbs = [NSMutableArray array];
    for ( int i = 0 ; i< 3; i++ ){
        NSString * charHex = [hexString substringWithRange:NSMakeRange(i*2, 2)];
        NSInteger r = strtol([@"0x" stringByAppendingString:charHex].UTF8String, 0, 0);
        [rgbs addObject:@(r)];
    }
    return [[self class] mm_colorWithRed:[rgbs[0] integerValue] green:[rgbs[1] integerValue] blue:[rgbs[2] integerValue]];
}
@end
