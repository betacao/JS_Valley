//
//  SHGHomeViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGHomeViewController.h"
#import "CircleListObj.h"
#import "SHGCircleSendViewController.h"
#import "ChatViewController.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
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


@interface SHGHomeViewController ()<MLEmojiLabelDelegate,CircleListDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//判断是否已经加载过推荐列表
@property (strong, nonatomic) NSMutableArray *recommendArray;
@property (strong, nonatomic) SHGNewFriendObject *friendObject;

@property (assign, nonatomic) BOOL hasDataFinished;

@property (strong, nonatomic) SHGNoticeView *newFriendNoticeView;
@property (strong, nonatomic) SHGNoticeView *newMessageNoticeView;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *circleType;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary *heightDictionary;
@end

@implementation SHGHomeViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return  self;
}

+ (instancetype)sharedController
{
    static SHGHomeViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.circleType = @"all";
    self.needShowNewFriend = YES;
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    [self loadPreLoadingData];
    [self addHeaderRefresh:self.tableView headerRefesh:YES headerTitle:@{kRefreshStateIdle:@"下拉可以刷新", kRefreshStatePulling:@"释放后查看最新动态", kRefreshStateRefreshing:@"正在努力加载中"} andFooter:YES footerTitle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];

}

- (void)loadPreLoadingData
{
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
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

            [weakSelf.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)allArray.count]];
            [weakSelf insertRecomandArray];
            [weakSelf insertNewFriendArray];
            weakSelf.needRefreshTableView = YES;
        } else{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [Hud showMessageWithText:@"获取首页数据失败"];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SHGHomeViewController" label:@"onClick"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (SHGNoticeView *)newFriendNoticeView
{
    if(!_newFriendNoticeView){
        _newFriendNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewFriend];
        _newFriendNoticeView.superView = self.view;
    }
    return _newFriendNoticeView;
}

- (SHGNoticeView *)newMessageNoticeView
{
    if(!_newMessageNoticeView){
        _newMessageNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _newMessageNoticeView.superView = self.view;
    }
    return _newMessageNoticeView;
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

- (NSMutableDictionary *)heightDictionary
{
    if (!_heightDictionary) {
        _heightDictionary = [NSMutableDictionary dictionary];
    }
    return _heightDictionary;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"大家都在搜：";
    }
    return _searchBar;
}


- (void)requestRecommendFriends
{
    [self.heightDictionary removeAllObjects];
    [self.dataArr removeObject:self.recommendArray];
    [self.recommendArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
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
    __weak typeof(self) weakSelf = self;
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
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf refreshHeader];
    });
}

- (void)loadRegisterPushFriend
{
    [self.dataArr removeObject:self.friendObject];
    self.friendObject = nil;
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@%@",rBaseAddressForHttp,@"/recommended/friends/registerPushFriendGrade"] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
//        weakSelf.friendObject = [[SHGNewFriendObject alloc] init];
//        weakSelf.friendObject.commonFriendCount = @"10";
//        weakSelf.friendObject.commonFriendList = @[@"1wqekjqwe",@"wwwwww",@"fsadasasd",@"eee",];
//        weakSelf.friendObject.company = @"w";
//        weakSelf.friendObject.picName = @"";
//        weakSelf.friendObject.position = @"南京";
//        weakSelf.friendObject.realName = @"w";
//        weakSelf.friendObject.title = @"w";
//        weakSelf.friendObject.uid = @"9975";
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

- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]) {
            CircleListObj *listObject = (CircleListObj *)obj;
            if ([listObject.userid isEqualToString:targetUserID]) {
                listObject.isAttention = attationState;
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [obj enumerateObjectsUsingBlock:^(RecmdFriendObj *friendObject, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([friendObject.uid isEqualToString:targetUserID]) {
                    friendObject.isAttention = attationState;
                }
            }];
        }
    }];
    [self.tableView reloadData];

}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    self.isRefreshing = YES;

    if ([target isEqualToString:@"first"]){
        [self.tableView.mj_footer resetNoMoreData];
        self.hasDataFinished = NO;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":uid, @"type":@"all", @"target":target, @"rid":@(rid), @"num": rRequestNum, @"tagId" : @"-1"};

    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,dynamicAndNews] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        weakSelf.isRefreshing = NO;
        [weakSelf assembleDictionary:response.dataDictionary target:target];
        weakSelf.needRefreshTableView = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
      
    } failed:^(MOCHTTPResponse *response){
        weakSelf.isRefreshing = NO;
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.errorMessage);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [Hud hideHud];
    }];
}

