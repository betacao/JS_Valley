//
//  SHGHomeViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGHomeViewController.h"
#import "CircleListObj.h"
#import "SHGLinkViewController.h"
#import "RecmdFriendObj.h"
#import "SHGNoticeView.h"
#import "SHGMainPageTableViewCell.h"
#import "CircleDetailViewController.h"
#import "SHGUnifiedTreatment.h"
#import "SHGUserTagModel.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"
#import "SHGExtendTableViewCell.h"
#import "SHGRecommendTableViewCell.h"
#import "EMSearchBar.h"
#import "SHGNewFriendTableViewCell.h"
#import "SHGCircleManager.h"
#import "SHGHomeCategoryView.h"


@interface SHGHomeViewController ()<CircleListDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SHGHomeCategoryView *categoryView;
//判断是否已经加载过推荐列表
@property (strong, nonatomic) NSMutableArray *recommendArray;
@property (strong, nonatomic) SHGNewFriendObject *friendObject;

@property (strong, nonatomic) SHGNoticeView *messageNoticeView;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) UITableViewCell *emptyCell;

@property (strong, nonatomic) NSMutableDictionary *heightDictionary;

@end

@implementation SHGHomeViewController

+ (instancetype)sharedController
{
    static SHGHomeViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.needShowNewFriend = YES;

    self.tableView.backgroundColor = Color(@"efeeef");
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, kTabBarHeight, 0.0f));

    self.categoryView = [SHGHomeCategoryView sharedCategoryView];
    self.categoryView.messageNoticeView = self.messageNoticeView;
    [self.view addSubview:self.categoryView];
    
    self.categoryView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, kTabBarHeight, 0.0f));

    [self loadPreLoadingData];
    [self addHeaderRefresh:self.tableView headerRefesh:YES headerTitle:@{kRefreshStateIdle:@"下拉可以刷新", kRefreshStatePulling:@"释放后查看最新动态", kRefreshStateRefreshing:@"正在努力加载中"} andFooter:YES footerTitle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
}

- (void)loadPreLoadingData
{
    [Hud showWait];
    WEAK(self, weakSelf);
    [SHGGloble sharedGloble].CompletionBlock = ^(NSArray *allArray, NSArray *normalArray, NSArray *adArray){
        [Hud hideHud];
        if(allArray && [allArray count] > 0){
            //更新整体数据
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:allArray];
            //更新normal数据
            [weakSelf.listArray removeAllObjects];
            [weakSelf.listArray addObjectsFromArray:normalArray];
            //更新推广数据
            [weakSelf.adArray removeAllObjects];
            [weakSelf.adArray addObjectsFromArray:adArray];

            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];

            [weakSelf.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)allArray.count]];
            [weakSelf insertRecomandArray];
            [weakSelf insertNewFriendArray];
            weakSelf.needRefreshTableView = YES;
        } else{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    };
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (NSMutableArray *)currentListArray
{
    return self.listArray;
}

- (NSMutableArray *)recommendArray
{
    if(!_recommendArray){
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

- (SHGNoticeView *)messageNoticeView
{
    if(!_messageNoticeView){
        _messageNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _messageNoticeView.superView = self.view;
    }
    return _messageNoticeView;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
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

- (NSMutableDictionary *)heightDictionary
{
    if (!_heightDictionary) {
        _heightDictionary = [NSMutableDictionary dictionary];
    }
    return _heightDictionary;
}

- (void)requestRecommendFriends
{
    [self.heightDictionary removeAllObjects];
    [self.dataArr removeObject:self.recommendArray];
    [self.recommendArray removeAllObjects];
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/recommended/friends/recommendedFriendGrade",rBaseAddressForHttp] class:[RecmdFriendObj class] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response){
        [weakSelf.recommendArray addObjectsFromArray:response.dataArray];
        [weakSelf insertRecomandArray];

    } failed:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.error);
    }];
}

- (void)insertRecomandArray
{
    if (self.recommendArray.count == 0 || [self.dataArr containsObject:self.recommendArray]) {
        return;
    }
    //第三个帖子后面
    if(self.dataArr.count > 5){
        [self.dataArr addObject:self.recommendArray];
        [self adjustAdditionalObject];
        self.needRefreshTableView = YES;
    }
}

