//
//  MMNSURLSession.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMNSURLSessionTask.h"

typedef void(^MMNSURLSessionTaskSuccess)(id response);
typedef void(^MMNSURLSessionTaskFail)(NSError * error,NSInteger errorCode,NSString * errorDes);
typedef void(^MMNSURLSessionTaskCompletion)(id data,BOOL success, NSError * error,NSInteger errorCode,NSString * errorDes);

@interface MMNSURLSessionTask()<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSessionTask * task;
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, copy)   NSString * url;
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, strong) NSOperationQueue * taskQueue;
@property (nonatomic, strong) NSMutableData * taskData;
@property (nonatomic, copy)   MMNSURLSessionTaskCompletion taskCompletion;
@property (nonatomic, copy)   MMNSURLSessionTaskSuccess taskSuccess;
@property (nonatomic, copy)   MMNSURLSessionTaskSuccess taskFail;
@end

@implementation MMNSURLSessionTask
- (instancetype)init{
    if (self = [super init]) {
        NSURLSessionConfiguration * sessionConfigyration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self currentTimeValue]];
        self.taskQueue = [[NSOperationQueue alloc] init];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfigyration delegate:self delegateQueue:self.taskQueue];

    }
    return self;
}
- (NSURLSessionTask *)mm_postWithUrl:(NSString *)url params:(NSDictionary *)params completion:(void(^)(id data,BOOL success, NSError * error,NSInteger errorCode,NSString * errorDes))completion{
    if (url.length==0) {
        return nil;
    }
    self.taskCompletion = completion;
    self.task = [self.session dataTaskWithRequest:[NSURLRequest postTypeWithURLString:url params:params]];
    [self resume];
    return self.task;
}

- (NSString *)url{
    return _url;
}
- (void)cancel{
    self.isCancel = YES;
}
- (void)resume{
    self.isCancel = NO;
    [self.task resume];
}
- (void)handleResponseData:(id)data{
    if (data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            id result = [data objectForKey:@"result"];
            BOOL success = [[data objectForKey:@"success"] boolValue];
            NSString * errorCode = [data objectForKey:@"errorCode"];
            NSString * errorMsg = [data objectForKey:@"errorMsg"];
            NSError * error = [NSError errorWithDomain:@"客户端数据请求" code:[errorCode integerValue] userInfo:@{@"errorMsg":[NSString stringWithFormat:@"%@",errorMsg]}];
            self.taskCompletion(result,success , error, [errorCode integerValue], errorMsg);
        }
    }
}
#pragma mark - URLSessionDataTaskDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    id taskData = [NSJSONSerialization JSONObjectWithData:data options:1 error:NULL];
//    [session dele]
    [self handleResponseData:taskData];
    [session finishTasksAndInvalidate];
}
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    MM_NSLog(@"%@",downloadTask);
}
- (NSString *)currentTimeValue{
    return [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
}

- (void)dealloc{
    MM_NSLog(@"啊~啊啊~啊啊啊~ 笑毁了");
}
@end
