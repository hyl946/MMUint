//
//  DownloadTableViewCell.m
//  MMUnitLib
//
//  Created by Loren on 2018/6/1.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "DownloadTableViewCell.h"

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

@interface DownloadTableViewCell()
{
    UIView * progressBackGroundView;
    UIView * progressView;
    UIButton * start_bt;
    UIButton * cancel_bt;
    UIButton * pause_bt;
    UIButton * goon_bt;
    UIButton * reset_bt;
    UILabel * label ;
}
@end

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        progressBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 10,_screen_width_ -30, 20)];
        progressBackGroundView.backgroundColor = [UIColor grayColor];
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screen_width_ -30, 20)];
        progressView.backgroundColor = [UIColor lightGrayColor];
        progressView.layer.cornerRadius = progressBackGroundView.layer.cornerRadius = 10;
        progressView.layer.borderWidth = progressBackGroundView.layer.borderWidth = 1;
        progressView.layer.borderColor = progressBackGroundView.layer.borderColor = [UIColor grayColor].CGColor;
        [progressBackGroundView addSubview:progressView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0,30, 200, 10)];
        label.font = [UIFont systemFontOfSize:9];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.center = CGPointMake(_screen_width_/2.0, 35);
        label.text = [NSString stringWithFormat:@"%@当前进度0%%",_model.taskName];
        [self.contentView addSubview:label];
        
        NSArray * array1 = @[@"开始",@"暂停",@"继续",@"取消",@"重下"];
        NSArray * array2 = @[@"start",@"pause",@"goon",@"cancel",@"reset"];
        CGFloat width = 30;
        CGFloat space = (_screen_width_ - 30 * 5 ) / 6.0;
        for (int i = 0; i< 5; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(space*(i+1)+i*width, 40, width, 30);
            [button setTitle:array1[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button addTarget:self action:NSSelectorFromString(array2[i]) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        
        [self.contentView addSubview:progressBackGroundView];
    }
    return self;
}
+ (CGFloat )cellHeight{
    return 80;
}
- (void)setModel:(DownloadCellModel *)model{
    _model = model;
    [self updateProgress:model.progress];
}
- (void)updateProgress:(CGFloat)progress{
    CGFloat p = progressBackGroundView.mm_sizeW * progress / 100;
    progressView.mm_sizeW = p;
    label.text = [NSString stringWithFormat:@"%@当前进度%.1lf%%",_model.taskName,progress];
}
- (void)start{
    [self.model start];
}
- (void)cancel{
    [self.model cancel];
}
- (void)pause{
    [self.model pause];
}
- (void)goon{
    [self.model goon];
}
- (void)reset{
    [self.model reset];
}
@end
