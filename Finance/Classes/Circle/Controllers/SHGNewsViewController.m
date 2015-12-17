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
//添加分类
#import "CirclleItemObj.h"
#import "SHGNewsTableViewCell.h"
#import "CircleNewDetailViewController.h"
@interface SHGNewsViewController ()<MLEmojiLabelDelegate,CLLocationManagerDelegate,SHGNoticeDelegate>
{
     UIImageView *imageBttomLine;
     NSInteger width;
     NSInteger index;
     NSInteger currentSelect;
    //UILabel * tname;
}
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (assign, nonatomic) BOOL isRefreshing;
@property (strong, nonatomic) NSString *circleType;
@property (strong, nonatomic) SHGNoticeView *messageNoticeView;
@property (assign, nonatomic) BOOL hasDataFinished;
@property (strong, nonatomic) SHGSelectTagsViewController *tagsController;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) NSMutableArray *itemArr;
@property (assign, nonatomic) NSString * currentTagId;
@property (strong, nonatomic) NSMutableArray *currentArry;

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
    [self requestType];
    self.circleType = @"attation";
    [Hud showLoadingWithMessage:@"加载中"];
    //[self requestDataWithTarget:@"first" time:0 tagId:self.currentTagId];
   
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
    return self.currentArry;
}
//资讯类别
- (NSMutableArray * ) itemArr;
{
    if (!_itemArr) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

- (NSMutableArray * ) currentArry;
{
    if (!_currentArry) {
        _currentArry = [NSMutableArray array];
    }
    return _currentArry;
}

/*
- (SHGSelectTagsViewController *)tagsController
{
    if(!_tagsController){
        _tagsController = [SHGSelectTagsViewController shareTagsView];
    }
    return _tagsController;
}
*/

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


- (SHGNoticeView *)messageNoticeView
{
    if(!_messageNoticeView){
        _messageNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _messageNoticeView.superView = self.view;
    }
    return _messageNoticeView;
}

#pragma mark ------主要逻辑------
- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time tagId:(NSString * )tagId
{
    self.isRefreshing = YES;
   // NSDictionary *userTags = [SHGGloble sharedGloble].maxUserTags;
    
    if ([target isEqualToString:@"first"]){
        [self.listTable.footer resetNoMoreData];
        self.hasDataFinished = NO;
    } else if([target isEqualToString:@"load"]){
       // userTags = [SHGGloble sharedGloble].minUserTags;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":uid, @"type":@"attation", @"target":target, @"rid":@(rid), @"num": rRequestNum, @"tagId" :tagId };

    __weak typeof(self) weakSelf = self;

    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"dynamic",@"dynamicAndNews"] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
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
        self.currentArry = [self.dataArr objectAtIndex:index];
        [self.currentArry removeAllObjects];
        [self.currentArry addObjectsFromArray:normalArray];
        [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.currentArry.count]];
    } else if ([target isEqualToString:@"refresh"]){
        if (normalArray.count > 0){
            for (NSInteger i = normalArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [normalArray objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.currentArry insertObject:obj atIndex:0];
            }
            [self.messageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新资讯",(long)normalArray.count]];
        } else{
            [self.messageNoticeView showWithText:@"暂无新资讯，休息一会儿"];
        }
    } else if ([target isEqualToString:@"load"]){
        [self.currentArry addObjectsFromArray:normalArray];
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
   [self requestDataWithTarget:@"load" time:[self refreshMinRid] tagId:self.currentTagId];
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    if(self.isRefreshing){
        return;
    }
    if (self.currentArry.count > 0){
        [Hud showLoadingWithMessage:@"加载中"];
        //[self requestDataWithTarget:@"refresh" time:[self refreshMaxRid]];
        [self requestDataWithTarget:@"refresh" time:[self refreshMaxRid] tagId:self.currentTagId];
    } else{
        [Hud showLoadingWithMessage:@"加载中"];
        //[self requestDataWithTarget:@"first" time:@""];
        [self requestDataWithTarget:@"first" time:0 tagId:self.currentTagId];
    }

}

- (void)refreshFooter
{
    if (self.hasDataFinished){
        [self.listTable.footer endRefreshingWithNoMoreData];
        return;
    }
    NSLog(@"refreshFooter");
    if (self.currentArry.count > 0){
        [Hud showLoadingWithMessage:@"加载中"];
        //[self requestDataWithTarget:@"load" time:[self refreshMinRid]];
        [self requestDataWithTarget:@"load" time:[self refreshMinRid] tagId:self.currentTagId];
    }

}

- (NSString *)refreshMaxRid
{
//    NSString *rid = @"";
//    for (NSInteger i = 0; i < self.dataArr.count; i++) {
//        CircleListObj *obj = self.dataArr[i];
//        if([obj isKindOfClass:[CircleListObj class]]){
//            rid = obj.rid;
//            break;
//        }
//    }
    return ((CircleListObj *)[self.currentArry firstObject]).rid;
}

- (NSString *)refreshMinRid
{
//    NSString *rid = @"";
//    for(NSInteger i = self.dataArr.count - 1; i >=0; i--){
//        CircleListObj *obj = self.dataArr[i];
//        if([obj isKindOfClass:[CircleListObj class]]){
//            rid = obj.rid;
//            break;
//        }
//    }
    return ((CircleListObj *)[self.currentArry lastObject]).rid;
}

#pragma mark ------ UITableView DataSource ------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArry.count > 0) {
//        CircleListObj *obj = self.dataArr[indexPath.row];
//        obj.cellHeight = [obj fetchCellHeight];
//        return obj.cellHeight;
        return 83.0f;
    } else{
        return CGRectGetHeight(self.view.frame) - kTabBarHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentArry.count > 0) {
        NSInteger count = self.currentArry.count;
        return count;
    } else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArry.count > 0) {
//        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
//        NSLog(@"%@",obj.postType);
//        if (![obj.postType isEqualToString:@"ad"]){
//            if ([obj.status boolValue]){
//                NSString *cellIdentifier = @"circleListIdentifier";
//                SHGHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//                if (!cell){
//                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGHomeTableViewCell" owner:self options:nil] lastObject];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                cell.index = indexPath.row;
//                cell.delegate = [SHGUnifiedTreatment sharedTreatment];
//               [cell loadDatasWithObj:obj type:@"news"];
//
//                MLEmojiLabel *mlLable = (MLEmojiLabel *)[cell viewWithTag:521];
//                mlLable.delegate = self;
//                return cell;
//            }
//        }
        CircleListObj *obj = [self.currentArry objectAtIndex:indexPath.row];
        NSString * cellIdentifier = @"SHGNewsTableViewCell";
        SHGNewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SHGNewsTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
        [cell loadUi:obj];
        return cell;
    } else{
        return self.emptyCell;
    }
    return nil;
}

