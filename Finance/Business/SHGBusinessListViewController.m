//
//  SHGBusinessListViewController.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessListViewController.h"
#import "SHGBusinessScrollView.h"
#import "SHGBusinessFilterView.h"
#import "SHGBusinessObject.h"
#import "EMSearchBar.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessMainSendView.h"
#import "SHGNoticeView.h"
#import "SHGEmptyDataView.h"

@interface SHGBusinessListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SHGBusinessScrollViewDelegate>
//
@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SHGBusinessScrollView *scrollView;
@property (strong, nonatomic) SHGBusinessFilterView *filterView;
@property (strong, nonatomic) SHGNoticeView *noticeView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (assign, nonatomic) CGSize addBusinessSize;
@property (assign, nonatomic) CGRect filterViewFrame;
//
@property (weak, nonatomic) NSMutableArray *currentArray;
@property (strong, nonatomic) NSMutableDictionary *paramDictionary;
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSString *tipUrl;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSMutableDictionary *positionDictionary;
@end

@implementation SHGBusinessListViewController

#pragma mark ------ 初始化部分
+ (instancetype)sharedController
{
    static SHGBusinessListViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
    if (self.block) {
        self.block(self.searchBar);
    }

    NSArray *array = @[@"推荐", @"债权融资", @"股权融资", @"资金方", @"同业混业"];
    NSMutableArray *categoryArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [categoryArray addObject:[[SHGBusinessFirstObject alloc] initWithName:obj]];
    }];
    self.scrollView.categoryArray = categoryArray;

    for (NSInteger i = 0; i < array.count; i++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [self.dataArr addObject:subArray];
    }

    self.currentArray = [self.dataArr firstObject];
    self.filterView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f);

    __weak typeof(self)weakSelf = self;
    self.filterView.didFinishAutoLayoutBlock = ^(CGRect frame){
        weakSelf.filterViewFrame = frame;
        weakSelf.tableView.sd_resetNewLayout
        .topSpaceToView(weakSelf.view, CGRectGetMinY(frame))
        .leftSpaceToView(weakSelf.view, 0.0f)
        .rightSpaceToView(weakSelf.view, 0.0f)
        .bottomSpaceToView(weakSelf.view, 0.0f);
    };
//    请求数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataWithTarget:@"first"];
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initAddMarketButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.filterView.didFinishAutoLayoutBlock = nil;
}

- (SHGBusinessScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SHGBusinessScrollView sharedBusinessScrollView];
        _scrollView.categoryDelegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (SHGBusinessFilterView *)filterView
{
    __weak typeof(self)weakSelf = self;
    if (!_filterView) {
        _filterView = [[SHGBusinessFilterView alloc] init];
        _filterView.hidden = YES;
        _filterView.selectedBlock = ^(NSDictionary *param){
            [weakSelf.paramDictionary setObject:param forKey:[weakSelf.scrollView currentName]];
            [weakSelf.tableView reloadData];
        };
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}


- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}

- (SHGNoticeView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _noticeView.superView = self.view;
    }
    return _noticeView;
}

- (NSMutableDictionary *)positionDictionary
{
    if (!_positionDictionary) {
        _positionDictionary = [NSMutableDictionary dictionary];
    }
    return _positionDictionary;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton addTarget:self action:@selector(moveToProvincesViewController:) forControlEvents:UIControlEventTouchUpInside];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FontFactor(15.0f);
        self.titleLabel.textColor = [UIColor whiteColor];
        [_titleButton addSubview:self.titleLabel];

        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"market_locationArrow"]];
        [self.titleImageView sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        [_titleButton addSubview:self.titleImageView];
    }
    return _titleButton;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleButton];
    }
    return _leftBarButtonItem;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.needLineView = NO;
        _searchBar.placeholder = @"请输入业务名称/类型/地区关键字";
        _searchBar.backgroundImageColor = Color(@"d43c33");
    }
    return _searchBar;
}