- (void)insertNewFriendArray
{
    if (!self.friendObject || [self.dataArr containsObject:self.friendObject]) {
        return;
    }
    if(self.dataArr.count > 2 && self.needShowNewFriend){
        [self.dataArr addObject:self.friendObject];
        [self adjustAdditionalObject];
        self.needRefreshTableView = YES;
    }
}

//调整推荐好友和好友提醒的位置
- (void)adjustAdditionalObject
{
    if (self.dataArr.count > 5) {
        //移动提醒的位置
        if ([self.dataArr containsObject:self.friendObject]) {
            NSInteger index = [self.dataArr indexOfObject:self.friendObject];
            [self.dataArr moveObjectAtIndex:index toIndex:1];
        }

        //移动推荐的位置
        if ([self.dataArr containsObject:self.recommendArray]) {
            NSInteger index = [self.dataArr indexOfObject:self.recommendArray];
            if ([self.dataArr containsObject:self.friendObject]) {
                [self.dataArr moveObjectAtIndex:index toIndex:4];
            } else{
                [self.dataArr moveObjectAtIndex:index toIndex:3];
            }
        }
    }
}

- (void)setNeedRefreshTableView:(BOOL)needRefreshTableView
{
    WEAK(self, weakSelf);
    if (needRefreshTableView && !_needRefreshTableView) {
        _needRefreshTableView = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            _needRefreshTableView = NO;
        });
    }
}

- (void)setNeedShowNewFriend:(BOOL)needShowNewFriend
{
    _needShowNewFriend = needShowNewFriend;
    if (!needShowNewFriend && [self.dataArr indexOfObject:self.friendObject] != NSNotFound) {
        [self.dataArr removeObject:self.friendObject];
        [self.dataArr removeObject:self.recommendArray];
        [self insertRecomandArray];
    }
}

- (void)refreshData
{
    WEAK(self, weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf requestDataWithTarget:@"first" time:@"-1"];
    });
}

- (void)loadRegisterPushFriend
{
    [self.dataArr removeObject:self.friendObject];
    self.friendObject = nil;
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@%@",rBaseAddressForHttp,@"/recommended/friends/registerPushFriendGrade"] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        if (dictionary) {
            NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[dictionary] class:[SHGNewFriendObject class]];
            if (array.count > 0) {
                weakSelf.friendObject = [array firstObject];
            } else{
                weakSelf.friendObject = nil;
            }
        }
        [weakSelf insertNewFriendArray];
    } failed:^(MOCHTTPResponse *response) {

    }];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.userid isEqualToString:targetUserID]) {
                listObject.isAttention = [attationState boolValue];
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [obj enumerateObjectsUsingBlock:^(RecmdFriendObj *friendObject, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([friendObject.uid isEqualToString:targetUserID]) {
                    friendObject.isAttention = [attationState boolValue];
                }
            }];
        }
    }];
    self.needRefreshTableView = YES;
}

- (void)loadPraiseState:(NSString *)targetID praiseState:(NSNumber *)praiseState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.rid isEqualToString:targetID]) {
                listObject.ispraise = [praiseState boolValue] ? @"Y" : @"N";
                if ([praiseState boolValue]) {
                    listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] + 1];
                } else {
                    listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] - 1];
                }
            }
        }
    }];
    self.needRefreshTableView = YES;
}

