//
//  MMJsonModel.m
//  CrashLogDemo
//
//  Created by Loren on 2018/4/27.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMJsonModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MMJsonModel

+ (id)jsonToModel:(NSDictionary *)dict class:(Class)classN{
    id obj = [[classN alloc] init];
    for (NSString * key in dict.allKeys) {
        SEL method = [self setMethodFromPropertyName:key obj:obj];
        if (method) {
            ((void(*)(id , SEL , id))objc_msgSend)(obj,method,dict[key]);
        }
    }
    return obj;
}
+ (NSDictionary *)modelToJson:(NSObject *)model{
    unsigned int count;
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    objc_property_t * propertyList = class_copyPropertyList([model class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t propertyName = propertyList[i];
        NSString * propertyStr = [NSString stringWithUTF8String:property_getName(propertyName)];
        id value = ((id(*)(id,SEL))objc_msgSend)(model,NSSelectorFromString(propertyStr));
        if (value) {
            [dictionary setValue:value forKey:propertyStr];
        }
        else {
            //nothing ..
        }
    }
    return dictionary;
}

+ (SEL)setMethodFromPropertyName:(NSString *)property obj:(NSObject *)obj{
    NSString * methodName = [NSString stringWithFormat:@"set%@:",property.capitalizedString];
    SEL method = NSSelectorFromString(methodName);
    if ([obj respondsToSelector:method]) {
        return method;
    }
    return nil;
}
+ (SEL)getMethodFromPropertyName:(NSString *)property obj:(NSObject *)obj{
    
    return nil;
}
@end
