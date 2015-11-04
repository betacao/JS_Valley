//
//  SHGAttationViewController.m
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGAttationViewController.h"
#import "CircleListObj.h"
#import "CircleSendViewController.h"
#import "CircleSomeOneViewController.h"
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

@interface SHGAttationViewController ()<MLEmojiLabelDelegate,CLLocationManagerDelegate,CircleActionDelegate,SHGNoticeDelegate, CircleListDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *circleType;
@property (strong, nonatomic) SHGNoticeView *messageNoticeView;
@property (assign, nonatomic) BOOL hasDataFinished;

@end

@implementation SHGAttationViewController

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
    [self requestDataWithTarget:@"first" time:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SHGAttationViewController" label:@"onClick"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [Hud showLoadingWithMessage:@"加载中"];
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
            [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)normalArray.count]];
        } else{
            [self.messageNoticeView showWithText:@"暂无新动态，休息一会儿"];
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

#pragma mark ------ UITableView DataSource ------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj =self.dataArr[indexPath.row];
    obj.cellHeight = [obj fetchCellHeight];
    return obj.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArr.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark ------ 分享 ------
- (void)smsShareSuccess:(NSNotification *)noti
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
//                [self otherShareWithObj:objs];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
