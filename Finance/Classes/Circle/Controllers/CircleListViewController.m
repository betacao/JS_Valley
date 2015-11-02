//
//  CircleListViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListViewController.h"
#import "CircleListObj.h"
#import "CircleSendViewController.h"
#import "CircleSomeOneViewController.h"
#import "ChatViewController.h"
#import "CircleListTwoTableViewCell.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
#import "CCLocationManager.h"
#import "RecmdFriendObj.h"
#import "CircleListRecommendViewController.h"
#import "popObj.h"
#import "SHGNoticeView.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)


const CGFloat kAdTableViewCellHeight = 191.0f;
const CGFloat kAdButtomMargin = 20.0f;

@interface CircleListViewController ()<MLEmojiLabelDelegate,CLLocationManagerDelegate,CircleActionDelegate,SHGNoticeDelegate>
{
    NSString *_target;
    NSInteger photoIndex;
    BOOL hasDataFinished;
    BOOL hasRequestFailed;
    CircleListObj *deleteObj;
    UISegmentedControl *segmentedControl;
    NSTimer *timer;
    NSArray *phopoArr;
}

@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) NSMutableArray *arrrr;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) CircleListTableViewCell *prototypeCell;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
//判断是否已经加载过推荐列表
@property (strong, nonatomic) NSMutableArray *recomandArray;

@property (assign, nonatomic) BOOL hasRequestedFirst;
@property (assign, nonatomic) BOOL hasRequestedRecomand;
@property (assign, nonatomic) BOOL hasLocated;

@property (strong, nonatomic) CircleListRecommendViewController *recommendViewController;

@property (strong, nonatomic) SHGNoticeView *newFriendNoticeView;
@property (strong, nonatomic) SHGNoticeView *newMessageNoticeView;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *currentCity;
@property (strong, nonatomic) NSString *circleType;
@property (assign, nonatomic) BOOL shouldDisplayRecommend;
@end

