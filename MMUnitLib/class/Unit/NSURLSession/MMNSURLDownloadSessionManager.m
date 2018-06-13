//
//  MMNSURLDownloadSessionManager.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/31.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMNSURLDownloadSessionManager.h"

@interface MMNSURLDownloadSessionManager()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong)NSURLSession * session;

@property (nonatomic, strong)NSOperationQueue * operationQueue;

@end

static MMNSURLDownloadSessionManager * manager;
@implementation MMNSURLDownloadSessionManager

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MMNSURLDownloadSessionManager alloc] init];
        NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[[self class] currentTimeValueString]];
        //最大下载数是默认的4 要多个需要设置此属性
        config.HTTPMaximumConnectionsPerHost = 10;
        NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:manager delegateQueue:operationQueue];
        manager.session = session;
        manager.operationQueue = operationQueue;
    });
    return manager;
}

- (NSURLSessionDownloadTask *)addDownloadTaskWithUrlString:(NSString *)urlString
                                              saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
                                                   progess:(MMNSURLSessionDownloadTaskProgress)progress
                                                completion:(MMNSURLSessionDownloadTaskCompletion)completion
{
    
    NSURLSessionDownloadTask * task = [self.session downloadTaskWithRequest:[NSURLRequest downloadTypeWithURLString:urlString params:nil]];
    task.mm_taskSaveFilePath = saveFilePath;
    task.mm_taskProgressBlock = progress;
    task.mm_taskCompletion = completion;
    return task;
}

- (void)startWithTask:(NSURLSessionDownloadTask *)task{
    if (task.state == NSURLSessionTaskStateRunning) {
        return;
    }
    [task resume];
}

- (void)goonWithTask:(NSURLSessionDownloadTask *)task
        saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
             progess:(MMNSURLSessionDownloadTaskProgress)progress
          completion:(MMNSURLSessionDownloadTaskCompletion)completion
             newTask:(void(^)(NSURLSessionDownloadTask *task))newTask
{
    if (task.mm_taskResumeData) {
        NSURLSessionDownloadTask * m_task = [self.session downloadTaskWithResumeData:task.mm_taskResumeData];
        m_task.mm_taskSaveFilePath = saveFilePath;
        m_task.mm_taskProgressBlock = progress;
        m_task.mm_taskCompletion = completion;
        [m_task resume];
        MMBlockSafeExecute(newTask,m_task);
    }
    else {
        [task resume];
    }
}

- (void)cancelWithTask:(NSURLSessionDownloadTask *)task{
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        task.mm_taskResumeData = resumeData;
    }];
}

- (void)resetWithTask:(NSURLSessionDownloadTask *)task
         saveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath
              progess:(MMNSURLSessionDownloadTaskProgress)progress
           completion:(MMNSURLSessionDownloadTaskCompletion)completion
              newTask:(void(^)(NSURLSessionDownloadTask *task))newTask{
    [task cancel];
    task.mm_taskSaveFilePath = NULL;
    task.mm_taskProgressBlock = NULL;
    task.mm_taskCompletion = NULL;
    NSURLSessionDownloadTask * m_task = [self.session downloadTaskWithRequest:task.originalRequest];
    m_task.mm_taskSaveFilePath = saveFilePath;
    m_task.mm_taskProgressBlock = progress;
    m_task.mm_taskCompletion = completion;
    [m_task resume];
    MMBlockSafeExecute(newTask,m_task);
}

- (void)pauseWithTask:(NSURLSessionDownloadTask *)task{
    [task suspend];
}
- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    MM_NSLog(@"%@ - %@",task.mm_taskName,error);
    MM_NSLog(@"");
    if(task.mm_taskLocalFile){
        if ([[NSFileManager defaultManager] fileExistsAtPath:(task.mm_taskLocalFile.absoluteString)]) {
            [[NSFileManager defaultManager] moveItemAtURL:task.mm_taskLocalFile toURL:task.mm_taskSaveFilePath(task.mm_taskLocalFile.absoluteString) error:NULL];
        }
    }
    mm_dispatch_main_async_safe(^{
        MMBlockSafeExecute(task.mm_taskCompletion,task.response, task.mm_taskLocalFile, error)
    });
}
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //下载完 回调
    downloadTask.mm_taskLocalFile = location;
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //下载进度
    double progress = totalBytesWritten*1.0/totalBytesExpectedToWrite*100;
    MMNSURLSessionDownloadTaskProgress taskProgressBlock = downloadTask.mm_taskProgressBlock;
    NSLog(@"当前下载任务--->%@",downloadTask.mm_taskName);
    mm_dispatch_main_async_safe(^{
        MMBlockSafeExecute(taskProgressBlock,progress);
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    //重新开启，可获取进度
    MM_NSLog(@"重新开始进度%f%%",fileOffset*1.0/expectedTotalBytes*100);
}
#pragma mark - other tool
+ (NSString *)currentTimeValueString{
    return [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
}
@end