- (NSMutableDictionary *)paramDictionary
{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

#pragma mark ------刷新用到的
- (void)refreshHeader
{
    if (self.currentArray.count == 0) {
        [self loadDataWithTarget:@"first"];
    } else {
        [self loadDataWithTarget:@"refresh"];
    }
}

- (void)refreshFooter
{
    if (self.currentArray.count == 0) {
        [self loadDataWithTarget:@"load"];
    } else {
        [self loadDataWithTarget:@"refresh"];
    }
}

- (NSString *)maxBusinessID
{
    NSString *businessID = @"";
    for (SHGBusinessObject *object in self.currentArray) {
        if ([object.businessId compare:businessID options:NSNumericSearch] == NSOrderedDescending && ![object.businessId isEqualToString:[NSString stringWithFormat:@"%ld",NSIntegerMax]]) {
            businessID = object.businessId;
        }
    }
    return businessID;
}

- (NSString *)minBusinessID
{
    NSString *businessID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    for (SHGBusinessObject *object in self.currentArray) {
        NSString *objectMarketId = object.businessId;
        if ([objectMarketId compare:businessID options:NSNumericSearch] == NSOrderedAscending) {
            businessID = object.businessId;
        }
    }
    return businessID;
}

- (NSString *)maxModifyTime
{
    NSString *modifyTime = @"";
    for (SHGBusinessObject *object in self.currentArray) {
        if ([object.modifyTime compare:modifyTime options:NSNumericSearch] == NSOrderedDescending) {
            modifyTime = object.modifyTime;
        }
    }
    return modifyTime;
}
#pragma mark ------网络请求部分

- (void)loadDataWithTarget:(NSString *)target
{
    
    __weak typeof(self) weakSelf = self;
    if ([target isEqualToString:@"first"]) {
        [self.tableView setContentOffset:CGPointZero];
    }
    if (self.refreshing) {
        return;
    }
    NSString *position = [self.positionDictionary objectForKey:[self.scrollView currentName]];
    NSString *redirect = [position isEqualToString:@"0"] ? @"1" : @"0";
//    NSString *area = [SHGMarketManager shareManager].cityName;
//    if (!area) {
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//        return;
//    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"businessId":[self maxBusinessID] ,@"uid":UID ,@"type":[self.scrollView currentType] ,@"target":target ,@"pageSize":@"10" , @"modifyTime":[self maxModifyTime], @"city":@"", @"redirect":redirect}];
    [param addEntriesFromDictionary:self.paramDictionary];
    self.refreshing = YES;
    [SHGBusinessManager getListDataWithParam:param block:^(NSArray *dataArray, NSString *index, NSString *tipUrl) {
        weakSelf.refreshing = NO;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (dataArray) {
            if ([target isEqualToString:@"first"]) {
                [weakSelf.currentArray removeAllObjects];
                [weakSelf.currentArray addObjectsFromArray:dataArray];
                //第一次给服务器的值
                weakSelf.index = index;
                [weakSelf.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
            } else if([target isEqualToString:@"refresh"]){
                for (NSInteger i = dataArray.count - 1; i >= 0; i--){
                    SHGBusinessObject *obj = [dataArray objectAtIndex:i];
                    [weakSelf.currentArray insertUniqueObject:obj atIndex:0];
                }
                //下拉的话如果之前显示了偏少 则下移 否则不管
                NSInteger position = [[weakSelf.positionDictionary objectForKey:[weakSelf.scrollView currentName]] integerValue];
                if (position > 0) {
                    weakSelf.index = [NSString stringWithFormat:@"%ld", (long)(position + dataArray.count)];
                }
                if (dataArray.count > 0) {
                    [weakSelf.noticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新业务",(long)dataArray.count]];
                } else{
                    [weakSelf.noticeView showWithText:@"暂无新业务，休息一会儿"];
                }
            } else if([target isEqualToString:@"load"]){
                [weakSelf.currentArray addObjectsFromArray:dataArray];
            }
            weakSelf.tipUrl = tipUrl;

            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark ------其他函数部分
- (void)panImageButton:(UIPanGestureRecognizer *)recognizer
{
    UIView *touchedView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {

    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.view];
        if (point.x - self.addBusinessSize.width / 2.0f < 0.0f) {
            point.x = self.addBusinessSize.width / 2.0f;
        }
        if (point.x + self.addBusinessSize.width / 2.0f > SCREENWIDTH) {
            point.x = SCREENWIDTH - self.addBusinessSize.width / 2.0f;
        }
        if (point.y + self.addBusinessSize.height / 2.0f > CGRectGetHeight(self.view.frame) - kTabBarHeight) {
            point.y = CGRectGetHeight(self.view.frame) - kTabBarHeight - self.addBusinessSize.height / 2.0f;
        }
        if (point.y - self.addBusinessSize.height / 2.0f  < kBusinessScrollViewHeight) {
            point.y = kBusinessScrollViewHeight + self.addBusinessSize.height / 2.0f;
        }
        [UIView animateWithDuration:0.01f animations:^{
            touchedView.center = point;
        }];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)initAddMarketButton
{
    if (CGSizeEqualToSize(CGSizeZero, self.addBusinessSize)) {
        self.addBusinessSize = self.addBusinessButton.currentImage.size;
        CGRect frame = self.addBusinessButton.frame;
        frame.size = self.addBusinessSize;
        frame.origin.x = SCREENWIDTH - MarginFactor(17.0f) - self.addBusinessSize.width;
        frame.origin.y = CGRectGetHeight(self.view.frame) - kTabBarHeight - MarginFactor(45.0f) - self.addBusinessSize.height;
        self.addBusinessButton.frame = frame;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageButton:)];
        [self.addBusinessButton addGestureRecognizer:panRecognizer];

        [self.addBusinessButton addTarget:self action:@selector(addBusinessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addBusinessButtonClicked:(UIButton *)button
{
    SHGBusinessMainSendView *view = [SHGBusinessMainSendView sharedView];
    view.alpha = 0.0f;
    [self.view.window addSubview:view];

    [UIView animateWithDuration:0.25f animations:^{
        view.alpha = 1.0f;
    }];
}


- (void)moveToProvincesViewController:(UIButton *)button
{

}

#pragma mark ------tableview代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count == 0) {
        return self.emptyCell;
    } else {

    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentArray.count == 0) {
        return 1;
    } else {
        return self.currentArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count == 0) {
        return CGRectGetHeight(self.view.frame);
    } else {
        return 100.0f;
    }
}

#pragma mark ------变更城市代理

- (void)changeTitleCityName:(NSString *)city
{
    if ([city isEqualToString:@"其他城市"]) {
        city = @"其他";
    }
    if (![city isEqualToString:self.titleLabel.text] && city.length > 0) {
        self.titleButton.frame = CGRectZero;
        self.titleLabel.text = city;
        [self.titleLabel sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        self.titleButton.size = CGSizeMake(CGRectGetMaxX(self.titleImageView.frame) + MarginFactor(17.0f), CGRectGetHeight(self.titleLabel.frame));

        //        [self cle
    } else if (city.length == 0){
        self.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_AREA];
        [self.titleLabel sizeToFit];
    }
}

- (void)didMoveToIndex:(NSInteger)index
{
    self.filterView.expand = NO;
    if (index == 0) {
        self.filterView.hidden = YES;
        self.tableView.sd_resetNewLayout
        .topSpaceToView(self.view, CGRectGetMinY(self.filterViewFrame))
        .leftSpaceToView(self.view, 0.0f)
        .rightSpaceToView(self.view, 0.0f)
        .bottomSpaceToView(self.view, 0.0f);
    } else{
        self.filterView.hidden = NO;
        self.tableView.sd_resetNewLayout
        .topSpaceToView(self.view, CGRectGetMaxY(self.filterViewFrame))
        .leftSpaceToView(self.view, 0.0f)
        .rightSpaceToView(self.view, 0.0f)
        .bottomSpaceToView(self.view, 0.0f);
    }
    [self.tableView updateLayout];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
