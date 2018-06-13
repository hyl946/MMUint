//
//  MMUnitDefineConfig.h
//  MMUnitLib
//
//  Created by Loren on 2018/6/13.
//  Copyright © 2018年 Loren. All rights reserved.
//

#ifndef MMUnitDefineConfig_h
#define MMUnitDefineConfig_h

//NSLog
#define MM_NSLog(format,...) NSLog(format, ## __VA_ARGS__)

//sync safe
#define mm_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
//block safe
#define mm_block_safe(block,...) if(block){block(__VA_ARGS__);};
//UIKit
#define _screen_width_ [UIScreen mainScreen].bounds.size.width
#define _screen_height_ [UIScreen mainScreen].bounds.size.height

#endif /* MMUnitDefineConfig_h */
