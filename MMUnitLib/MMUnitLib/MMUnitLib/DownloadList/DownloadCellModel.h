//
//  DownloadCellModel.h
//  MMUnitLib
//
//  Created by Loren on 2018/6/1.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadTableViewCell;
@interface DownloadCellModel : NSObject
//下载进度
@property (nonatomic, assign) CGFloat progress;//0-100
@property (nonatomic, copy) NSString * taskName;
//下载的地址
@property (nonatomic, copy) NSString * downloadAddress;
//保存文件的地址
@property (nonatomic, copy) NSURL * saveFileAddress;
//取消时候的下载数据 用于断点续传
@property (nonatomic, copy) NSData * taskResumeData;
//task Emmmmm。。。不要一直用这个对象，这个对象会变的
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;

@property (nonatomic, weak) DownloadTableViewCell * tableCell;

+ (instancetype)modelWithDownloadAddress:(NSString * (^) (void))downloadAddress
                            saveFilePath:(NSURL * (^) (NSString * fileUrlString))saveFilePath
                                 progess:(void (^) (double progress))progress
                              completion:(void (^) (NSURLResponse *response, NSURL * filePath, NSError * error))completion;
//开始
- (void)start;
//取消
- (void)cancel;
//暂停
- (void)pause;
//继续下载
- (void)goon;

//重新下载
- (void)reset;

@end