@implementation CircleListViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:YES headerTitle:@{kRefreshStateIdle:@"下拉可以刷新", kRefreshStatePulling:@"释放后查看最新动态", kRefreshStateRefreshing:@"正在努力加载中"} andFooter:YES footerTitle:nil];
    self.listTable.separatorStyle = NO;
    //处理tableView左边空白
    if ([self.listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTable setLayoutMargins:UIEdgeInsetsZero];
    }

    self.hasRequestedRecomand = NO;
    self.hasLocated = NO;
    self.hasRequestedFirst = NO;
    self.shouldDisplayRecommend = YES;
    
    self.circleType = @"all";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"aaa" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_FRIENDSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionChanged:) name:NOTIFI_COLLECT_COLLECT_CLIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentsChanged:) name:NOTIFI_COLLECT_COMMENT_CLIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseChanged:) name:NOTIFI_COLLECT_PRAISE_CLICK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareChanged:) name:NOTIFI_COLLECT_SHARE_CLIC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChanged:) name:NOTIFI_COLLECT_DELETE_CLICK object:nil];
    
    [self getAllInfo];
    [self loadRegisterPushFriend];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleListViewController" label:@"onClick"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.hasRequestedFirst){
        self.hasRequestedFirst = YES;
        [Hud showLoadingWithMessage:@"加载中"];

        __weak typeof(self) weakSelf = self;
        [SHGGloble sharedGloble].CompletionBlock = ^(NSArray *allArray, NSArray *normalArray, NSArray *adArray){
            [Hud hideHud];
            if(allArray && [allArray count] > 0){
                if(!weakSelf.hasRequestedRecomand){
                    weakSelf.hasRequestedRecomand = YES;
                    [weakSelf requestAlermInfo];
                }
                //更新整体数据
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.dataArr addObjectsFromArray:allArray];
                //更新normal数据
                [weakSelf.listArray removeAllObjects];
                [weakSelf.listArray addObjectsFromArray:normalArray];
                //更新推广数据
                [weakSelf.adArray removeAllObjects];
                [weakSelf.adArray addObjectsFromArray:adArray];

                [weakSelf.listTable.header endRefreshing];
                [weakSelf.listTable.footer endRefreshing];
                weakSelf.listTable.footer.hidden = NO;

                [weakSelf.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)allArray.count]];

                dispatch_async(dispatch_get_main_queue(), ^(){
                    [weakSelf.listTable reloadData];
                });
            } else{
                weakSelf.listTable.footer.hidden = NO;
                [weakSelf.listTable.header endRefreshing];
                [Hud showMessageWithText:@"获取首页数据失败"];
                [weakSelf performSelector:@selector(endrefresh) withObject:nil afterDelay:1.0];
            }
        };
    }
    BOOL needUploadContact = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_USER_NEEDUPLOADCONTACT];
    if(needUploadContact){
        [[SHGGloble sharedGloble] uploadPhonesWithPhone:^(BOOL finish) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KEY_USER_NEEDUPLOADCONTACT];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

- (CircleListRecommendViewController *)recommendViewController
{
    __weak typeof(self) weakSelf = self;
    if(!_recommendViewController){
        _recommendViewController = [[CircleListRecommendViewController alloc] initWithNibName:@"CircleListRecommendViewController" bundle:nil];
        _recommendViewController.delegate = self;
        _recommendViewController.closeBlock = ^{
            weakSelf.shouldDisplayRecommend = NO;
            NSInteger index = [weakSelf.dataArr indexOfObject:weakSelf.recomandArray];
            [weakSelf.dataArr removeObject:weakSelf.recomandArray];
            [weakSelf.listTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    return _recommendViewController;
}

- (NSMutableArray *)recomandArray
{
    if(!_recomandArray){
        _recomandArray = [NSMutableArray array];
    }
    return _recomandArray;
}

- (SHGNoticeView *)newFriendNoticeView
{
    if(!_newFriendNoticeView){
        _newFriendNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewFriend];
        _newFriendNoticeView.superView = self.view;
        _newFriendNoticeView.delegate = self;
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

-(void)requestAlermInfo
{
    if(!self.hasRequestedRecomand || !self.hasLocated){
        return;
    }
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID] stringValue];
    NSDictionary *param = @{@"uid":uid, @"area":self.currentCity == nil?@"":self.currentCity};
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/recommended/friends/recommendedFriend",rBaseAddRessHttp] class:[RecmdFriendObj class] parameters:param success:^(MOCHTTPResponse *response){
        [weakSelf.recomandArray removeAllObjects];
        [weakSelf.dataArr removeObject:weakSelf.recomandArray];
        for (int i = 0; i < response.dataArray.count; i++){
            NSDictionary *dic = response.dataArray[i];
            
            RecmdFriendObj *obj = [[RecmdFriendObj alloc]init];
            obj.flag = [dic valueForKey:@"flag"];
            obj.username = [dic valueForKey:@"username"];
            obj.uid = [dic valueForKey:@"uid"];
            obj.headimg =[NSString stringWithFormat:@"%@/%@",rBaseAddressForImage,[dic valueForKey:@"headimg"]];
            obj.phone = [dic valueForKey:@"phone"];
            obj.area = [dic valueForKey:@"area"];
            obj.company = [dic valueForKey:@"company"];
            obj.recomfri = [dic valueForKey:@"recomfri"];
            obj.title = [dic valueForKey:@"title"];
            [weakSelf.recomandArray addObject:obj];
        }
        if(weakSelf.recomandArray && weakSelf.recomandArray.count > 0){
            [weakSelf insertRecomandArray];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [weakSelf.listTable reloadData];
            });
        }
        
        
    } failed:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.error);
        
    }];
}

- (void)insertRecomandArray
{
    //当前允许显示推荐好友 并且是动态页面不是已关注页面
    if(self.shouldDisplayRecommend && [self.circleType isEqualToString:@"all"]){
        if(self.dataArr.count > 4){
            if(self.recomandArray.count > 0){
                [self.dataArr insertObject:self.recomandArray atIndex:3];
            }
        } else{
            if(self.recomandArray.count > 0){
                [self.dataArr addObject:self.recomandArray];
            }
        }
    }
}

- (void)getAllInfo
{
    __block __weak CircleListViewController *wself = self;
    [[CCLocationManager shareLocation] getCity:^{
        NSString *cityName = [SHGGloble sharedGloble].cityName;
        if(cityName && cityName.length > 0){
            self.currentCity = cityName;
            NSLog(@"self.cityName = %@",self.currentCity);
            wself.hasLocated = YES;
            [wself requestAlermInfo];
        }
    }];
}

