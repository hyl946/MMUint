//
//  DownloadCellModel.m
//  MMUnitLib
//
//  Created by Loren on 2018/6/1.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "DownloadCellModel.h"

@implementation DownloadCellModel

+ (instancetype)modelWithDownloadAddress:(NSString * (^) (void))downloadAddress
                            saveFilePath:(NSURL * (^) (NSString * fileUrlString))saveFilePath
                                 progess:(void (^) (double progress))progressblock
                              completion:(void (^) (NSURLResponse *response, NSURL * filePath, NSError * error))completion
{
    NSString * downloadString = downloadAddress();
    NSURL * saveFileString = saveFilePath(downloadString);
    
    DownloadCellModel * model = [[DownloadCellModel alloc] init];
    MMNSURLSessionDownloadTaskProgress modelTaskProgress = ^(double progres){
        [model.tableCell updateProgress:progres];
        progressblock(progres);
    };
    model.downloadAddress = downloadString;
    model.saveFileAddress =  saveFileString;
    model.mm_taskSaveFilePath = saveFilePath;
    model.mm_taskProgressBlock = modelTaskProgress;
    model.mm_taskCompletion = completion;
    
    model.downloadTask = [[MMNSURLDownloadSessionManager manager] addDownloadTaskWithUrlString:downloadString saveFilePath:saveFilePath progess:modelTaskProgress completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
    }];
    
    return model;
}
- (void)setTaskName:(NSString *)taskName{
    _taskName = taskName;
    self.downloadTask.mm_taskName = taskName;
}
//开始
- (void)start{
    [[MMNSURLDownloadSessionManager manager] startWithTask:self.downloadTask];
}
//取消
- (void)cancel{
    [[MMNSURLDownloadSessionManager manager] cancelWithTask:self.downloadTask];
}
//暂停
- (void)pause{
    [[MMNSURLDownloadSessionManager manager] pauseWithTask:self.downloadTask];
}
//继续下载
- (void)goon{
    __weak typeof(self)weakSelf = self;
    [[MMNSURLDownloadSessionManager manager] goonWithTask:self.downloadTask saveFilePath:self.mm_taskSaveFilePath progess:self.mm_taskProgressBlock completion:self.mm_taskCompletion newTask:^(NSURLSessionDownloadTask *task) {
        weakSelf.downloadTask = task;
    }];
}
- (void)reset{
    __weak typeof(self)weakSelf = self;
    [[MMNSURLDownloadSessionManager manager] resetWithTask:self.downloadTask saveFilePath:self.mm_taskSaveFilePath progess:self.mm_taskProgressBlock completion:self.mm_taskCompletion  newTask:^(NSURLSessionDownloadTask *task) {
        weakSelf.downloadTask = task;
    }];
}
@end
