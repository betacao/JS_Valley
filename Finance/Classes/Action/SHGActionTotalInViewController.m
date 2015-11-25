//
//  SHGActionTotalInViewController.m
//  Finance
//
//  Created by changxicao on 15/11/19.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionTotalInViewController.h"
#import "SHGActionSignTableViewCell.h"
#import "SHGActionManager.h"

@interface SHGActionTotalInViewController ()<UITableViewDataSource, UITableViewDelegate, SHGActionSignCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SHGActionTotalInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看全部";
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionSignTableViewCell";
    SHGActionSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionSignTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell loadCellWithObject:[self.attendList objectAtIndex:indexPath.row] publisher:self.publisher];
    return  cell;
}

#pragma mark ------signDelegate
- (void)meetAttend:(SHGActionAttendObject *)object clickCommitButton:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] userCheckOtherState:object option:@"1" reason:nil finishBlock:^(BOOL success) {
        [weakSelf.tableView reloadData];
        if (weakSelf.block) {
            weakSelf.block();
        }
    }];
}

- (void)meetAttend:(SHGActionAttendObject *)object clickRejectButton:(UIButton *)button reason:(NSString *)reason
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] userCheckOtherState:object option:@"0" reason:reason finishBlock:^(BOOL success) {
        [weakSelf.tableView reloadData];
        if (weakSelf.block) {
            weakSelf.block();
        }
    }];
}



@end