-(void)smsShareSuccess:(NSNotification *)noti
{
    NSInteger count = [self.navigationController viewControllers].count;
    for (NSInteger index = count - 1; index >= 0; index--){
        UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index];
        if([controller respondsToSelector:@selector(smsShareSuccess:)]){
            [controller performSelector:@selector(smsShareSuccess:) withObject:noti];
            return;
        }
    }
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
        for (CircleListObj *objs in self.dataArr) {
            if ([objs isKindOfClass:[CircleListObj class]] && [objs.rid isEqualToString:rid]) {
                [self otherShareWithObj:objs];
            }
        }
    }
}

-(void)refreshTable
{
    [self.listTable reloadData];
}

- (UIView *)titleView
{
    if (!_titleView) {
        [self initUI];
        self.titleView = segmentedControl;
    }
    
    return _titleView;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"right_send"];
        [rightButton setBackgroundImage:image forState:UIControlStateNormal];
        [rightButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [rightButton addTarget:self action:@selector(actionPost:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightBarButtonItem;
}

- (void)refreshData
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf refreshHeader];
    });
}

- (void)loadRegisterPushFriend
{
    __weak typeof(self) weakSelf = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@%@",rBaseAddressForHttp,@"/recommended/friends/registerPushFriend"] parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        if(dictionary){
            NSString *message = [dictionary objectForKey:@"message"];
            NSString *uid = [dictionary objectForKey:@"uid"];
            if(message && message.length > 0){
                [weakSelf.newFriendNoticeView showWithText:message];
                [weakSelf.newFriendNoticeView loadUserUid:uid];
            }
        }
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    [Hud showLoadingWithMessage:@"加载中"];
    self.isRefreshing = YES;
    NSDictionary *userTags = [SHGGloble sharedGloble].maxUserTags;

    if ([target isEqualToString:@"first"]){
        [self.listTable.footer resetNoMoreData];
        hasDataFinished = NO;
    } else if([target isEqualToString:@"load"]){
        userTags = [SHGGloble sharedGloble].minUserTags;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":uid, @"type":self.circleType, @"target":target, @"rid":@(rid), @"num": rRequestNum, @"tagIds" : userTags};

    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,circleNew] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        weakSelf.isRefreshing = NO;
        if([target isEqualToString:@"first"]){
            if([response.dataDictionary objectForKey:@"tagids"]){
                //大小统一
                [SHGGloble sharedGloble].maxUserTags = [response.dataDictionary objectForKey:@"tagids"];
                [SHGGloble sharedGloble].minUserTags = [response.dataDictionary objectForKey:@"tagids"];
                NSLog(@"XXXXXXXXXXXXX%@",[response.dataDictionary objectForKey:@"tagids"]);
            }
        } else if ([target isEqualToString:@"refresh"]){
            if([response.dataDictionary objectForKey:@"tagids"]){
                [SHGGloble sharedGloble].maxUserTags = [response.dataDictionary objectForKey:@"tagids"];
                NSLog(@"XXXXXXXXXXXXX%@",[response.dataDictionary objectForKey:@"tagids"]);
            }
        } else{
            if([response.dataDictionary objectForKey:@"tagids"]){
                [SHGGloble sharedGloble].minUserTags = [response.dataDictionary objectForKey:@"tagids"];
                NSLog(@"XXXXXXXXXXXXX%@",[response.dataDictionary objectForKey:@"tagids"]);
            }
        }
        [weakSelf assembleDictionary:response.dataDictionary target:target];

        [weakSelf.listTable.header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
        [Hud hideHud];
        weakSelf.listTable.footer.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf.listTable reloadData];
        });
    } failed:^(MOCHTTPResponse *response){
        weakSelf.isRefreshing = NO;
        weakSelf.listTable.footer.hidden = NO;
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.errorMessage);
        [weakSelf.listTable.header endRefreshing];
        [weakSelf performSelector:@selector(endrefresh) withObject:nil afterDelay:1.0];
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
    if ([target isEqualToString:@"first"]){
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:normalArray];

        [self.adArray removeAllObjects];
        [self.adArray addObjectsFromArray:adArray];
        //总数据
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.listArray];
        if(self.listArray.count > 0){
            for(CircleListObj *obj in self.adArray){
                NSInteger index = [obj.displayposition integerValue];
                [self.dataArr insertObject:obj atIndex:index];
            }
        }else{
            [self.dataArr addObjectsFromArray:self.adArray];
        }
        [self insertRecomandArray];
        if([self.circleType isEqualToString:@"all"]){
            [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.dataArr.count]];
        }
    } else if ([target isEqualToString:@"refresh"]){
        if (normalArray.count > 0){
            for (NSInteger i = normalArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [normalArray objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.listArray insertObject:obj atIndex:0];
            }
            //总数据
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:self.listArray];
            if(self.listArray.count > 0){
                for(CircleListObj *obj in self.adArray){
                    NSInteger index = [obj.displayposition integerValue];
                    [self.dataArr insertObject:obj atIndex:index];
                }
            }else{
                [self.dataArr addObjectsFromArray:self.adArray];
            }

            [self insertRecomandArray];
            [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)normalArray.count]];
        } else{
            [self.newMessageNoticeView showWithText:@"暂无新动态，休息一会儿"];
        }
    } else if ([target isEqualToString:@"load"]){
        [self.listArray addObjectsFromArray:normalArray];
        for(CircleListObj *obj in normalArray){
             NSLog(@"%@",obj.rid);
        }
        [self.dataArr addObjectsFromArray:normalArray];
        if (IsArrEmpty(normalArray)){
            hasDataFinished = YES;
        } else{
            hasDataFinished = NO;
        }
    }
}
- (void)reloadTable
{
    [self.listTable reloadData];
}

