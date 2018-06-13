//
//  NSURLSessionDownloadTask+MMAddition.h
//  MMUnitLib
//
//  Created by Loren on 2018/5/31.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MMNSURLSessionDownloadTaskCompletion)(NSURLResponse *response, NSURL * filePath, NSError * error);

typedef void(^MMNSURLSessionDownloadTaskProgress)(double downloadProgress);

typedef NSURL *(^MMNSURLSessionDownloadTaskSavePath)(NSString * fileUrlString);

//Emmmm。。使用NSObjec的原因而不使用NSURLSessionDownloadTask因为task在生成的的对象找不到这里的方法，只能找他们共同的父类来实现
@interface NSObject (MMAddition)

@property (nonatomic,copy) MMNSURLSessionDownloadTaskCompletion mm_taskCompletion;

@property (nonatomic,copy) MMNSURLSessionDownloadTaskProgress mm_taskProgressBlock;

@property (nonatomic,copy) MMNSURLSessionDownloadTaskSavePath mm_taskSaveFilePath;

@property (nonatomic,copy) NSURL * mm_taskLocalFile;
@property (nonatomic,copy) NSData * mm_taskResumeData;

@property (nonatomic,copy) NSString * mm_taskName;
@end
