//
//  ViewController.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "ViewController.h"
#import "DownloadListViewController.h"

@interface UIView(Addition)
@property (nonatomic, assign)CGFloat mm_sizeW;
@end
@implementation UIView(Addition)
- (void)setMm_sizeW:(CGFloat)mm_sizeW{
    CGRect rect = self.frame;
    rect.size.width = mm_sizeW;
    self.frame = rect;
}
- (CGFloat)mm_sizeW{
    return self.frame.size.width;
}
@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *progessBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) MMNSURLDownloadSessionManager * downManager;
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;
@property (nonatomic, strong) NSMutableArray * downLoadList;
/*
[{
 @"downloadUrl":@"http://";
 @"downloadTask":NSURLDownloadTask,
 @"downloadTaskName":@"任务1"
 
}]
 */
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progessBackgroundView.layer.cornerRadius = 9;
    self.progessBackgroundView.layer.borderWidth = 1;
    self.progessBackgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    self.progressView.layer.cornerRadius = 9;
    self.progressView.layer.borderWidth = 1;
    self.progressView.layer.borderColor = [UIColor grayColor].CGColor;
    self.progressView.mm_sizeW = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;

    NSURLSessionDownloadTask * downloadTask = [[MMNSURLDownloadSessionManager manager] addDownloadTaskWithUrlString:@"https://dldir1.qq.com/qqfile/qq/TIM2.2.0/23805/TIM2.2.0.exe" saveFilePath:^NSURL *(NSString *fileUrlString) {
        return [weakSelf saveFilePath];
    } progess:^(double progress) {
        [weakSelf updateProgress:progress];
    } completion:^(NSURLResponse *response, NSURL * filePath, NSError * error) {
        [weakSelf taskCompletion:filePath response:response error:error];
    }];
    self.downloadTask = downloadTask;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"下载列表" style:1 target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)rightClick:(id)sender{
    [self.navigationController pushViewController:[[DownloadListViewController alloc] init] animated:YES];
}
- (IBAction)start:(id)sender {
    if (self.downloadTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    [[MMNSURLDownloadSessionManager manager] startWithTask:self.downloadTask];
}
- (IBAction)goon:(id)sender {
    __weak typeof(self)weakSelf = self;
    [[MMNSURLDownloadSessionManager manager] goonWithTask:self.downloadTask saveFilePath:^NSURL *(NSString *fileUrlString) {
        return [weakSelf saveFilePath];
    } progess:^(double progress) {
        [weakSelf updateProgress:progress];
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [weakSelf taskCompletion:filePath response:response error:error];
    } newTask:^(NSURLSessionDownloadTask *task) {
        weakSelf.downloadTask = task;
    }];
}
- (IBAction)susspend:(id)sender {
    [[MMNSURLDownloadSessionManager manager] pauseWithTask:self.downloadTask];
}
- (IBAction)cancel:(id)sender {
    [[MMNSURLDownloadSessionManager manager] cancelWithTask:self.downloadTask];
    self.progressView.mm_sizeW = 0;
    
}
- (IBAction)reset:(id)sender {
    __weak typeof(self)weakSelf = self;
    [[MMNSURLDownloadSessionManager manager] resetWithTask:self.downloadTask saveFilePath:^NSURL *(NSString *fileUrlString) {
        return [weakSelf saveFilePath];
    } progess:^(double progress) {
        [weakSelf updateProgress:progress];
    } completion:^(NSURLResponse *response, NSURL * filePath, NSError * error) {
        [weakSelf taskCompletion:filePath response:response error:error];
    } newTask:^(NSURLSessionDownloadTask *task) {
        weakSelf.downloadTask = task;
    }];
}

- (NSURL *)saveFilePath{
    return [NSURL URLWithString:@"/Users/loren/Desktop/download/QQ.exe"];
}
- (void)updateProgress:(double)progress{
    self.tipLabel.text = [NSString stringWithFormat:@"当前进度%.1f%%",progress];
    self.progressView.mm_sizeW = self.progessBackgroundView.mm_sizeW * progress / 100;
}
- (void)taskCompletion:(NSURL *)filePath response:(NSURLResponse *)response error:(NSError *)error{
    NSLog(@"%@-%@-%@",filePath,response,error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

