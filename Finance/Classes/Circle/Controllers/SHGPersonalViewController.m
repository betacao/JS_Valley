//
//  SHGPersonalViewController.m
//  Finance
//
//  Created by changxicao on 15/11/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonalViewController.h"

@interface SHGPersonalViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *tagViews;
@property (strong, nonatomic) NSArray *listArray;
@end

@implementation SHGPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = @[@"他的动态", @"他的好友", @"共同好友"];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"D2D1D1"];
    }
//    UIView *view = cell.accessoryView;
//    if (!view) {
//        view = [[UIView alloc] init];
//        view.font = [UIFont systemFontOfSize:14.0f];
//        view.textColor = [UIColor colorWithHexString:@"D2D1D1"];
//        cell.accessoryView = label;
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    label.text = @"45人";
//    [label sizeToFit];
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