- (void)loadDelete:(NSString *)targetID
{
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.rid isEqualToString:targetID]) {
                [array addObject:listObject];
            }
        }
    }];
    [self.dataArr removeObjectsInArray:array];
    [self.listArray removeObjectsInArray:array];
    self.needRefreshTableView = YES;
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    self.isRefreshing = YES;
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":UID, @"type":@"all", @"target":target, @"rid":@(rid), @"num": @(10), @"tagId" : @"-1"};

    WEAK(self, weakSelf);
    [SHGCircleManager getListDataWithParam:param block:^(NSArray *normalArray, NSArray *adArray) {
        [Hud hideHud];
         weakSelf.isRefreshing = NO;
        if (normalArray && adArray) {
            [weakSelf assembleNormalArray:normalArray adArray:adArray target:target];
            weakSelf.needRefreshTableView = YES;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)assembleNormalArray:(NSArray *)normalArray adArray:(NSArray *)adArray target:(NSString *)target
{
    [self.adArray removeAllObjects];
    [self.adArray addObjectsFromArray:adArray];

    if ([target isEqualToString:@"first"]){
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:normalArray];
        //总数据
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.listArray];
        if(self.listArray.count > 0){
            for(CircleListObj *obj in self.adArray){
                NSInteger index = [obj.displayposition integerValue] - 1;
                [self.dataArr insertObject:obj atIndex:index];
            }
        } else{
            [self.dataArr addObjectsFromArray:self.adArray];
        }
        [self insertRecomandArray];
        [self insertNewFriendArray];
        [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.dataArr.count]];
    } else if ([target isEqualToString:@"refresh"]){
        if (normalArray.count > 0){
            for (NSInteger i = normalArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [normalArray objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.listArray insertObject:obj atIndex:0];
            }
            [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)normalArray.count]];
        } else{
            [self.messageNoticeView showWithText:@"暂无新动态，休息一会儿"];
        }
        //总数据
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.listArray];

        if(self.listArray.count > 0){
            for(CircleListObj *obj in self.adArray){
                NSInteger index = [obj.displayposition integerValue] - 1;
                [self.dataArr insertObject:obj atIndex:index];
            }
        } else{
            [self.dataArr addObjectsFromArray:self.adArray];
        }
        [self insertRecomandArray];
        [self insertNewFriendArray];
    } else if ([target isEqualToString:@"load"]){
        [self.listArray addObjectsFromArray:normalArray];
        [self.dataArr addObjectsFromArray:normalArray];
    }
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    if(self.isRefreshing){
        return;
    }
    if (self.dataArr.count > 0){
        [self requestDataWithTarget:@"refresh" time:[self refreshMaxRid]];
    } else{
        [self requestDataWithTarget:@"first" time:@""];
    }
}

- (void)refreshFooter
{
    NSLog(@"refreshFooter");
    if (self.dataArr.count > 0){
        [self requestDataWithTarget:@"load" time:[self refreshMinRid]];
    }

}

- (NSString *)refreshMaxRid
{
    NSString *rid = @"";
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        CircleListObj *obj = self.dataArr[i];
        if([obj isKindOfClass:[CircleListObj class]]){
            if([obj.postType isEqualToString:@"normal"] || [obj.postType isEqualToString:@"normalpc"] || [obj.postType isEqualToString:@"business"]){
                rid = obj.rid;
                break;
            }
        }
    }
    return rid;
}

- (NSString *)refreshMinRid
{
    NSString *rid = @"";
    for(NSInteger i = self.dataArr.count - 1; i >=0; i--){
        CircleListObj *obj = self.dataArr[i];
        if([obj isKindOfClass:[CircleListObj class]]){
            if([obj.postType isEqualToString:@"normal"] || [obj.postType isEqualToString:@"normalpc"] || [obj.postType isEqualToString:@"business"]){
                rid = obj.rid;
                break;
            }
        }
    }
    return rid;
}

#pragma mark =============  UITableView DataSource  =============

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        NSObject *obj = [self.dataArr objectAtIndex: indexPath.row];
        if([obj isKindOfClass:[NSArray class]]){
            NSString *identifier1 = @"SHGRecommendTableViewCell";
            SHGRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGRecommendTableViewCell" owner:self options:nil] lastObject];
            }
            NSMutableArray *array = [self.dataArr objectAtIndex:indexPath.row];
            cell.objectArray = array;
            cell.controller = self;
            return cell;

        } else if ([obj isKindOfClass:[SHGNewFriendObject class]]){

            NSString *identifier2 = @"SHGNewFriendTableViewCell";
            SHGNewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (!cell){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGNewFriendTableViewCell" owner:self options:nil] lastObject];
            }
            SHGNewFriendObject *object = [self.dataArr objectAtIndex:indexPath.row];
            cell.object = object;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            return cell;

        } else{
            CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
            if (![obj.postType isEqualToString:@"ad"]){
                if ([obj.status boolValue]){
                    NSString *identifier3 = @"SHGMainPageTableViewCell";
                    SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
                    if (!cell){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
                    }
                    cell.index = indexPath.row;
                    cell.object = obj;
                    cell.delegate = [SHGUnifiedTreatment sharedTreatment];
                    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                    return cell;
                }
            } else{
                if ([obj.status boolValue]){
                    NSString *identifier4 = @"SHGExtendTableViewCell";
                    SHGExtendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
                    if (!cell){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGExtendTableViewCell" owner:self options:nil] lastObject];
                    }
                    cell.object = obj;
                    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                    return cell;
                }
            }
        }
    }
    return self.emptyCell;
}