//添加列表上方的类别
-(void)initHeader
{
    CGFloat scrollViewHeight = 42.0f;
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, scrollViewHeight)];
    self.backScrollView.backgroundColor = [UIColor whiteColor];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.bounces = NO;
    NSInteger itemWidth = SCREENWIDTH/5;
    NSInteger contentWidth = SCREENWIDTH ;
    NSInteger itemHeight = 40.0f;
    self.backScrollView.tag = 1001;
    if (IsArrEmpty(self.itemArr)) {
        return;
    }
    if (self.itemArr.count < 5)
    {
        itemWidth = SCREENWIDTH/self.itemArr.count;
    }
    width = itemWidth;
    for (int i = 0; i < self.itemArr.count ;i ++)
    {
        CirclleItemObj *obj = self.itemArr[i];
        UILabel *item = [[UILabel alloc] init];
        item.userInteractionEnabled = YES;
        [item setFrame:CGRectMake(itemWidth *i, 0.0, itemWidth, itemHeight)];
        //item.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        item.tag = i+ 1000;
        
        UILabel * tname = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, itemWidth, itemHeight)];
        tname.tag = i +10;
        tname.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [tname setFont:[UIFont systemFontOfSize:14.0f]];
        [tname setTextColor:[UIColor colorWithHexString:@"333333"]];
        [tname setTextAlignment:NSTextAlignmentCenter];
        [tname setText:obj.tagname];
        [item addSubview:tname];
        
        DDTapGestureRecognizer *itemGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)];
        itemGes.tag = i;
        [item addGestureRecognizer:itemGes];
        
        [self.backScrollView addSubview:item];
        if (i == 0 ) {
            [tname setTextColor:[UIColor redColor]];
            currentSelect = 0 + 10;
        }
    }
    
    if (self.itemArr.count > 5)
    {
        contentWidth = (SCREENWIDTH/5) * self.itemArr.count;
    }
    UIView *backsView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight, SCREENHEIGHT, 8.0f)];
    backsView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    imageBttomLine = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth/2-20, 0, 40.0f, 2.0f)];
    [imageBttomLine setImage:[UIImage imageNamed:@"tab下划线"]];
    [backsView addSubview:imageBttomLine];
    
    [self.backScrollView addSubview:backsView];
    
    [self.backScrollView setContentSize:CGSizeMake(contentWidth, scrollViewHeight)];
    CirclleItemObj *obj = self.itemArr[0];
    self.currentTagId  = obj.tagid;
    index = 0;
    //[self requestDataWithtcode:@"" isHot:@"1" target:@"first" name:@"" time:@""];
     [self requestDataWithTarget:@"first" time:0 tagId:self.currentTagId];
    
}

