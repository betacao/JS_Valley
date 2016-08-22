//
//  SHGCompanyDisplayViewController.m
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCompanyDisplayViewController.h"
#import "SHGCompanyBrowserViewController.h"
#import "SHGEmptyDataView.h"
#import "SHGCompanyManager.h"

@interface SHGCompanyDisplayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SHGEmptyDataView *emptyDataView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SHGCompanyDisplayHeaderView *headerView;
@property (assign, nonatomic) NSInteger pageNumber;
@end

@implementation SHGCompanyDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
    [self loadData];
}

- (void)initView
{
    self.title = @"企业查询";
    self.tableView.hidden = YES;
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.emptyDataView.type = SHGEmptyDataCompanySearch;
    self.headerView = [[SHGCompanyDisplayHeaderView alloc] init];
    self.pageNumber = 1;
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.emptyDataView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)refreshFooter
{
    self.pageNumber++;
    [self loadData];
}

- (void)loadData
{
    WEAK(self, weakSelf);
    [SHGCompanyManager loadBlurCompanyInfo:@{@"companyName":self.companyName, @"page":@(self.pageNumber), @"pageSize":@(10)} success:^(NSArray *array) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (array) {
            [weakSelf.dataArr addObjectsFromArray:array];
            if (weakSelf.dataArr.count > 0) {
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
            } else {
                weakSelf.tableView.hidden = YES;
            }
            if (array.count == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return MarginFactor(52.0f);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(62.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGCompanyDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGCompanyDisplayTableViewCell"];
    if (!cell) {
        cell = [[SHGCompanyDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGCompanyDisplayTableViewCell"];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGCompanyObject *object = [self.dataArr objectAtIndex:indexPath.row];
    if (self.block) {
        self.block(object.companyName);
    } else {
        SHGCompanyBrowserViewController *controller = [[SHGCompanyBrowserViewController alloc] init];
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)btnBackClick:(id)sender
{
    if (self.block && self.dataArr.count > 0) {
        SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"请确认公司名称" contentText:@"您输入的公司名称可能不完整，请从查询结果中选择正确的公司名称" leftButtonTitle:@"重选" rightButtonTitle:@"没有列出"];
        alertView.rightBlock = ^{
            self.block(self.companyName);
        };
        [alertView show];
    } else {
        [super btnBackClick:sender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@interface SHGCompanyDisplayHeaderView()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *spliteView;
@property (strong, nonatomic) UIView *line2;

@end

@implementation SHGCompanyDisplayHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(15.0f);
    self.label.textColor = Color(@"161616");
    self.label.text = @"请选择";

    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = Color(@"e6e7e8");

    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = Color(@"f7f7f7");

    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = Color(@"e6e7e8");

    [self sd_addSubviews:@[self.label, self.line1, self.spliteView, self.line2]];
}

- (void)addAutoLayout
{
    self.line2.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .heightIs(1 / SCALE);

    self.spliteView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self.line2, 0.0f)
    .heightIs(MarginFactor(9.0f));

    self.line1.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self.spliteView, 0.0f)
    .heightIs(1 / SCALE);

    self.label.sd_layout
    .leftSpaceToView(self, MarginFactor(17.0f))
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self.line1, 0.0f)
    .topSpaceToView(self, 0.0f);

}


@end


@interface SHGCompanyDisplayTableViewCell()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIView *spliteView;

@end

@implementation SHGCompanyDisplayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self addAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView
{
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(15.0f);
    self.label.textColor = Color(@"161616");
    self.label.text = @"请选择";

    self.spliteView = [[UIView alloc] init];
    self.spliteView.backgroundColor = Color(@"e6e7e8");

    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrowImage"]];

    [self.contentView sd_addSubviews:@[self.label, self.spliteView, self.arrowImageView]];
}

- (void)addAutoLayout
{
    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    self.label.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(17.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.spliteView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f);

    self.arrowImageView.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(17.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(self.arrowImageView.image.size.width)
    .heightIs(self.arrowImageView.image.size.height);
}

- (void)setObject:(SHGCompanyObject *)object
{
    _object = object;
    self.label.text = object.companyName;
}

@end
