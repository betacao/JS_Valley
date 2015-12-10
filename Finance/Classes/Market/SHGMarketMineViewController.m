//
//  SHGMarketMineViewController.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketMineViewController.h"
#import "SHGMarketTableViewCell.h"

@interface SHGMarketMineViewController ()<UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SHGMarketMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.dataArr.count;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMarketCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGMarketTableViewCell";
    SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
