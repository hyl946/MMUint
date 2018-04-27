//
//  FMDBManager.m
//  CrashLogDemo
//
//  Created by Loren on 2018/4/2.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMDBManager.h"
#import <FMDB/FMDB.h>
#import <objc/runtime.h>
#import "MMJsonModel.h"

#define TimeValueKey @"timeValue"

@implementation MMDBManager
static FMDatabase * db;
static MMDBManager * manager;
+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MMDBManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)isExistWithDbPath:(NSString *)dbPath{
    return [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
}

- (BOOL)isExistWithObjClass:(Class)objClass dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass(objClass);
    
    BOOL isExist =  [self isExistWithDbPath:dbPath];
    if (isExist) {
        db = [FMDatabase databaseWithPath:dbPath];
        if([db open]){
            isExist = [db tableExists:tableName];
            [db close];
            return isExist;
        }
        return NO;
    }
    else {
        return isExist;
    }
    return isExist;
}

- (BOOL)creatWithObjClass:(Class)objClass dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass(objClass);
    BOOL isFileExist = [self isExistWithDbPath:dbPath];
    BOOL isTableExist = [self isExistWithObjClass:objClass dbPath:dbPath];
    
    if (isFileExist) {
        if (isTableExist) {
            NSLog(@"Table is Exist");
            return isTableExist;
        }
        else {
            //创建表
            db = [FMDatabase databaseWithPath:dbPath];
            if ([db open]) {
                NSMutableString * sql = [NSMutableString stringWithFormat:@"create table if not exists %@('%@' TEXT primary key,",tableName,TimeValueKey];
                NSArray * propertyList =  [self delRepeatObjWithArray:[self class_copyPropertyList:objClass]];
                for (int i = 0; i<propertyList.count; i++) {
                    NSString * propertyStr = propertyList[i];
                    if (i == (propertyList.count-1)) {
                        [sql appendFormat:@"%@ TEXT);",propertyStr];
                    } else {
                        [sql appendFormat:@"%@ TEXT,",propertyStr];
                    }
                }
                BOOL isOk = [db executeUpdate:sql];
                return isOk;
            }
            else {
                return NO;
            }
        }
    }
    else {
        NSLog(@"File is not Exist");
        return NO;
    }
    return NO;
}

- (BOOL)updateWithObj:(id)obj dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass([obj class]);

    NSTimeInterval timeValue = [[NSDate date] timeIntervalSince1970];
    
    NSDictionary * propertry_value_dic = [self objc_copyPropertyAndValue:obj];
    
    NSArray * propertyList = [self class_copyPropertyList:objc_getClass(tableName.UTF8String)];

    NSMutableString * sql = [NSMutableString stringWithFormat:@"insert into %@ (%@,",tableName,TimeValueKey];
    
    NSString * propertycomponentsString = [[propertyList componentsJoinedByString:@","] stringByAppendingString:@")"];
    
    [sql appendString:propertycomponentsString];
    
    [sql appendFormat:@"values (%f,",timeValue];
    
    for (int i = 0; i<propertyList.count; i++) {
        [sql appendFormat:@"'%@'%@",propertry_value_dic[propertyList[i]],(i == propertyList.count -1)?@"":@","];
    }
    [sql appendString:@");"];
    BOOL  isOk = [self updateWithObjClass:[obj class] dbPath:dbPath sql:sql];
    return isOk;
}

- (BOOL)updateWithObjClass:(Class)objClass dbPath:(NSString *)dbPath sql:(NSString *)sql{
    
    BOOL isExist = [self isExistWithObjClass:objClass dbPath:dbPath];
    if (!isExist) {
      BOOL isOk = [self creatWithObjClass:objClass dbPath:dbPath];
        if (isOk == NO) {
            return isOk;
        }
    }
    
    db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        BOOL isOk = [db executeUpdate:sql];
        [db close];
        return isOk;
    }
    else {
        return NO;
    }
    
    return isExist;
}

