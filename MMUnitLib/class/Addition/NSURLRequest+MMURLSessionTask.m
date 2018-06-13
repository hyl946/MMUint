//
//  NSURLRequest+MMURLSessionTask.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "NSURLRequest+MMURLSessionTask.h"

@implementation NSURLRequest (MMURLSessionTask)

+ (instancetype)postTypeWithURLString:(NSString *)urlString params:(NSDictionary *)params{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:60];
    if (params) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    }
    if (![request valueForHTTPHeaderField:@"Content-Type"]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return request;
}

+ (instancetype)downloadTypeWithURLString:(NSString *)urlString params:(NSDictionary *)params{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:60];
    if (params) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    }
    return request;
}
@end
