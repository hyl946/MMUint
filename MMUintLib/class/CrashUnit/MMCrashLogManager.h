//
//  CrashLogManager.h
//  CrashLogDemo
//
//  Created by Loren on 2018/4/2.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

void crashLogCollectionAction (NSException * exception);

@interface MMCrashLogManager : NSObject

+ (instancetype)instance;

- (void)setProjectId:(NSString *)projectId;

- (void)setDBPath:(NSString *)dbPath;

- (NSString *)getVersionId;

- (void)save:(NSException *)ex;

+ (NSString *)crashLogPath;

+ (NSDate *)currentDateString;
//NSException对象无法alloc init 对象
+ (NSArray <NSDictionary *>*)allCrash;
@end
