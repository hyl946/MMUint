//
//  MMConverDataUnit.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMConverDataUnit : NSObject

/**
 Hex转NSData 内部为NSScaner实现 sacan scanHexInt
"89504e470d0a1a0a0000000d4948445200000a460000067c" ->
<89504e47 0d0a1a0a 0000000d 49484452 00000a46 0000067c>
 
 @param hex 16进制
 @return data
 */
+ (NSData *)mm_hexConverToData:(NSString *)hex;

/**
 Hex转NSData 内部为strtoul 实现 strtoul("","",16);
 "89504e470d0a1a0a0000000d4948445200000a460000067c" ->
 <89504e47 0d0a1a0a 0000000d 49484452 00000a46 0000067c>
 
 @param hex 16进制
 @return data
 */
+ (NSData *)mm_hexConverToData2:(NSString *)hex;

/**
 data 转 hex
 <89504e47 0d0a1a0a 0000000d 49484452 00000a46 0000067c>  ->
 "89504e470d0a1a0a0000000d4948445200000a460000067c"
 
 @param data data
 @return hex string
 */
+ (NSString *)mm_dataConverToHex:(NSData *)data;

/**
 "0xaa2ff" - > "aa2ff"

 @param hex hexValue
 @return hexString
 */
+ (NSString *)mm_hexConverHexString:(NSString *)hex;

@end
