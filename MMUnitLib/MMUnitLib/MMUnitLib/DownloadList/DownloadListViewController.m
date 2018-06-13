//
//  DownloadListViewController.m
//  MMUnitLib
//
//  Created by Loren on 2018/6/1.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadTableViewCell.h"

@interface DownloadListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tablewView;
@property (nonatomic, strong)NSArray * dataSource;
@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载列表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"全部开始" style:1 target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    NSMutableArray * data = [NSMutableArray array];
    //创建任务列表
    for(int i = 0; i<10 ; i ++){
        DownloadCellModel * model = [DownloadCellModel modelWithDownloadAddress:^NSString *{
            return @"https://dldir1.qq.com/qqfile/qq/TIM2.2.0/23805/TIM2.2.0.exe";
        } saveFilePath:^NSURL *(NSString *fileUrlString) {
            return [NSURL URLWithString:@"/Users/loren/Desktop/download/QQ.exe"];
        } progess:^(double progress) {
            //...
        } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //...
        }];
        model.taskName = [NSString stringWithFormat:@"当前任务%d",i+1];
        [data addObject:model];
    }
    self.dataSource = data;
    
    self.tablewView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _screen_width_, _screen_height_) style:UITableViewStylePlain];
    self.tablewView.delegate = self;
    self.tablewView.dataSource = self;
    [self.tablewView reloadData];
    [self.view addSubview:self.tablewView];
}
- (void)rightClick:(id)sender{
    for (DownloadCellModel * model in self.dataSource) {
        [model start];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DownloadTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadTableViewCell * cell = [[DownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(DownloadTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataSource[indexPath.row];
    cell.model.tableCell = cell;
}
@end
