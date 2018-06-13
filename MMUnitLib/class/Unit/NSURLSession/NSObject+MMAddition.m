//
//  NSURLSessionDownloadTask+MMAddition.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/31.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "NSObject+MMAddition.h"
#import <objc/runtime.h>

static const char * completionKey = "mm_completionKey";
static const char * progressBlockKey = "mm_progressBlockKey";
static const char * saveFilePathKey = "mm_saveFilePathKey";
static const char * resumeDataKey = "mm_resumeData";
static const char * localFileKey = "mm_localFileKey";

@implementation NSObject (MMAddition)

- (void)setMm_taskCompletion:(MMNSURLSessionDownloadTaskCompletion)completion{
    objc_setAssociatedObject(self, completionKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MMNSURLSessionDownloadTaskCompletion)mm_taskCompletion{
   return objc_getAssociatedObject(self, completionKey);
}

- (void)setMm_taskProgressBlock:(MMNSURLSessionDownloadTaskProgress)progressBlock{
    objc_setAssociatedObject(self, progressBlockKey, progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MMNSURLSessionDownloadTaskProgress)mm_taskProgressBlock{
    return objc_getAssociatedObject(self, progressBlockKey);
}

- (void)setMm_taskSaveFilePath:(MMNSURLSessionDownloadTaskSavePath)saveFilePath{
    objc_setAssociatedObject(self, saveFilePathKey, saveFilePath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MMNSURLSessionDownloadTaskSavePath)mm_taskSaveFilePath{
    return objc_getAssociatedObject(self, saveFilePathKey);
}

- (void)setMm_taskResumeData:(NSData *)mm_resumeData{
    objc_setAssociatedObject(self, resumeDataKey, mm_resumeData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSData *)mm_taskResumeData{
    return objc_getAssociatedObject(self, resumeDataKey);
}

- (void)setMm_taskLocalFile:(NSURL *)mm_taskLocalFile{
    objc_setAssociatedObject(self, localFileKey, mm_taskLocalFile, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSURL *)mm_taskLocalFile{
   return objc_getAssociatedObject(self, localFileKey);
}

- (void)setMm_taskName:(NSString *)mm_taskName{
    objc_setAssociatedObject(self, "mm_taskNameKey", mm_taskName,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)mm_taskName{
    return objc_getAssociatedObject(self, "mm_taskNameKey");
}
@end