- (void)endrefresh
{
    [self.listTable.footer endRefreshing];
}

- (void)initUI
{
    segmentedControl = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"动态", @"已关注", nil]];
    segmentedControl.frame = CGRectMake(0, 50, 170, 26);
    segmentedControl.enabled = YES;
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.layer.cornerRadius = 4;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 57, 67),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [segmentedControl setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentedControl.tintColor = [UIColor clearColor];
    segmentedControl.layer.borderColor =  [RGB(255, 56, 67) CGColor];
    segmentedControl.layer.borderWidth = 1.0;
    UIImage *segImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
    UIImage *selectImage = [CommonMethod imageWithColor:RGB(255, 56, 67) andSize:CGSizeMake(85, 26)];
    [segmentedControl setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:selectImage forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    segmentedControl.selected = NO;
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
}
//发帖
- (void)actionPost:(UIButton *)sender
{
    CircleSendViewController *postVC = [[CircleSendViewController alloc] initWithNibName:@"CircleSendViewController" bundle:nil];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
}

//titleView切换
- (void)valueChange:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0){
        NSLog(@"所有");
        self.circleType = @"all";
        [self requestDataWithTarget:@"first" time:@""];
    } else{
        NSLog(@"已关注");
        self.circleType = @"attention";
        [self requestDataWithTarget:@"first" time:@""];
    }
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    _target = @"refresh";
    if(self.isRefreshing){
        return;
    }
    if (self.dataArr.count > 0){
        [self requestDataWithTarget:@"refresh" time:[self refreshMaxRid]];
    } else{
        [self requestDataWithTarget:@"first" time:@""];
    }
    
}
- (void)chageValue
{
    hasRequestFailed = NO;
}

