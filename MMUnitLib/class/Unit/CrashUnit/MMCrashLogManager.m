//
//  MMCrashLogManager.m
//  CrashLogDemo
//
//  Created by Loren on 2018/4/2.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMCrashLogManager.h"
#import "MMDBManager.h"

void crashLogCollectionAction (NSException * exception){
    [[MMCrashLogManager instance] save:exception];
}

@interface MMCrashLogManager()
@property (nonatomic, copy) NSString * dbPath;
@end

@implementation MMCrashLogManager

static MMCrashLogManager * manager;

+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MMCrashLogManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setDefultDBPath];
    }
    return self;
}

-(NSString *)getVersionId{
    return @"0.0.1";
}
- (void)setProjectId:(NSString *)projectId{
    
}
- (void)setDefultDBPath{
    NSString * dbPath = [[[NSBundle mainBundle] pathForResource:@"MMUnitLib" ofType:@"bundle"] stringByAppendingPathComponent:@"CrashTable.db"];
    NSString * newDBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"crash.log"];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:newDBPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:dbPath toPath:newDBPath error:NULL];
    };
    self.dbPath = newDBPath;
}
- (void)setDBPath:(NSString *)dbPath{
    NSString * newDBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"crash.log"];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:newDBPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:dbPath toPath:newDBPath error:NULL];
    };
    self.dbPath = newDBPath;
}

- (void)save:(NSException *)exception{
    [[MMDBManager instance] updateWithObj:exception dbPath:[[self class] crashLogPath]];
}

+ (NSString *)crashLogPath{
    return [[MMCrashLogManager instance] dbPath];
}

+ (NSString *)currentDateString{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSArray <NSException *>*)allCrash{
    NSArray * list = [[MMDBManager instance] readAllWithObjClass:[NSException class] dbPath:[self crashLogPath]];
    return list;
}
@end

