//
//  MMNSURLDownloadSessionManager.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/31.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MMAddition.h"

@interface MMNSURLDownloadSessionManager : NSObject

+ (instancetype)manager;

- (NSURLSessionDownloadTask *)addDownloadTaskWithUrlString:(NSString *)urlString
                                              saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
                                                   progess:(MMNSURLSessionDownloadTaskProgress)progress
                                                completion:(MMNSURLSessionDownloadTaskCompletion)completion;

- (void)startWithTask:(NSURLSessionDownloadTask *)task;

- (void)cancelWithTask:(NSURLSessionDownloadTask *)task;

- (void)goonWithTask:(NSURLSessionDownloadTask *)task
        saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
             progess:(MMNSURLSessionDownloadTaskProgress)progress
          completion:(MMNSURLSessionDownloadTaskCompletion)completion
             newTask:(void(^)(NSURLSessionDownloadTask *task))newTask;

- (void)resetWithTask:(NSURLSessionDownloadTask *)task
         saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
              progess:(MMNSURLSessionDownloadTaskProgress)progress
           completion:(MMNSURLSessionDownloadTaskCompletion)completion
              newTask:(void(^)(NSURLSessionDownloadTask *task))newTask;

- (void)pauseWithTask:(NSURLSessionDownloadTask *)task;


@end