#pragma mark =============  UITableView Delegate  =============

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        id object = [self.dataArr objectAtIndex:indexPath.row];
        if([object isKindOfClass:[CircleListObj class]]){

            if (![((CircleListObj *)object).postType isEqualToString:@"ad"]){
                return SCREENWIDTH;
            } else{
                return MarginFactor(198.0f);
            }

        } else if([object isKindOfClass:[NSArray class]]){

            return MarginFactor(60.0f) * ((NSArray *)object).count;

        } else if ([object isKindOfClass:[SHGNewFriendObject class]]){
            
            return MarginFactor(140.0f);
            
        }
    }
    return SCREENWIDTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {

        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        if([obj isKindOfClass:[CircleListObj class]]){

            if (![obj.postType isEqualToString:@"ad"]){
                if ([obj.status boolValue]){
                    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGMainPageTableViewCell class] contentViewWidth:SCREENWIDTH];
                    return height;
                }
            } else{

                NSString *key = @"SHGExtendTableViewCell";
                CGFloat height = [[self.heightDictionary objectForKey:key] floatValue];
                if (height == 0.0f) {
                    height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGExtendTableViewCell class] contentViewWidth:SCREENWIDTH];
                    [self.heightDictionary setObject:@(height) forKey:key];
                }
                return height;
            }

        } else if([obj isKindOfClass:[NSArray class]]){

            NSString *key = [NSString stringWithFormat:@"height%ld",(long)self.recommendArray.count];
            CGFloat height = [[self.heightDictionary objectForKey:key] floatValue];
            if (height == 0.0f) {
                height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"objectArray" cellClass:[SHGRecommendTableViewCell class] contentViewWidth:SCREENWIDTH];
                [self.heightDictionary setObject:@(height) forKey:key];
            }
            return height;

        } else if ([obj isKindOfClass:[SHGNewFriendObject class]]){

            NSString *key = @"SHGNewFriendTableViewCell";
            CGFloat height = [[self.heightDictionary objectForKey:key] floatValue];
            if (height == 0.0f) {
                height = [tableView cellHeightForIndexPath:indexPath model:obj keyPath:@"object" cellClass:[SHGNewFriendTableViewCell class] contentViewWidth:SCREENWIDTH];
                [self.heightDictionary setObject:@(height) forKey:key];
            }
            return height;
            
        }
    }
    return SCREENHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        return self.dataArr.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {

        CircleListObj *object = self.dataArr[indexPath.row];
        if([object isKindOfClass:[CircleListObj class]]){
            if (!IsStrEmpty(object.feedhtml)){
                NSLog(@"%@",object.feedhtml);
                [[SHGGloble sharedGloble] recordUserAction:object.rid type:@"dynamic_spread"];
                SHGLinkViewController *controller = [[SHGLinkViewController alloc]init];
                controller.url = object.feedhtml;
                controller.object = object;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [[SHGGloble sharedGloble] recordUserAction:object.rid type:@"dynamic_viewAllComment"];
                CircleDetailViewController *controller = [[CircleDetailViewController alloc] init];
                controller.delegate = [SHGUnifiedTreatment sharedTreatment];
                controller.rid = object.rid;
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:object.praisenum, kPraiseNum,object.sharenum,kShareNum,object.cmmtnum,kCommentNum, nil];
                controller.itemInfoDictionary = dictionary;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

