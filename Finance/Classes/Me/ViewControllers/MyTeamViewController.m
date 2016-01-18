//
//  MyTeamViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyTeamViewController.h"
#import "TeamDetailObject.h"
#import "TeamDetailTableViewCell.h"
#import "SHGMyTeamListTableViewController.h"
@interface MyTeamViewController ()
	<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UITableViewCell *teamMoneyCell;
@property (nonatomic, strong) IBOutlet UILabel	*teamMoneyLabel;

@property (nonatomic, strong) IBOutlet UITableViewCell *myMoneyCell;
@property (nonatomic, strong) IBOutlet UILabel	*myMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, strong) IBOutlet UITableViewCell *teamEncourageDescriptionCell;
@property (weak, nonatomic) IBOutlet UIView *teamLine;
@property (weak, nonatomic) IBOutlet UIView *shuLine;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


- (IBAction)inviteButtonClicked:(id *)sender;

@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"我的合伙人";
	self.dataSource = [[NSMutableArray alloc] init];
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:view];
    self.teamLine.size = CGSizeMake(self.teamLine.width, 0.5f);
    self.shuLine.size = CGSizeMake(0.5f, self.shuLine.height);
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"team"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response){
        
        self.myMoneyLabel.text = [NSString stringWithFormat:@"%@ ",[response.dataDictionary valueForKey:@"me"]];
        self.teamMoneyLabel.text = [NSString stringWithFormat:@"%@ ",[response.dataDictionary valueForKey:@"team"]];
        NSArray *array = [response.dataDictionary valueForKey:@"detail"];
        
        for (NSDictionary *dic in array) {
            TeamDetailObject *obj = [[TeamDetailObject alloc] init];
            obj.name = [dic valueForKey:@"name"];
            obj.money = [dic valueForKey:@"commission"];
            [self.dataSource addObject:obj];
        }
        [self.tableView reloadData];
        
        
        NSLog(@"%@",response.data);
        NSLog(@"%@",response.errorMessage);
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	if (section == 0) {
//		return 2;
//	}else if(section == 1){
//		return self.dataSource.count;
//	}else if (section == 2){
//		return 1;
//	}
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 94.0f;
	}else if(indexPath.section == 1){
		return 65.0f;
	}else if (indexPath.section == 2){
		return 350.0f;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		//if (indexPath.row == 0) {
			return self.teamMoneyCell;
//		}else if( indexPath.row == 1){
//			return self.myMoneyCell;
//		}
	}else if (indexPath.section == 1){
//		static NSString *CellIdentifier = @"TeamDetailTableViewCell";
//		TeamDetailTableViewCell *cell = (TeamDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//		
//		// Configure the cell...
//		if (cell == nil) {
//			cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
//		}
//		
//		TeamDetailObject *obj = self.dataSource[indexPath.row];
//		cell.nameLabel.text = obj.name;
//		cell.moneyLabel.text = obj.money;
        self.totalLabel.text = [NSString stringWithFormat:@"%ld人",(long)self.dataSource.count];
		return self.myMoneyCell;

	}else if (indexPath.section == 2){
        self.contentLabel.numberOfLines = 0;
        NSString * str = @"1.您邀请的合伙人产生的销售佣金，您可获得其总佣金的5%的额外奖励。\n2.您的合伙人再邀请的成员产生的销售佣金，您也可以获得其总佣金1%的额外奖励。\n3.您每邀请10位好友成功注册且通过认证，将获得50元话费（150元封顶）充值。";
        NSMutableAttributedString *aCircleString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.0f];
        [aCircleString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle1, NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"565656"]} range:NSMakeRange(0, [aCircleString length])];
        self.contentLabel.attributedText = aCircleString;
        
		return self.teamEncourageDescriptionCell;
	}
	
	
	UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        SHGMyTeamListTableViewController * vc = [[SHGMyTeamListTableViewController alloc]init];
        [vc makeDate:self.dataSource];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)inviteButtonClicked:(id *)sender
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入金融大牛圈！金融从业人员的家！"];
    
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入金融大牛圈！金融从业人员的家！这里有干货资讯、人脉嫁接、业务互助！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"]  clickHandler:^{
        [self shareToSMS:content];
    }];
    
    NSString *shareUrl =[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:1];
    }];
    
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate] wechatShareWithText:contentOther shareUrl:shareUrl shareType:0];
    }];
//    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, SHARE_TYPE_NUMBER(ShareTypeQQ), nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, nil];
        }
    }
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:contentOther defaultContent:SHARE_DEFAULT_CONTENT image:image title:SHARE_TITLE_INVITE url:shareUrl description:SHARE_DEFAULT_CONTENT mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess){
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}

-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}
-(void)shareToSMS:(NSString *)text
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:@""];
}

@end
