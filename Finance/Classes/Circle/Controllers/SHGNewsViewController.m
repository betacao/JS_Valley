//
//  SHGNewsViewController.m
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGNewsViewController.h"
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
#import "SHGSelectTagsViewController.h"
#import "SHGEmptyDataView.h"


@interface SHGNewsViewController ()<MLEmojiLabelDelegate,CLLocationManagerDelegate,SHGNoticeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *circleType;
@property (strong, nonatomic) SHGNoticeView *messageNoticeView;
@property (assign, nonatomic) BOOL hasDataFinished;
@property (strong, nonatomic) SHGSelectTagsViewController *tagsController;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:YES headerTitle:@{kRefreshStateIdle:@"下拉可以刷新", kRefreshStatePulling:@"释放后查看最新动态", kRefreshStateRefreshing:@"正在努力加载中"} andFooter:YES footerTitle:nil];
    self.listTable.separatorStyle = NO;
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    //处理tableView左边空白
    if ([self.listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTable setLayoutMargins:UIEdgeInsetsZero];
    }
    self.circleType = @"attation";
    [Hud showLoadingWithMessage:@"加载中"];
    [self requestDataWithTarget:@"first" time:@""];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SHGNewsViewController" label:@"onClick"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UITableView *)currentTableView
{
    return self.listTable;
}

- (NSMutableArray *) currentDataArray
{
    return self.dataArr;
}

- (SHGSelectTagsViewController *)tagsController
{
    if(!_tagsController){
        _tagsController = [[SHGSelectTagsViewController alloc] init];
    }
    return _tagsController;
}


- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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


- (SHGNoticeView *)messageNoticeView
{
    if(!_messageNoticeView){
        _messageNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _messageNoticeView.superView = self.view;
    }
    return _messageNoticeView;
}

#pragma mark ------主要逻辑------
- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    self.isRefreshing = YES;
    NSDictionary *userTags = [SHGGloble sharedGloble].maxUserTags;

    if ([target isEqualToString:@"first"]){
        [self.listTable.footer resetNoMoreData];
        self.hasDataFinished = NO;
    } else if([target isEqualToString:@"load"]){
        userTags = [SHGGloble sharedGloble].minUserTags;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":uid, @"type":@"attation", @"target":target, @"rid":@(rid), @"num": rRequestNum, @"tagIds" : userTags};

    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,circleListNew] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
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
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf.listTable reloadData];
        });
    } failed:^(MOCHTTPResponse *response){
        [Hud hideHud];
        weakSelf.isRefreshing = NO;
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.errorMessage);
        [weakSelf.listTable.header endRefreshing];
        [weakSelf performSelector:@selector(endrefresh) withObject:nil afterDelay:1.0];

    }];
}

- (void)assembleDictionary:(NSDictionary *)dictionary target:(NSString *)target
{
    //普通数据
    NSArray *normalArray = [dictionary objectForKey:@"normalpostlist"];
    normalArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:normalArray class:[CircleListObj class]];
    if ([target isEqualToString:@"first"]){
        //总数据
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:normalArray];
        [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.dataArr.count]];
    } else if ([target isEqualToString:@"refresh"]){
        if (normalArray.count > 0){
            for (NSInteger i = normalArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [normalArray objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.dataArr insertObject:obj atIndex:0];
            }
            [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新资讯",(long)normalArray.count]];
        } else{
            [self.messageNoticeView showWithText:@"暂无新资讯，休息一会儿"];
        }
    } else if ([target isEqualToString:@"load"]){
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

- (void)refreshLoad
{
    if (self.isRefreshing) {
        return;
    }
    [self requestDataWithTarget:@"first" time:@""];
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    if(self.isRefreshing){
        return;
    }
    if (self.dataArr.count > 0){
        [Hud showLoadingWithMessage:@"加载中"];
        [self requestDataWithTarget:@"refresh" time:[self refreshMaxRid]];
    } else{
        [Hud showLoadingWithMessage:@"加载中"];
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
        [Hud showLoadingWithMessage:@"加载中"];
        [self requestDataWithTarget:@"load" time:[self refreshMinRid]];
    }

}

- (NSString *)refreshMaxRid
{
    NSString *rid = @"";
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        CircleListObj *obj = self.dataArr[i];
        if([obj isKindOfClass:[CircleListObj class]]){
            rid = obj.rid;
            break;
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
            rid = obj.rid;
            break;
        }
    }
    return rid;
}

#pragma mark ------ UITableView DataSource ------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = self.dataArr[indexPath.row];
        obj.cellHeight = [obj fetchCellHeight];
        return obj.cellHeight;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
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
                [cell loadDatasWithObj:obj type:@"news"];

                MLEmojiLabel *mlLable = (MLEmojiLabel *)[cell viewWithTag:521];
                mlLable.delegate = self;
                return cell;
            }
        }
    } else{
        return self.emptyCell;
    }
    return nil;
}

//添加列表上方的标签
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tagsController.view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGRectGetHeight(self.tagsController.view.frame);
    if (height == 0) {
        return 26.0f;
    }
    return height;
}

#pragma mark ------ emoji代理------
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        CircleDetailViewController *viewController = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        viewController.delegate = [SHGUnifiedTreatment sharedTreatment];
        viewController.rid = obj.rid;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:obj.praisenum, kPraiseNum,obj.sharenum,kShareNum,obj.cmmtnum,kCommentNum, nil];
        viewController.itemInfoDictionary = dictionary;
        [self.navigationController pushViewController:viewController animated:YES];
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



#pragma mark ------ 代理 ------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