- (void)refreshFooter
{
    if (hasDataFinished){
        [self.listTable.footer endRefreshingWithNoMoreData];
        return;
    }
    _target = @"load";
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

#pragma mark ------ SHGNoticeDelegate ------
-(void)didClickNoticeViewWithUid:(NSString *)uid
{
    [self gotoSomeOne:uid name:nil];
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = self.dataArr[indexPath.row];
    if(![obj isKindOfClass:[CircleListObj class]]){
        NSString *cellIdentifier = @"circleListThreeIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"circleListThreeIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        NSMutableArray *array = self.dataArr[indexPath.row];
        if(self.recommendViewController.view.superview){
            [self.recommendViewController.view removeFromSuperview];
        }
        [self.recommendViewController loadViewWithData:array cityCode:self.currentCity];
        [cell addSubview:self.recommendViewController.view];
        return cell;
        
    } else{
        CircleListObj *obj = self.dataArr[indexPath.row];
        NSLog(@"%@",obj.postType);
        if (![obj.postType isEqualToString:@"ad"]){
            if ([obj.status boolValue]){
                NSString *cellIdentifier = @"circleListIdentifier";
                CircleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleListTableViewCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.index = indexPath.row;
                cell.delegate = self;
                [cell loadDatasWithObj:obj];
                
                MLEmojiLabel *mlLable = (MLEmojiLabel *)[cell viewWithTag:521];
                mlLable.delegate = self;
                return cell;
            }
        } else{
            if ([obj.status boolValue]){
                NSString *cellIdentifier = @"circleListTwoIdentifier";
                CircleListTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell){
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleListTwoTableViewCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.popularizeLable.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.popularizeLable.textAlignment =  NSTextAlignmentLeft;
                cell.popularizeLable.text = obj.detail;
                
                phopoArr = (NSArray *)obj.photos;
                if (phopoArr && phopoArr.count > 0){
                    [cell.popularizeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,phopoArr[0]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                } else{
                    [cell.popularizeImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"default_image"]];
                }
               
                //防止图片压缩
                cell.popularizeImage.contentMode = UIViewContentModeScaleAspectFit;
                
                cell.adLable.text = @"推广";
                cell.adLable.textColor = [UIColor grayColor];
                
                NSArray *arr = [obj.publishdate componentsSeparatedByString:@" "];
                for (int i = 0; i < [arr count]; i++) {
                    NSLog(@"string:%@", [arr objectAtIndex:i]);
                }
                cell.lableTime.text = arr[0];
                cell.lableTime.textAlignment = NSTextAlignmentRight;
                
                return cell;
            }
        }
        return nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj =self.dataArr[indexPath.row];
    if([obj isKindOfClass:[CircleListObj class]]){
        if (![obj.postType isEqualToString:@"ad"]){
            if ([obj.status boolValue]){
                obj.cellHeight = [obj fetchCellHeight];
                return obj.cellHeight;
            }
        } else{
            return kAdTableViewCellHeight;
        }
    } else{
        return [self.recommendViewController heightOfView];
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArr.count;
    return count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = self.dataArr[indexPath.row];
    if([obj isKindOfClass:[CircleListObj class]]){
        if (!IsStrEmpty(obj.feedhtml)){
            NSLog(@"%@",obj.feedhtml);
            LinkViewController *vc = [[LinkViewController alloc]init];
            vc.url = obj.feedhtml;
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            CircleDetailViewController *viewController = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
            viewController.delegate = self;
            viewController.rid = obj.rid;
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:obj.praisenum, kPraiseNum,obj.sharenum,kShareNum,obj.cmmtnum,kCommentNum, nil];
            viewController.itemInfoDictionary = dictionary;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else{
        return;
    }
}

//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//获得详情后如果存在数据更新则在首页进行更新
- (void)homeListShouldRefresh:(CircleListObj *)currentObj
{
    for(NSInteger i = 0;i < self.dataArr.count; i ++){
        id object = [self.dataArr objectAtIndex:i];
        if([object isKindOfClass:[CircleListObj class]]){
            CircleListObj *obj = (CircleListObj *)object;
            if([obj.rid isEqualToString:currentObj.rid]){
                obj.sharenum = currentObj.sharenum;
                obj.cmmtnum = currentObj.cmmtnum;
                obj.praisenum = currentObj.praisenum;
                [self.listTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark cellDelegate
- (void)pullClicked:(CircleListObj *)obj
{
    [self.listTable reloadData];
}
- (void)deleteClicked:(CircleListObj *)obj
{
    //删除
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    __weak typeof(self)weakSelf = self;
    alert.rightBlock = ^{
        [weakSelf deletepostWithObj:deleteObj];
    };
    deleteObj = obj;
    [alert show];
}

- (void)cityClicked:(CircleListObj *)obj
{
    if([obj.postType isEqualToString:@"pc"]){
        NSLog(@"1111");
        LinkViewController *vc=  [[LinkViewController alloc] init];
        vc.url = obj.pcurl;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -删除帖子
-(void)deletepostWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":obj.rid, @"uid":obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [MobClick event:@"ActionDeletepost" label:@"onClick"];
            [self detailDeleteWithRid:obj.rid];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [Hud showMessageWithText:error.domain];
     }];
}

#pragma mark -点赞
- (void)praiseClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":obj.rid};
    __weak typeof(self)weakSelf = self;
    if (![obj.ispraise isEqualToString:@"Y"]){
        [Hud showLoadingWithMessage:@"正在点赞"];
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response){
             NSLog(@"%@",response.data);
             NSString *code = [response.data valueForKey:@"code"];
             if ([code isEqualToString:@"000"]){
                 obj.ispraise = @"Y";
                 obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([obj.praisenum integerValue] + 1)];
                 [Hud showMessageWithText:@"赞成功"];
             }
             [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
             [weakSelf.listTable reloadData];
             [Hud hideHud];
         } failed:^(MOCHTTPResponse *response) {
             [Hud hideHud];
             [Hud showMessageWithText:response.errorMessage];
         }];
    } else{
        [Hud showLoadingWithMessage:@"正在取消点赞"];
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"N";
                obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([obj.praisenum integerValue] - 1)];
                [Hud showMessageWithText:@"取消点赞"];
            }
            [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
            [weakSelf.listTable reloadData];
            [Hud hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }
    
}
- (void)headTap:(NSInteger)index
{
    CircleListObj *obj = self.dataArr[index];
    [self gotoSomeOne:obj.userid name:obj.nickname];
}


- (void)didSelectPerson:(NSString *)uid name:(NSString *)userName
{
    [self gotoSomeOne:uid name:userName];
}

#pragma mark -评论
- (void)clicked:(NSInteger )index;
{
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    CircleListObj *obj = self.dataArr[index];
    vc.hidesBottomBarWhenPushed = YES;
    vc.rid = obj.rid;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

- (void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

#pragma mark -分享
- (void)shareClicked:(CircleListObj *)obj
{
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *postContent;
    NSString *shareContent;
    
    NSString *shareTitle ;
    if (IsStrEmpty(obj.detail)) {
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = obj.detail;
        shareTitle = obj.detail;
        shareContent = obj.detail;
    }
    if (obj.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    if (obj.detail.length > 15){
        shareTitle = [obj.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [self circleShareWithObj:obj];
    }];
    
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        [self shareToFriendWithObj:obj];
    }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:0];
    }];
    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,item2,nil];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:obj];
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            [Hud showMessageWithText:@"请您先安装手机QQ再分享动态"];
        }
    }];
    
}

