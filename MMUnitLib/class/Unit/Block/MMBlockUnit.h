//
//  MMBlockUnit.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MMBlockSafeExecute(block,...) if(block){block(__VA_ARGS__);}

@interface MMBlockUnit : NSObject
+ (NSMethodSignature *)mm_blockMethodSignature:(id)block error:(NSError **)error;
@end
