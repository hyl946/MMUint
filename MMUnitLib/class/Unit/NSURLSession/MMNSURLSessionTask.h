//
//  MMNSURLSession.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMNSURLSessionTask : NSObject
- (NSURLSessionTask *)mm_postWithUrl:(NSString *)url params:(NSDictionary *)params completion:(void(^)(id data,BOOL success, NSError * error,NSInteger errorCode,NSString * errorDes))completion;
- (NSString *)url;
- (void)cancel;
- (void)resume;
@end
