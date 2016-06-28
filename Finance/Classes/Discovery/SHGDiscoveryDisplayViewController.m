//
//  SHGDiscoveryDisplayViewController.m
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryDisplayViewController.h"
#import "SHGDiscoveryManager.h"
#import "EMSearchBar.h"
#import "SHGRecommendCollectionView.h"
#import "SHGEmptyDataView.h"
#import "SHGPersonalViewController.h"
#import "SHGAuthenticationView.h"

@interface SHGDiscoveryDisplayViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) NSString *searchText;

@property (assign, nonatomic) BOOL hideSearchBar;
@property (strong, nonatomic) SHGRecommendCollectionView *recommendCollectionView;
@property (strong, nonatomic) NSArray *recommendContactArray;

@end

@implementation SHGDiscoveryDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.object.industryName;
    [self initView];
    [self addAutoLayout];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataArr.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.dataArr.count > 0) {
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
                SHGDiscoveryDepartmentObject *departmentObject = (SHGDiscoveryDepartmentObject *)obj;
                if (departmentObject.isAttention) {
                    departmentObject.hideAttation = YES;
                }
            }
        }];
    }
}

- (void)initView
{
    self.pageNumber = 1;
    [self.view insertSubview:self.searchBar belowSubview:self.tableView];
    [self.view addSubview:self.emptyView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.hideSearchBar = NO;
    self.searchText = @"";
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (void)addAutoLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (SHGRecommendCollectionView *)recommendCollectionView
{
    if (!_recommendCollectionView) {
        _recommendCollectionView = [[SHGRecommendCollectionView alloc] init];
        _recommendCollectionView.scrollEnabled = NO;
        [self.recommendCell.contentView addSubview:_recommendCollectionView];
        _recommendCollectionView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _recommendCollectionView;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.hidden = YES;
        _emptyView.type = SHGEmptyDateDiscoverySearch;
    }
    return _emptyView;
}


- (void)setHideSearchBar:(BOOL)hideSearchBar
{
    _hideSearchBar = hideSearchBar;
    self.tableView.sd_resetLayout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(hideSearchBar ? self.view : self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);

    self.emptyView.sd_resetLayout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(hideSearchBar ? self.view : self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    self.pageNumber = 1;
    [self.dataArr removeAllObjects];
    [self loadData];
}

- (void)refreshFooter
{
    [self loadData];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    if (self.recommendCollectionView.dataArray.count > 0) {
        [self.recommendCollectionView.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SHGDiscoveryRecommendObject class]]) {
                SHGDiscoveryRecommendObject *recommendObject = (SHGDiscoveryRecommendObject *)obj;
                if ([recommendObject.userID isEqualToString:targetUserID]) {
                    recommendObject.isAttention = attationState;
                }
            }
        }];
        [self.recommendCollectionView reloadData];
    } else {
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
                SHGDiscoveryDepartmentObject *departmentObject = (SHGDiscoveryDepartmentObject *)obj;
                if ([departmentObject.userID isEqualToString:targetUserID]) {
                    departmentObject.isAttention = attationState;
                }
            }
        }];
        [self.tableView reloadData];
    }
}

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    void(^block)(NSArray *firstArray, NSArray *secondArray) = ^(NSArray *firstArray, NSArray *secondArray) {
        weakSelf.emptyView.hidden = YES;

        if (firstArray.count > 0) {
            [weakSelf.dataArr addObjectsFromArray:firstArray];
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            if(secondArray.count > 0) {
                weakSelf.hideSearchBar = YES;
                weakSelf.recommendContactArray = [NSArray arrayWithArray:secondArray];
                weakSelf.recommendCollectionView.dataArray = weakSelf.recommendContactArray;
            } else if(weakSelf.dataArr.count == 0){
                weakSelf.emptyView.hidden = NO;
            }
        }

        weakSelf.pageNumber++;
        [weakSelf.tableView reloadData];
    };


    if ([self.object.industryName isEqualToString:@"邀请好友"]) {
        //不显示搜索框
        self.hideSearchBar = YES;
        NSDictionary *param = @{@"uid":UID, @"pageNum":@(self.pageNumber), @"pageSize":@"10"};
        [SHGDiscoveryManager loadDiscoveryInvateData:param block:block];
    } else {
        NSDictionary *param = @{@"uid":UID, @"pageNum":@(self.pageNumber), @"pageSize":@"10", @"condition":self.searchText, @"industry":self.object.industry, @"industryTotal":self.object.industryNum};
        [SHGDiscoveryManager loadDiscoveryMyDepartmentData:param block:block];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recommendContactArray) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recommendContactArray) {
        return self.recommendCollectionView.totalHeight;
    }
    NSObject *object = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGDiscoveryDisplayCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recommendContactArray) {
        return self.recommendCell;
    }
    SHGDiscoveryDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryDisplayCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryDisplayCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGDiscoveryDepartmentObject *object = [self.dataArr objectAtIndex:indexPath.row];
        [[SHGGloble sharedGloble] recordUserAction:object.userID type:@"personalDynamic_index"];
        if ([object isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
            SHGPersonalViewController *viewController = [[SHGPersonalViewController alloc] init];
            viewController.userId = object.userID;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchText = searchBar.text;
    [[SHGGloble sharedGloble] recordUserAction:self.searchBar.text type:@"newdiscover_searcher"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



@interface SHGDiscoveryDisplayCell()

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIImageView *relationShipImageView;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;

@end


@implementation SHGDiscoveryDisplayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.firstLabel.font = FontFactor(16.0f);
    self.secondLabel.font = self.thirdLabel.font = FontFactor(14.0f);
    self.firstLabel.textColor = Color(@"161616");
    self.secondLabel.textColor = self.thirdLabel.textColor = Color(@"898989");
    self.spliteView.backgroundColor = Color(@"e6e7e8");
    [self.button setEnlargeEdge:10.0f];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAutoLayout
{
    self.headerView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(60.0f))
    .heightEqualToWidth(1.0f);

    self.firstLabel.sd_layout
    .topEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .heightIs(self.firstLabel.font.lineHeight);
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.authenticationView.sd_layout
    .centerYEqualToView(self.firstLabel)
    .offset(MarginFactor(2.0f))
    .leftSpaceToView(self.firstLabel, 0.0f)
    .heightIs(13.0f);

    self.secondLabel.sd_layout
    .centerYEqualToView(self.headerView)
    .leftEqualToView(self.firstLabel)
    .heightIs(self.secondLabel.font.lineHeight);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.thirdLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftEqualToView(self.firstLabel)
    .heightIs(self.thirdLabel.font.lineHeight);
    [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(10.0f))
    .topSpaceToView(self.headerView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    [self setupAutoHeightWithBottomView:self.spliteView bottomMargin:0.0f];
}

- (void)setObject:(NSObject *)object
{
    _object = object;
    if ([object isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
        //发现的搜索
        SHGDiscoveryPeopleObject *peopleObject = (SHGDiscoveryPeopleObject *)object;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,peopleObject.headImg] placeholderImage:[UIImage imageNamed:@"default_head"] status:peopleObject.status userID:peopleObject.userID];
        [self.authenticationView updateWithVStatus:peopleObject.status enterpriseStatus:peopleObject.businessStatus];
        self.firstLabel.text = peopleObject.realName;
        self.secondLabel.text = peopleObject.company.length == 0 ? @"暂未提供公司信息" : peopleObject.company;
        self.thirdLabel.text = peopleObject.area;
        if (peopleObject.isAttention) {
            [self.button setImage:[UIImage imageNamed:@"me_followed"] forState:UIControlStateNormal];
        } else {
            [self.button setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
        }
        self.button.hidden = peopleObject.hideAttation;
    } else if ([object isKindOfClass:[SHGDiscoveryInvateObject class]]) {
        //邀请好友
        SHGDiscoveryInvateObject *invateObject = (SHGDiscoveryInvateObject *)object;

        self.firstLabel.text = invateObject.realName;
        self.secondLabel.text = @"暂未提供公司信息";
        self.thirdLabel.text = @"通讯录联系人";
        [self.button setImage:[UIImage imageNamed:@"discovery_invate"] forState:UIControlStateNormal];

    } else if ([object isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
        //我的人脉
        SHGDiscoveryDepartmentObject *depentmentObject = (SHGDiscoveryDepartmentObject *)object;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,depentmentObject.headImg] placeholderImage:[UIImage imageNamed:@"default_head"] status:depentmentObject.userStatus userID:depentmentObject.userID];
        [self.authenticationView updateWithVStatus:depentmentObject.userStatus enterpriseStatus:depentmentObject.businessStatus];
        self.firstLabel.text = depentmentObject.realName;
        self.secondLabel.text = depentmentObject.company.length == 0 ? @"暂未提供公司信息" : depentmentObject.company;
        self.thirdLabel.text = depentmentObject.area;
        self.relationShipImageView.image = depentmentObject.friendTypeImage;
        if (depentmentObject.isAttention) {
            [self.button setImage:[UIImage imageNamed:@"me_followed"] forState:UIControlStateNormal];
        } else {
            [self.button setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
        }
        self.button.hidden = depentmentObject.hideAttation;
    }

    self.button.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.headerView)
    .heightIs(self.button.currentImage.size.height)
    .widthIs(self.button.currentImage.size.width);

    self.relationShipImageView.sd_layout
    .centerYEqualToView(self.firstLabel)
    .leftSpaceToView(self.authenticationView, 0.0f)
    .heightIs(self.relationShipImageView.image.size.height)
    .widthIs(self.relationShipImageView.image.size.width);
}

- (void)buttonClick:(UIButton *)button
{
    if ([self.object isKindOfClass:[SHGDiscoveryInvateObject class]]){
        //邀请好友
        NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈--金融业务互助平台！这里有业务互助、人脉嫁接！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL, UID]];
        SHGDiscoveryInvateObject *invateObject = (SHGDiscoveryInvateObject *)self.object;
        [[SHGGloble sharedGloble] showMessageView:@[invateObject.phone] body:content];
    } else if ([self.object isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
        [SHGGlobleOperation addAttation:self.object];
    } else if ([self.object isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
        [SHGGlobleOperation addAttation:self.object];
    }
}


@end


@interface SHGDiscoveryDisplayExpandViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;


@end

@implementation SHGDiscoveryDisplayExpandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.object.moduleName;
    [self initView];
    [self addAutoLayout];
    [self loadDataWithTarget:@"first"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dataArr.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
            SHGDiscoveryPeopleObject *peopleObject = (SHGDiscoveryPeopleObject *)obj;
            if (peopleObject.isAttention) {
                peopleObject.hideAttation = YES;
            }
        }
    }];
}

