//
//  MMJsonModel.h
//  CrashLogDemo
//
//  Created by Loren on 2018/4/27.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMJsonModel : NSObject
+ (id)jsonToModel:(NSDictionary *)dict class:(Class )classN;
+ (NSDictionary *)modelToJson:(NSObject *)model;
@end