- (void)shareToFriendWithObj:(CircleListObj *)obj
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",obj.nickname,obj.detail];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = obj.rid;
    vc.shareContent = shareText;
    [self.navigationController pushViewController:vc animated:YES];
}
//动态分享
-(void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *cityName = [SHGGloble sharedGloble].cityName;
    if(!cityName){
        cityName = @"";
    }
    NSDictionary *param = @{@"uid":uid,@"currCity":cityName};
    
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response){
         NSString *code = [response.data valueForKey:@"code"];
         if ([code isEqualToString:@"000"]){
             obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
             [self.listTable reloadData];
             [Hud showMessageWithText:@"分享成功"];
             [self refreshHeader];
         }
     } failed:^(MOCHTTPResponse *response) {
         [Hud showMessageWithText:response.errorMessage];
     }];
}

//圈内好友分享
-(void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.listTable reloadData];
            
            [MobClick event:@"ActionShareClicked" label:@"onClick"];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
        
    }];
}

#pragma mark -关注
- (void)attentionClicked:(CircleListObj *)obj
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    if([obj isKindOfClass:[CircleListObj class]]){
        //普通好友加关注的方法
        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
        NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
        if (![obj.isattention isEqualToString:@"Y"]) {
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    for (CircleListObj *cobj in self.dataArr) {
                        if ([cobj isKindOfClass:[CircleListObj class]] && [cobj.userid isEqualToString:obj.userid]) {
                            cobj.isattention = @"Y";
                        }
                    }
                    [MobClick event:@"ActionAttentionClicked" label:@"onClick"];
                    [Hud showMessageWithText:@"关注成功"];
                    NSString *state = [response.dataDictionary valueForKey:@"state"];
                    if ([state isEqualToString:@"2"]) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                    }
                } else{
                    [Hud showMessageWithText:@"关注失败"];
                }
                [self.listTable reloadData];
            } failed:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                [Hud showMessageWithText:response.errorMessage];
            }];
        } else{
            [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Hud hideHud];
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    if ([self.circleType isEqualToString:@"attention"]) {
                        NSMutableArray *removeArr = [NSMutableArray array];
                        for (CircleListObj *cobj in self.dataArr) {
                            if ([cobj.userid isEqualToString:obj.userid] &&![cobj.userid isEqualToString:CHATID_MANAGER]) {
                                [removeArr addObject:cobj];
                            }
                        }
                        [self.dataArr removeObjectsInArray:removeArr];
                    }else {
                        for (CircleListObj *cobj in self.dataArr) {
                            if ([cobj isKindOfClass:[CircleListObj class]] && [cobj.userid isEqualToString:obj.userid]) {
                                cobj.isattention = @"N";
                            }
                        }
                    }
                    
                    NSDictionary *data = [[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
                    NSString *state = [data valueForKey:@"state"];
                    if ([state isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                    }
                    [MobClick event:@"ActionAttentionClickedFalse" label:@"onClick"];
                    [Hud showMessageWithText:@"取消关注成功"];
                    [self refreshTable];
                } else{
                    [Hud showMessageWithText:@"失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Hud hideHud];
                [Hud showMessageWithText:error.domain];
            }];
        }
    } else{
        //这个是推荐栏目加关注的方法 因为不是同一个类 不得已多写一个else
        RecmdFriendObj *friend = (RecmdFriendObj *)obj;
        if(!friend.uid || friend.uid.length == 0){
            [Hud showMessageWithText:@"暂未获取到此用户的ID"];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
        NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":friend.uid};
        if(!friend.isFocus){
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    friend.isFocus = YES;
                    [MobClick event:@"ActionAttentionClicked" label:@"onClick"];
                    [Hud showMessageWithText:@"关注成功"];
                    NSString *state = [response.dataDictionary valueForKey:@"state"];
                    if ([state isEqualToString:@"2"]) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                    }
                } else{
                    [Hud showMessageWithText:@"失败"];
                }
                [self.listTable reloadData];
            } failed:^(MOCHTTPResponse *response) {
                [Hud showMessageWithText:response.errorMessage];
            }];
        } else{
            [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    friend.isFocus = NO;
                    NSDictionary *data = [[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
                    NSString *state = [data valueForKey:@"state"];
                    if ([state isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                    }
                    [MobClick event:@"ActionAttentionClickedFalse" label:@"onClick"];
                    [Hud showMessageWithText:@"取消关注成功"];
                    [self.listTable reloadData];
                } else{
                    [Hud showMessageWithText:@"失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Hud showMessageWithText:error.domain];
            }];
        }
    }
    
}

-(NSInteger)findIndexByObj:(CircleListObj *)obj
{
    NSInteger index;
    
    for (int i = 0; index<self.dataArr.count; i ++)
    {
        CircleListObj *listObj = self.dataArr[i];
        if ([obj.userid isEqualToString:listObj.userid])
        {
            return i;
            break;
        }
    }
    return 0;
}

#pragma mark detailDelagte

- (void)detailDeleteWithRid:(NSString *)rid
{
    for (id obj in self.listArray){
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *obj1 = (CircleListObj*)obj;
            if ([obj1.rid isEqualToString:rid]){
                [self.listArray removeObject:obj1];
                [self.dataArr removeObject:obj1];
                [self.listTable reloadData];
                break;
            }
        }
    }
}