- (void)initView
{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view sd_addSubviews:@[self.searchBar, self.tableView, self.emptyView]];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchText = @"";
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (void)addAutoLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);

    self.emptyView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        if (self.object.moduleType == SHGDiscoveryGroupingTypeIndustry) {
            _searchBar.placeholder = @"请输入城市名/姓名查找精准人脉";
        } else {
            _searchBar.placeholder = @"请输入行业名/姓名查找精准人脉";
        }
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateDiscoverySearch;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)refreshFooter
{
    [self loadDataWithTarget:@"load"];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
            SHGDiscoveryPeopleObject *peopleObject = (SHGDiscoveryPeopleObject *)obj;
            if ([peopleObject.userID isEqualToString:targetUserID]) {
                peopleObject.isAttention = attationState;
            }
        }
    }];
    [self.tableView reloadData];
}

- (NSString *)minUserID
{
    NSString *maxUserID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    NSString *uid = maxUserID;
    for (SHGDiscoveryPeopleObject *object in self.dataArr) {
        NSString *userID = object.userID;
        if ([userID compare:uid options:NSNumericSearch] == NSOrderedAscending) {
            uid = userID;
        }
    }
    return [uid isEqualToString:maxUserID] ? @"-1" : uid;
}

- (void)loadDataWithTarget:(NSString *)target
{
    __weak typeof(self)weakSelf = self;
    void(^block)(NSArray *firstArray, NSArray *secondArray) = ^(NSArray *firstArray, NSArray *secondArray) {
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
        }
        [weakSelf.dataArr addObjectsFromArray:firstArray];

        if (weakSelf.dataArr.count == 0) {
            weakSelf.emptyView.hidden = NO;
        } else {
            weakSelf.emptyView.hidden = YES;
        }
        if (firstArray.count == 0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }

        [weakSelf.tableView reloadData];
    };

    if (self.object.moduleType == SHGDiscoveryGroupingTypeIndustry) {

        NSDictionary *param = @{@"target":target, @"industry":self.object.module, @"userId":[self minUserID], @"pageSize":@"10", @"positionCondition":self.searchText, @"uid":UID};
        [SHGDiscoveryManager loadDiscoveryGroupUserDetail:param block:block];
    } else {

        NSDictionary *param = @{@"target":target, @"position":self.object.module, @"userId":[self minUserID], @"pageSize":@"10", @"industryCondition":self.searchText, @"uid":UID};
        [SHGDiscoveryManager loadDiscoveryGroupUserDetail:param block:block];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *object = [self.dataArr objectAtIndex:indexPath.row];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGDiscoveryDisplayCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGDiscoveryDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryDisplayCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryDisplayCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGDiscoveryPeopleObject *object = [self.dataArr objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
            SHGPersonalViewController *viewController = [[SHGPersonalViewController alloc] init];
            viewController.userId = object.userID;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchText = searchBar.text;
    [[SHGGloble sharedGloble] recordUserAction:self.searchBar.text type:@"newdiscover_searcher"];
    [self loadDataWithTarget:@"first"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
