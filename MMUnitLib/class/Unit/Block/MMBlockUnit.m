//
//  MMBlockUnit.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/30.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMBlockUnit.h"

typedef NS_OPTIONS(int, AspectBlockFlags) {
    AspectBlockFlagsHasCopyDisposeHelpers = (1 << 25),
    AspectBlockFlagsHasSignature          = (1 << 30)
};
typedef struct _AspectBlock {
    __unused Class isa;
    AspectBlockFlags flags;
    __unused int reserved;
    void (__unused *invoke)(struct _AspectBlock *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        // requires AspectBlockFlagsHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // requires AspectBlockFlagsHasSignature
        const char *signature;
        const char *layout;
    } *descriptor;
    // imported variables
} *AspectBlockRef;

static NSMethodSignature *aspect_blockMethodSignature(id block, NSError **error) {
    AspectBlockRef layout = (__bridge void *)block;
    if (!(layout->flags & AspectBlockFlagsHasSignature)) {
        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't contain a type signature.", block];
        *error = [NSError errorWithDomain:@"blockMethodSignature" code:1 userInfo:@{@"errorInfo":description}];
        return nil;
    }
    void *desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    if (layout->flags & AspectBlockFlagsHasCopyDisposeHelpers) {
        desc += 2 * sizeof(void *);
    }
    if (!desc) {
        NSString *description = [NSString stringWithFormat:@"The block %@ doesn't has a type signature.", block];
        *error = [NSError errorWithDomain:@"blockMethodSignature" code:1 userInfo:@{@"errorInfo":description}];
        return nil;
    }
    const char *signature = (*(const char **)desc);
    return [NSMethodSignature signatureWithObjCTypes:signature];
}

@implementation MMBlockUnit
+ (NSMethodSignature *)mm_blockMethodSignature:(id)block error:(NSError **)error{
    NSMethodSignature * methodSigna = aspect_blockMethodSignature(block, error);
    return methodSigna;
}
@end
