//
//  NSURLRequest+MMURLSessionTask.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (MMURLSessionTask)

+ (instancetype)postTypeWithURLString:(NSString *)urlString params:(NSDictionary *)params;

+ (instancetype)downloadTypeWithURLString:(NSString *)urlString params:(NSDictionary *)params;
@end
