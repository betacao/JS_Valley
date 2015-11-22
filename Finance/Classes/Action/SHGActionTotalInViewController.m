//
//  SHGActionTotalInViewController.m
//  Finance
//
//  Created by changxicao on 15/11/19.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionTotalInViewController.h"
#import "SHGActionSignTableViewCell.h"

@interface SHGActionTotalInViewController ()<UITableViewDataSource, UITableViewDelegate>
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
    }
    [cell loadCellWithDictionary:[self.attendList objectAtIndex:indexPath.row]];
    return  cell;
}


@end
