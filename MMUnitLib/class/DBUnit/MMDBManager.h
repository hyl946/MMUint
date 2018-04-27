//
//  FMDBManager.h
//  CrashLogDemo
//
//  Created by Loren on 2018/4/2.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMDBManager : NSObject

+ (instancetype)instance;

//时间戳 为主键
//
- (BOOL)isExistWithDbPath:(NSString *)dbPath;

- (BOOL)isExistWithObjClass:(Class)objClass dbPath:(NSString *)dbPath;

- (BOOL)creatWithObjClass:(Class)objClass dbPath:(NSString *)dbPath ;

- (BOOL)updateWithObj:(id)obj dbPath:(NSString *)dbPath;

- (BOOL)updateWithObjClass:(Class)objClass dbPath:(NSString *)dbPath sql:(NSString *)sql;

- (NSArray *)readAllWithObjClass:(Class)objClass dbPath:(NSString *)dbPath;

- (NSArray *)readAllObjWithObjClass:(Class)objClass dbPath:(NSString *)dbPath;

- (BOOL)delAllWithObjClass:(Class)objClass dbPath:(NSString *)dbPath;

@end
