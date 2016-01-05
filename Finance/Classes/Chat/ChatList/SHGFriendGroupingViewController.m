//
//  SHGFriendGroupingViewController.m
//  Finance
//
//  Created by changxicao on 16/1/4.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGFriendGroupingViewController.h"
#import "MessageObj.h"
#import "SHGFriendGropingTableViewCell.h"
#import "SHGGropingViewController.h"
#define kBGViewWidth 85.0f * XFACTOR
#define kBGViewHeight 135.0f


@interface SHGFriendGroupingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *departmentButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSString *module;

@end

@implementation SHGFriendGroupingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"人脉分组";

    CGRect frame = self.bgView.frame;
    frame.size.width = kBGViewWidth;
    self.bgView.frame = frame;

    frame = self.tableView.frame;
    frame.origin.x = kBGViewWidth;
    frame.size.width = SCREENWIDTH - kBGViewWidth;
    self.tableView.frame = frame;

    frame = self.lineView1.frame;
    frame.size.height = 0.5f;
    self.lineView1.frame = frame;

    frame = self.lineView2.frame;
    frame.size.height = 0.5f;
    self.lineView2.frame = frame;

    frame = self.lineView3.frame;
    frame.size.height = 0.5f;
    self.lineView3.frame = frame;

    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.companyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateSelected];
    [self.departmentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateSelected];
    [self.locationButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateSelected];

    [self.companyButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.departmentButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.locationButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];

    [self.companyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateHighlighted];
    [self.departmentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateHighlighted];
    [self.locationButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]] forState:UIControlStateHighlighted];
    //默认选中公司
    self.companyButton.selected = YES;
    self.module = @"company";
    self.currentPage = 1;
    [self loadDataWithPage:@"1" module:self.module type:self.type];
}

- (void)refreshFooter
{
    self.currentPage++;
    [self loadDataWithPage:[NSString stringWithFormat:@"%ld",(long)self.currentPage] module:self.module type:self.type];
}
#pragma mark ------tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBGViewHeight / 3.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGFriendGropingTableViewCell";
    SHGFriendGropingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGFriendGropingTableViewCell" owner:self options:nil] lastObject];
    }
    SHGFriendGropingObject *object = [self.dataArr objectAtIndex:indexPath.row];
    [cell loadDataWithModule: object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGGropingViewController *controller = [[SHGGropingViewController alloc] init];
    SHGFriendGropingObject *object = [self.dataArr objectAtIndex:indexPath.row];
    controller.condition = object.module;
    controller.module = self.module;
    controller.type = self.type;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickCompanyButton:(UIButton *)button
{
    button.selected = YES;
    self.departmentButton.selected = NO;
    self.locationButton.selected = NO;
    if (![self.module isEqualToString:@"company"]) {
        self.module = @"company";
        self.currentPage = 1;
        [self.dataArr removeAllObjects];
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage] module:self.module type:self.type];
    }
}

- (IBAction)clickDepartmentButton:(UIButton *)button
{
    button.selected = YES;
    self.companyButton.selected = NO;
    self.locationButton.selected = NO;
    if (![self.module isEqualToString:@"position"]) {
        self.module = @"position";
        self.currentPage = 1;
        [self.dataArr removeAllObjects];
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage] module:self.module type:self.type];
    }
}

- (IBAction)clickLocationButton:(UIButton *)button
{
    button.selected = YES;
    self.departmentButton.selected = NO;
    self.companyButton.selected = NO;
    if (![self.module isEqualToString:@"area"]) {
        self.module = @"area";
        self.currentPage = 1;
        [self.dataArr removeAllObjects];
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage] module:self.module type:self.type];
    }
}


- (void)loadDataWithPage:(NSString *)page module:(NSString *)module type:(NSString *)type
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"pagenum":page, @"uid":UID, @"pagesize":@"20", @"module":module, @"type":type};
    [MOCHTTPRequestOperationManager getWithURL:[rBaseAddressForHttp stringByAppendingString:@"/friends/searchModuleCategroy"] class:[SHGFriendGropingObject class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];

        if (response.dataArray.count < 10) {
            [weakSelf.tableView.footer endRefreshingWithNoMoreData];
        }
        [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [Hud showMessageWithText:@"获取数据失败"];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end