- (void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    for (CircleListObj *obj in self.dataArr){
        if ([obj isKindOfClass:[CircleListObj class]] && [obj.rid isEqualToString:rid]){
            obj.praisenum = num;
            obj.ispraise = isPrased;
            break;
        }
        
    }
    [self.listTable reloadData];
}

- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    for (id obj in self.dataArr){
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *obj1 = (CircleListObj*)obj;
            if ([obj1.rid isEqualToString:rid]){
                obj1.sharenum = num;
                break;
            }
        }else{
            
        }
    }
    [self.listTable reloadData];
    
}
- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    for (id obj in self.dataArr){
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *obj1 = (CircleListObj*)obj;
            if ([obj1.userid isEqualToString:rid]){
                obj1.isattention = atten;
            }
        }
    }
    [self.listTable reloadData];

}
-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    for (id obj in self.dataArr){
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *obj1 = (CircleListObj*)obj;
            if ([obj1.rid isEqualToString:rid]){
                obj1.cmmtnum = num;
                obj1.comments = comments;
                 break;
            }
        }else{
            
        }
    }
    [self.listTable reloadData];
    
}
-(void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
    vc.userId = uid;
    vc.userName = name;
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cnickCLick:(NSString * )userId name:(NSString *)name
{
    [self gotoSomeOne:userId name:name];
}

- (void)attentionChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailAttentionWithRid:obj.userid attention:obj.isattention];
}

- (void)commentsChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailCommentWithRid:obj.rid commentNum:obj.cmmtnum comments:obj.comments];
}


- (void)praiseChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailPraiseWithRid:obj.rid praiseNum:obj.praisenum isPraised:obj.ispraise];
}

- (void)shareChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailShareWithRid:obj.rid shareNum:obj.sharenum];
}

- (void)deleteChanged:(NSNotification *)noti
{
    CircleListObj *obj = noti.object;
    [self detailDeleteWithRid:obj.rid];
}

@end