- (void)assembleDictionary:(NSDictionary *)dictionary target:(NSString *)target
{
    //普通数据
    NSArray *normalArray = [dictionary objectForKey:@"normalpostlist"];
    normalArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:normalArray class:[CircleListObj class]];
    //推广数据
    NSArray *adArray = [dictionary objectForKey:@"adlist"];
    adArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:adArray class:[CircleListObj class]];
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
        [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.dataArr.count]];
    } else if ([target isEqualToString:@"refresh"]){
        if (normalArray.count > 0){
            for (NSInteger i = normalArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [normalArray objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.listArray insertObject:obj atIndex:0];
            }
            [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)normalArray.count]];
        } else{
            [self.newMessageNoticeView showWithText:@"暂无新动态，休息一会儿"];
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
        if (IsArrEmpty(normalArray)){
            self.hasDataFinished = YES;
        } else{
            self.hasDataFinished = NO;
        }
    }
}

//发帖
- (void)actionPost:(UIButton *)sender
{
    SHGCircleSendViewController *controller = [[SHGCircleSendViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
    if (self.hasDataFinished){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
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
            if([obj.postType isEqualToString:@"normal"]){
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
            if([obj.postType isEqualToString:@"normal"]){
                rid = obj.rid;
                break;
            }
        }
    }
    return rid;
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
            cell.sd_tableView = tableView;
            cell.sd_indexPath = indexPath;
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
                    cell.controller = self;
                    cell.delegate = [SHGUnifiedTreatment sharedTreatment];
                    cell.sd_tableView = tableView;
                    cell.sd_indexPath = indexPath;
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
                    cell.sd_tableView = tableView;
                    cell.sd_indexPath = indexPath;
                    return cell;
                }
            }
        }
    } else{
        return self.emptyCell;
    }
    return nil;
}
#pragma mark -- sdc
#pragma mark -- url点击
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    NSLog(@"1111");
    [UIPasteboard generalPasteboard].string = link;
    LinkViewController *vc=  [[LinkViewController alloc]init];
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            vc.url = link;
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            [self openTel:link];
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
    
}
#pragma mark -- sdc
#pragma mark -- 拨打电话
- (BOOL)openTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (BOOL)openURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"] ;
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
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
        return SCREENWIDTH;
    }
    return SCREENHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        return CGRectGetHeight(self.view.frame) - kTabBarHeight;
    }
    CircleListObj *obj = self.dataArr[indexPath.row];

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
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        tableView.showsVerticalScrollIndicator = YES;
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        tableView.showsVerticalScrollIndicator = NO;
        return 1;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
   
        if([obj isKindOfClass:[CircleListObj class]]){
            if (!IsStrEmpty(obj.feedhtml)){
                NSLog(@"%@",obj.feedhtml);
                [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_spread"];
                LinkViewController *controller = [[LinkViewController alloc]init];
                controller.url = obj.feedhtml;
                controller.object = obj;
                [self.navigationController pushViewController:controller animated:YES];
            } else{
                [[SHGGloble sharedGloble] recordUserAction:obj.rid type:@"dynamic_viewAllComment"];
                CircleDetailViewController *viewController = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
                viewController.delegate = [SHGUnifiedTreatment sharedTreatment];
                viewController.rid = obj.rid;
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:obj.praisenum, kPraiseNum,obj.sharenum,kShareNum,obj.cmmtnum,kCommentNum, nil];
                viewController.itemInfoDictionary = dictionary;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

#pragma mark ------searchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

