//
//  MMConverDataUnit.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMConverDataUnit.h"

@implementation MMConverDataUnit
+ (NSData *)mm_hexConverToData:(NSString *)hex{
    NSMutableData * hexData = [NSMutableData data];
    NSRange rang = NSMakeRange(0, 1);
    if (hex.length%2 == 0) {
        rang = NSMakeRange(0, 2);
    }
    for (NSInteger i = 0; i<hex.length; i += 2) {
        unsigned int charHexData;
        NSString * hexCharStr = [hex substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scaner = [NSScanner scannerWithString:hexCharStr];
        [scaner scanHexInt:&charHexData];
        [hexData appendData:[NSData dataWithBytes:&charHexData length:1]];
        
        rang.location += rang.length;
        rang.length = 2;
    }
    return hexData;
}

+ (NSData *)mm_hexConverToData2:(NSString *)hex{
    NSMutableData * hexData = [NSMutableData data];
    NSRange rang = NSMakeRange(0, 1);
    if (hex.length%2 == 0) {
        rang = NSMakeRange(0, 2);
    }
    for (NSInteger i = 0; i<hex.length; i += 2) {
        NSString * hexCharStr = [hex substringWithRange:NSMakeRange(i, 2)];
        unsigned long charHexData = strtoul(hexCharStr.UTF8String, 0, 16);
        [hexData appendData:[NSData dataWithBytes:&charHexData length:1]];
        
        rang.location += rang.length;
        rang.length = 2;
    }
    return hexData;
}

+ (NSString *)mm_dataConverToHex:(NSData *)data{
    NSMutableString * hexString = [NSMutableString string];
    
    [data enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        unsigned char * dataBytes = (unsigned char *)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString * hexStr = [NSString stringWithFormat:@"%x",(dataBytes[i] & 0xff)];
            if (hexStr.length == 2) {
                [hexString appendString:hexStr];
            }
            else {
                [hexString appendFormat:@"0%@",hexStr];
            }
        }
    }];
    
    return hexString;
}

+ (NSString *)mm_hexConverHexString:(NSString *)hex{ //"0xff"
    NSString * uppercaseString = [hex uppercaseString];
    NSMutableString * str = [NSMutableString stringWithString:uppercaseString];
    while (str.length) {
        NSString * charString = [str substringToIndex:1];
        if ([charString isEqualToString:@"0"] || [charString isEqualToString:@"X"]) {
            [str deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        else {
            break;
        }
    }
    return str;
}

+ (UIColor *)mm_hexStringConverColor:(NSString *)hex{
    NSString * hexString = [[self class] mm_hexConverHexString:hex];
    if (hexString.length != 6) {
        return nil;
    }
    NSMutableArray * rgbs = [NSMutableArray array];
    for ( int i = 0 ; i< 3; i++ ){
        NSString * charHex = [hexString substringWithRange:NSMakeRange(i*2, 2)];
        NSInteger r = strtol(charHex.UTF8String, NULL, 10);
        [rgbs addObject:@(r)];
    }
//    UIColor * color
    return nil;
}
@end
