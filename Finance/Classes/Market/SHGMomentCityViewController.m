//
//  SHGMomentCityViewController.m
//  Finance
//
//  Created by weiqiankun on 16/1/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMomentCityViewController.h"
#import "SHGMomentCityTableViewCell.h"
#define K_topViewHeight 44.0f * XFACTOR
#define K_leftMargin 15.0f
@interface SHGMomentCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UIButton *GPSButton;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;


@end

@implementation SHGMomentCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前城市";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    [self initUi];
}

- (void)initUi
{
    CGRect frame = self.topView.frame;
    frame.size.height = K_topViewHeight;
    self.topView.frame = frame;
    
    frame = self.bottomView.frame;
    frame.origin.y = self.topView.bottom;
    self.bottomView.frame = frame;
    
    self.localLabel.text = @"南京";
    self.localLabel.textAlignment = NSTextAlignmentLeft;
    self.localLabel.font = [UIFont systemFontOfSize:15.0f * XFACTOR];
    self.localLabel.textColor = [UIColor colorWithHexString:@"141414"];
    [self.localLabel sizeToFit];
    frame = self.localLabel.frame;
    frame.origin.y = (K_topViewHeight - frame.size.height) / 2.0f;
    frame.origin.x = K_leftMargin;
    self.localLabel.frame = frame;

    [self.GPSButton setTitle:@"重新定位" forState:UIControlStateNormal];
    self.GPSButton.titleLabel.font = [UIFont systemFontOfSize:15.0f * XFACTOR];
    [self.GPSButton setTitleColor:[UIColor colorWithHexString:@"4B88B7"] forState:UIControlStateNormal];
    [self.GPSButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.GPSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.GPSButton sizeToFit];
    frame = self.GPSButton.frame;
    frame.origin.y = (K_topViewHeight - frame.size.height) / 2.0f;
    frame.origin.x = SCREENWIDTH - frame.size.width - K_leftMargin;
    self.GPSButton.frame = frame;
    
    self.allLabel.text = @"全部城市";
    self.allLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.allLabel.textAlignment = NSTextAlignmentLeft;
    self.allLabel.font = [UIFont systemFontOfSize:14.0f * XFACTOR];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
}

- (void)buttonClick:(UIButton * )btn
{
    
}


#pragma mark ---UitableViewDelegate---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGMomentCityTableViewCell";
    SHGMomentCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SHGMomentCityTableViewCell" owner:self options:nil] lastObject];
    }
    [cell loadWithUi];
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return K_topViewHeight;
}

@end