- (NSArray *)readAllWithObjClass:(Class)objClass dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass(objClass);

    NSMutableArray * array = [NSMutableArray array];
    
    NSString * sql = [NSString stringWithFormat:@"select * from %@",tableName];
    
    BOOL isExist = [self isExistWithObjClass:objClass dbPath:dbPath ];
    if (isExist) {
        db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            FMResultSet * resultSet = [db executeQuery:sql];
            while ([resultSet next]) {
                Class className = objc_getClass(tableName.UTF8String);
                //读出的数据合成不了一个对象，可看 NSException 初始化方法
                @try {
                    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
                    NSArray * propertyList = [self class_copyPropertyList:className];
                    NSTimeInterval timeValue = [resultSet doubleForColumn:TimeValueKey];
                    [dictionary setObject:@(timeValue) forKey:TimeValueKey];
                    for (NSString * key in propertyList) {
                        id value = [resultSet stringForColumn:key];
                        if (value == nil || value == NULL || value == [NSNull null]) {
                            continue;
                        }
                        [dictionary setObject:value forKey:key];
                    }
                    [array addObject:dictionary];
                } @catch (NSException *exception) {
                    
                } @finally {
//                    NSLog(@"%@",array);
                }
            }
            [db close];
            return array;
        }
        else {
            return array;
        }
    }
    return array;
}
- (NSArray *)readAllObjWithObjClass:(Class)objClass dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass(objClass);
    
    NSMutableArray * array = [NSMutableArray array];
    
    NSString * sql = [NSString stringWithFormat:@"select * from %@",tableName];
    
    BOOL isExist = [self isExistWithObjClass:objClass dbPath:dbPath ];
    if (isExist) {
        db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            FMResultSet * resultSet = [db executeQuery:sql];
            while ([resultSet next]) {
                Class className = objc_getClass(tableName.UTF8String);
                //读出的数据合成不了一个对象，可看 NSException 初始化方法
                @try {
                    
                    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
                    NSArray * propertyList = [self delRepeatObjWithArray:[self class_copyPropertyList:className]];
                    NSTimeInterval timeValue = [resultSet doubleForColumn:TimeValueKey];
                    [dictionary setObject:@(timeValue) forKey:TimeValueKey];
                    for (NSString * key in propertyList) {
                        id value = [resultSet stringForColumn:key];
                        if (value == nil || value == NULL || value == [NSNull null]) {
                            continue;
                        }
                        [dictionary setObject:value forKey:key];
                    }
                    id obj = [MMJsonModel jsonToModel:dictionary class:objClass];
                    [array addObject:obj];
                } @catch (NSException *exception) {
                    
                } @finally {
                    //                    NSLog(@"%@",array);
                }
            }
            [db close];
            return array;
        }
        else {
            return array;
        }
    }
    return array;
}
- (BOOL)delAllWithObjClass:(Class)objClass dbPath:(NSString *)dbPath{
    NSString * tableName = NSStringFromClass(objClass);
    
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    
    BOOL isExist = [self isExistWithObjClass:objClass dbPath:dbPath];
    
    if (isExist) {
        db = [FMDatabase databaseWithPath:dbPath];
        if ([db open]) {
            BOOL isOK = [db executeUpdate:sql];
            [db close];
            return isOK;
        }
        else {
            return !isExist;
        }
    }
    return !isExist;
}

- (NSArray <NSString *>*)class_copyPropertyList:(Class)objClass{
    uint count;
    NSMutableArray * propertyList = [NSMutableArray array];
    objc_property_t * propertys = class_copyPropertyList(objClass, &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString * propertyStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertyList addObject:propertyStr];
    }
    return propertyList;
}

- (NSDictionary*)objc_copyPropertyAndValue:(id)obj{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    NSArray * propertyList = [self class_copyPropertyList:[obj class]];
    for (NSString * propertyName in propertyList) {
        id value = [obj valueForKey:propertyName];
        if (value != nil && value != NULL) {
            [dictionary setObject:value forKey:propertyName];
        }
    }
    return dictionary;
}
- (id)propertyTypeForClass:(Class)className propertyName:(NSString *)propertyName{
    
    return @"";
}
- (NSArray *)arrayFormString:(NSString *)json{
    NSArray * array = [json componentsSeparatedByString:@","];
    return array;
}
- (NSDictionary *)dictionaryFromString:(NSString *)json{
    NSData * data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return dic;
}
- (NSArray *)delRepeatObjWithArray:(NSArray <NSString *>*)array{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString * key in array) {
        [dict setValue:@"1" forKey:key];
    }
    return [dict allKeys];
}
@end
