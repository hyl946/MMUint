//
//  DownloadTableViewCell.h
//  MMUnitLib
//
//  Created by Loren on 2018/6/1.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCellModel.h"

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic, strong) DownloadCellModel * model;

- (void)updateProgress:(CGFloat)progress;
- (void)start;
- (void)cancel;
- (void)pause;
- (void)goon;
- (void)reset;

+ (CGFloat )cellHeight;

@end
