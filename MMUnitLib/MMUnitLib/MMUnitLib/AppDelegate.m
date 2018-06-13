//
//  AppDelegate.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "AppDelegate.h"
#import "MMConverDataUnit.h"
#import "UIColor+Addition.h"
#import "MMXMLAnalysisUnit.h"
#import "MMBlockUnit.h"
#import "MMNSURLSessionTask.h"
#import "ViewController.h"
#import "DownloadListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    while (1) {
        //MMConverDataUnit
        NSString * hexString = [MMConverDataUnit mm_dataConverToHex:[NSData dataWithContentsOfFile:@"/Users/loren/Desktop/美区账号密保问题.png"]];
        NSData * data = [MMConverDataUnit mm_hexConverToData:hexString];
        NSData * data2= [MMConverDataUnit mm_hexConverToData2:hexString];
        UIImage * image = [UIImage imageWithData:data];
        BOOL isPass = [data isEqualToData:data2];
        NSString * hexString2 = [MMConverDataUnit mm_hexConverHexString:@"0xaaa32"];
        UIColor * color = [UIColor mm_hexStringConverColor:@"0xffaaff"];
        
        //MMXMLAnalysisUnit
        [[MMXMLAnalysisUnit alloc] analysXMLWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"mm" ofType:@"xml"]]];
        
        //MMBlockUnit

        __block int key = 0;
        void (^MMBlock2)(void) = ^{//堆block
            key = 2;
            MM_NSLog(@"in key -> %d",key);
        };
        MM_NSLog(@"out key -> %d",key);
        MMBlock2();
        
        NSString * (^MMBlock)(NSString * , NSString * ) = ^(NSString * name , NSString * age){
            MM_NSLog(@"%@ %@",name,age);
            return [name stringByAppendingPathExtension:age];
        };//__NSGlobalBlock__ 全局block
        NSError * error;
        NSMethodSignature * signaure = [MMBlockUnit mm_blockMethodSignature:MMBlock error:&error];
        if (error) {
            MM_NSLog(@"%@",error);
        }
        MMBlockSafeExecute(MMBlock,@"Loren",@"99");

        MM_NSLog(@"MMBlock %@",MMBlock);//__NSGlobalBlock__全局block
        MM_NSLog(@"NSString * (^)(NSString * name , NSString * age) -> %@",^(NSString * name , NSString * age){//__NSGlobalBlock__全局block
            NSLog(@"%d",key);//如果用了外部变量 并且没有把block赋值给变量之前，此block为__NSStackBlock__ 栈block
            NSLog(@"%@%@",name,age);
        });
        MM_NSLog(@"MMBlock2%@",MMBlock2);//堆block
        
        //MMNSURLSessionTask
//        MMNSURLSessionTask * task = [[MMNSURLSessionTask alloc] init];
//        [task mm_postWithUrl:@"http://116.228.151.160:48041/mapi/querySignRandomNum" params:@{} completion:^(id data,BOOL success, NSError * error,NSInteger errorCode,NSString * errorDes) {
//            MM_NSLog(@"%@ %@ %ld %@",data,error,(long)errorCode,errorDes);
//        }];

    UIViewController * vc = [[DownloadListViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
        MM_NSLog(@"一次循环结束");
//    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
