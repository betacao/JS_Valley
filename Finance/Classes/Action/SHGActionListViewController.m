//
//  SHGActionViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionListViewController.h"
#import "SHGActionTableViewCell.h"
#import "SHGActionObject.h"
//#define kActionViewCellHeight 300.0 * XFACTOR
@interface SHGActionListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end

@implementation SHGActionListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    [self loadDataWithType:@"first" meetID:@""];
}

- (void)loadDataWithType:(NSString *)target meetID:(NSString *)meetID
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityAll"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *pageSize = @"10";
    NSString *type = @"all";
    NSDictionary *dictionary = @{@"uid":uid, @"meetId":meetID, @"pageSize":pageSize, @"target":target, @"type":type};
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"请稍等..."];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGActionObject class] parameters:dictionary success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        } else{
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        }
        [weakSelf.listTable reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"网络连接失败"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionTableViewCell";
    SHGActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
    [cell loadDataWithObject:object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 251.0;
}


@end