-(void)itemTap:(DDTapGestureRecognizer *)ges
{
    index = ges.tag;
    self.currentArry = [self.dataArr objectAtIndex:index];
    if (currentSelect == ges.tag +10) {
        
    }else
    {
        UILabel * label1 = [self.view viewWithTag:ges.tag +10];
        if (label1.tag == ges.tag +10) {
            [label1 setTextColor:[UIColor redColor]];
        }
        UILabel * label2 = [self.view viewWithTag:currentSelect ];
        [label2 setTextColor:[UIColor colorWithHexString:@"333333"]];
        currentSelect = ges.tag +10;
    }
    
    CGRect rect = imageBttomLine.frame;
    rect.origin.x = (width/2-20)+( ges.tag* width);
    CirclleItemObj *obj = self.itemArr[ges.tag];
    self.currentTagId= obj.tagid;
        if (ges.tag == 0) {
        //[self requestDataWithtcode:obj.tcode isHot:@"1" target:@"first" name:@"" time:@""];
        
    }else
    {
       // [self requestDataWithtcode:obj.tcode isHot:@"" target:@"first" name:@"" time:@""];
    }
    //[self requestDataWithTarget:@"first" time:0 tagId:self.currentTagId];
    [self refreshHeader];
    [UIView beginAnimations:nil context:nil];
    [imageBttomLine setFrame:rect];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [self.listTable reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.backScrollView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGRectGetHeight(self.backScrollView.frame);
     if (self.itemArr.count == 0) {
        height = 0 ;
    }
    return height;
}

#pragma mark ------数据请求-----
-(void)requestType
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpUser,@"tag",@"newsTag"];
    [MOCHTTPRequestOperationManager getWithURL:url class:[CirclleItemObj class] parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.dataArray);
        if (response.dataArray.count > 0)
        {
            [self.itemArr addObjectsFromArray:response.dataArray];
            for (NSInteger i = 0; i < self.itemArr.count; i ++) {
                //index = i;
                NSMutableArray * arry = [NSMutableArray array];
                [self.dataArr addObject:arry];
            }
            
        }
        [self initHeader];
        
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
    }];
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
    
    if (self.currentArry.count > 0) {
       SHGNewsTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell loadTitleLabelChange];
        CircleListObj *obj = [self.currentArry objectAtIndex:indexPath.row];
        CircleNewDetailViewController *  viewController =[[CircleNewDetailViewController alloc] initWithNibName:@"CircleNewDetailViewController" bundle:nil];
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
