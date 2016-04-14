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
#import "SHGBusinessTableViewCell.h"
#import "SHGBusinessNoticeTableViewCell.h"
#import "SHGBusinessLocationViewController.h"

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
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSString *tipUrl;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSMutableDictionary *positionDictionary;
@property (strong, nonatomic) NSMutableDictionary *paramDictionary;

@property (strong, nonatomic) NSMutableDictionary *titleDictionary;
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
    [[SHGBusinessManager shareManager] getSecondListBlock:nil];
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
        _filterView.selectedBlock = ^(NSDictionary *param, NSArray *titleArray){
            [weakSelf.paramDictionary setObject:param forKey:[weakSelf.scrollView currentName]];
            [weakSelf setFilterTitleArray:titleArray];
            weakSelf.filterView.expand = YES;
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

- (NSMutableDictionary *)titleDictionary
{
    if (!_titleDictionary) {
        _titleDictionary = [NSMutableDictionary dictionary];
    }
    return _titleDictionary;
}

- (void)setFilterTitleArray:(NSArray *)array
{
    [self.titleDictionary setObject:array forKey:[[SHGBusinessScrollView sharedBusinessScrollView] currentName]];
    [self loadDataWithTarget:@"first"];
}

- (NSArray *)getFilterTitleArray
{
    return [self.titleDictionary objectForKey:[[SHGBusinessScrollView sharedBusinessScrollView] currentName]];
}

- (SHGBusinessNoticeObject *)otherObject
{
    SHGBusinessNoticeObject *otherObject = [[SHGBusinessNoticeObject alloc] init];
    otherObject.businessID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    NSString *position = [self.positionDictionary objectForKey:[self.scrollView currentName]];
    if ([position isEqualToString:@"0"]) {
        otherObject.noticeType = SHGMarketBusinessTypePositionTop;
    } else if ([position integerValue] > 0){
        otherObject.noticeType = SHGMarketBusinessTypePositionAny;
    }
    return otherObject;
}

- (void)setIndex:(NSString *)index
{
    [self.positionDictionary setObject:index forKey:[self.scrollView currentName]];
    SHGBusinessNoticeObject *object = nil;
    for (NSInteger i = 0; i < self.currentArray.count; i++) {
        id obj = [self.currentArray objectAtIndex:i];
        if ([obj isKindOfClass:[SHGBusinessNoticeObject class]]) {
            object = (SHGBusinessNoticeObject *)obj;
            break;
        }
    }
    if (object) {
        [self.currentArray removeObject:object];
    }
    if ([index integerValue] >= 0){
        [self.currentArray insertUniqueObject:[self otherObject] atIndex:[index integerValue]];
    }
}


- (void)setCityName:(NSString *)cityName
{
    if (cityName.length == 0) {
        cityName = @"全国";
    }

    _cityName = cityName;
    
    if (![cityName isEqualToString:self.titleLabel.text]) {
        self.titleButton.frame = CGRectZero;
        self.titleLabel.text = cityName;
        self.titleLabel.frame = CGRectMake(MarginFactor(4.0f), 0.0f, 0.0f, 0.0f);
        [self.titleLabel sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        self.titleButton.size = CGSizeMake(CGRectGetMaxX(self.titleImageView.frame) + MarginFactor(12.0f), CGRectGetHeight(self.titleLabel.frame));

        [self clearAndReloadData];
    }
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
        [self loadDataWithTarget:@"first"];
    } else {
        [self loadDataWithTarget:@"load"];
    }
}

- (NSString *)maxBusinessID
{
    NSString *businessID = @"";
    for (SHGBusinessObject *object in self.currentArray) {
        if ([object.businessID compare:businessID options:NSNumericSearch] == NSOrderedDescending && ![object.businessID isEqualToString:[NSString stringWithFormat:@"%ld",NSIntegerMax]]) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (NSString *)minBusinessID
{
    NSString *businessID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    for (SHGBusinessObject *object in self.currentArray) {
        NSString *objectMarketId = object.businessID;
        if ([objectMarketId compare:businessID options:NSNumericSearch] == NSOrderedAscending) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

#pragma mark ------网络请求部分

- (void)loadDataWithTarget:(NSString *)target
{
    __weak typeof(self) weakSelf = self;
    if (self.refreshing) {
        return;
    }
    NSString *position = [self.positionDictionary objectForKey:[self.scrollView currentName]];
    NSString *city = [self.cityName isEqualToString:@"全国"] ? @"" : self.cityName;
    NSString *redirect = [position isEqualToString:@"0"] ? @"1" : @"0";
    NSString *businessId = [target isEqualToString:@"refresh"] ? [self maxBusinessID] : [self minBusinessID];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"businessId":businessId ,@"uid":UID ,@"type":[self.scrollView currentType] ,@"target":target ,@"pageSize":@"10" , @"city":city, @"redirect":redirect}];
    [param addEntriesFromDictionary:[self.paramDictionary objectForKey:[weakSelf.scrollView currentName]]];
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
                [weakSelf.tableView setContentOffset:CGPointZero];
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
    SHGBusinessLocationViewController *controller = [[SHGBusinessLocationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clearAndReloadData
{
    [self.positionDictionary removeAllObjects];
    if (self.dataArr.count > 0) {

        [self.dataArr enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
            [array removeAllObjects];
        }];
        NSMutableArray *subArray = [self.dataArr objectAtIndex:[self.scrollView currentIndex]];
        if (!subArray || subArray.count == 0) {
            self.currentArray = subArray;
            [self loadDataWithTarget:@"first"];
        }
    }
}

#pragma mark ------tableview代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count == 0) {
        self.emptyView.type = SHGEmptyDateTypeNormal;
        return self.emptyCell;
    }
    SHGBusinessObject *object = [self.currentArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[SHGBusinessNoticeObject class]]) {
        SHGBusinessNoticeObject *obj = (SHGBusinessNoticeObject *)object;
        if (obj.noticeType == SHGMarketBusinessTypePositionAny) {

            SHGBusinessLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGMarketLabelTableViewCell"];
            if (!cell) {
                cell = [[SHGBusinessLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGMarketLabelTableViewCell"];
            }
            cell.text = @"本地区该业务较少，现为您推荐其他地区同业务信息";
            return cell;
        } else{

            SHGBusinessImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGBusinessImageTableViewCell"];
            if (!cell) {
                cell = [[SHGBusinessImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGBusinessImageTableViewCell"];
            }
            cell.tipUrl = self.tipUrl;
            return cell;
        }

    } else{
        NSString *identifier = @"SHGMarketTableViewCell";
        SHGBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessTableViewCell" owner:self options:nil] lastObject];
        }
        cell.object = [self.currentArray objectAtIndex:indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
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
    if (self.currentArray.count > 0) {
        SHGBusinessObject *object = [self.currentArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[SHGBusinessNoticeObject class]]) {
            SHGBusinessNoticeObject *obj = (SHGBusinessNoticeObject *)object;
            if (obj.noticeType == SHGMarketBusinessTypePositionTop) {
                return kImageTableViewCellHeight;
            } else{
                CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:@"本地区该业务较少，现为您推荐其他地区同业务信息" keyPath:@"text" cellClass:[SHGBusinessLabelTableViewCell class] contentViewWidth:SCREENWIDTH];
                return height;
            }
        } else{
            CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGBusinessTableViewCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray.count > 0) {

        SHGBusinessObject *object = [self.currentArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[SHGBusinessNoticeObject class]]) {
            //点击图片才去跳转
            if (((SHGBusinessNoticeObject *)object).noticeType == SHGMarketBusinessTypePositionTop) {
                SHGBusinessLocationViewController *controller = [[SHGBusinessLocationViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } else{
//            [[SHGGloble sharedGloble] recordUserAction:object.businessID type:@"market"];
//            SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc]init];
//            controller.object = object;
//            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark ------变更标签代理

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

    NSMutableArray *subArray = [self.dataArr objectAtIndex:index];
    if (!subArray || subArray.count == 0) {
        self.currentArray = subArray;
        [self loadDataWithTarget:@"first"];
    } else{
        self.currentArray = subArray;
        [self.tableView reloadData];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
