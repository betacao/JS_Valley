//
//  SHGHomeViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGHomeViewController.h"
#import "CircleListObj.h"
#import "CircleSendViewController.h"
#import "ChatViewController.h"
#import "CircleListTwoTableViewCell.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
#import "RecmdFriendObj.h"
#import "CircleListRecommendViewController.h"
#import "SHGNoticeView.h"
#import "CCLocationManager.h"
#import "SHGHomeTableViewCell.h"
#import "CircleDetailViewController.h"
#import "SHGUnifiedTreatment.h"
#import "SHGUserTagModel.h"
#import "SHGPersonalViewController.h"
#import "SHGSelectTagsViewController.h"
#import "SHGEmptyDataView.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

const CGFloat kAdTableViewCellHeight = 191.0f;
const CGFloat kAdButtomMargin = 20.0f;

@interface SHGHomeViewController ()<MLEmojiLabelDelegate,CLLocationManagerDelegate,SHGNoticeDelegate,CircleListDelegate>
{
    NSInteger photoIndex;
    BOOL hasRequestFailed;
}

@property (weak, nonatomic) IBOutlet UITableView *listTable;
//判断是否已经加载过推荐列表
@property (strong, nonatomic) NSMutableArray *recomandArray;

@property (assign, nonatomic) BOOL hasRequestedFirst;
@property (assign, nonatomic) BOOL hasDataFinished;

@property (strong, nonatomic) CircleListRecommendViewController *recommendViewController;

@property (strong, nonatomic) SHGNoticeView *newFriendNoticeView;
@property (strong, nonatomic) SHGNoticeView *newMessageNoticeView;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *circleType;
@property (assign, nonatomic) BOOL shouldDisplayRecommend;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

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
    [self addHeaderRefresh:self.listTable headerRefesh:YES headerTitle:@{kRefreshStateIdle:@"下拉可以刷新", kRefreshStatePulling:@"释放后查看最新动态", kRefreshStateRefreshing:@"正在努力加载中"} andFooter:YES footerTitle:nil];
    self.listTable.separatorStyle = NO;
    //处理tableView左边空白
    if ([self.listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTable setLayoutMargins:UIEdgeInsetsZero];
    }

    self.hasRequestedFirst = NO;
    self.shouldDisplayRecommend = YES;
    
    self.circleType = @"all";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFI_SENDPOST object:nil];
    [self loadRegisterPushFriend];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SHGHomeViewController" label:@"onClick"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.hasRequestedFirst){
        self.hasRequestedFirst = YES;
        [Hud showLoadingWithMessage:@"加载中"];

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

                [weakSelf.listTable.header endRefreshing];
                [weakSelf.listTable.footer endRefreshing];

                [weakSelf.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)allArray.count]];

                [weakSelf insertRecomandArray];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [weakSelf.listTable reloadData];
                });
            } else{
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
        _recommendViewController = [[CircleListRecommendViewController alloc] init];
        _recommendViewController.delegate = [SHGUnifiedTreatment sharedTreatment];
        _recommendViewController.closeBlock = ^{
            weakSelf.shouldDisplayRecommend = NO;
            NSInteger index = [weakSelf.dataArr indexOfObject:weakSelf.recomandArray];
            [weakSelf.dataArr removeObject:weakSelf.recomandArray];
            [weakSelf.listTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    return _recommendViewController;
}

- (UITableView *)currentTableView
{
    return self.listTable;
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (NSMutableArray *)currentListArray
{
    return self.listArray;
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

- (void)requestRecommendFriends
{
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID] stringValue];
    NSDictionary *param = @{@"uid":uid, @"area":@""};
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
        [weakSelf insertRecomandArray];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf.listTable reloadData];
        });

    } failed:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.error);

    }];
}

- (void)insertRecomandArray
{
    if ([self.dataArr indexOfObject:self.recomandArray]||self.recomandArray.count == 0) {
        return;
    }
    //当前允许显示推荐好友 并且是动态页面不是已关注页面
    if(self.shouldDisplayRecommend){
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

    if ([target isEqualToString:@"first"]){
        [self.listTable.footer resetNoMoreData];
        self.hasDataFinished = NO;
    } else if([target isEqualToString:@"load"]){
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":uid, @"type":@"all", @"target":target, @"rid":@(rid), @"num": rRequestNum, @"tagId" : @"-1"};

    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,dynamicAndNews] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        weakSelf.isRefreshing = NO;
        [weakSelf assembleDictionary:response.dataDictionary target:target];

        [weakSelf.listTable.header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
        [Hud hideHud];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf.listTable reloadData];
        });
      
    } failed:^(MOCHTTPResponse *response){
        weakSelf.isRefreshing = NO;
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
        }else{
            [self.dataArr addObjectsFromArray:self.adArray];
        }
        [self insertRecomandArray];
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
        }else{
            [self.dataArr addObjectsFromArray:self.adArray];
        }
        [self insertRecomandArray];

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

- (void)endrefresh
{
    [self.listTable.footer endRefreshing];
}
//发帖
- (void)actionPost:(UIButton *)sender
{
    CircleSendViewController *postVC = [[CircleSendViewController alloc] initWithNibName:@"CircleSendViewController" bundle:nil];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
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
        [self.listTable.footer endRefreshingWithNoMoreData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
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
            [self.recommendViewController loadViewWithData:array];
            [cell.contentView addSubview:self.recommendViewController.view];
            return cell;

        } else{
            CircleListObj *obj = self.dataArr[indexPath.row];
            NSLog(@"%@",obj.postType);
            if (![obj.postType isEqualToString:@"ad"]){
                if ([obj.status boolValue]){
                    NSString *cellIdentifier = @"circleListIdentifier";
                    SHGHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell){
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGHomeTableViewCell" owner:self options:nil] lastObject];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.index = indexPath.row;
                    cell.delegate = [SHGUnifiedTreatment sharedTreatment];
                    [cell loadDatasWithObj:obj type:@"normal"];

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

                    NSArray *array = (NSArray *)obj.photos;
                    if (array && array.count > 0){
                        [cell.popularizeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,array[0]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                    } else{
                        [cell.popularizeImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"default_image"]];
                    }

                    //防止图片压缩
                    cell.popularizeImage.contentMode = UIViewContentModeScaleAspectFit;

                    cell.adLable.text = @"推广";
                    cell.adLable.textColor = [UIColor grayColor];
                    cell.lableTime.text = obj.publishdate;
                    cell.lableTime.textAlignment = NSTextAlignmentRight;
                    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
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
    } else{
        return CGRectGetHeight(self.view.frame) - kTabBarHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count > 0) {
        NSInteger count = self.dataArr.count;
        return count;
    } else{
        return 1;
    }

}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
        if([obj isKindOfClass:[CircleListObj class]]){
            if (!IsStrEmpty(obj.feedhtml)){
                NSLog(@"%@",obj.feedhtml);
                LinkViewController *controller = [[LinkViewController alloc]init];
                controller.url = obj.feedhtml;
                controller.object = obj;
                [self.navigationController pushViewController:controller animated:YES];
            } else{
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

//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark cellDelegate

- (void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = [SHGUnifiedTreatment sharedTreatment];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

