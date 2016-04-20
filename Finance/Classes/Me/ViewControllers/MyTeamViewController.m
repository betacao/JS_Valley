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

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UILabel *partenrMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partenrMoneyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyCountLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLineView;
@property (weak, nonatomic) IBOutlet UIView *firstBlackView;
@property (weak, nonatomic) IBOutlet UIView *secondBlackView;
@property (weak, nonatomic) IBOutlet UILabel *partenrDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *partnerExplainLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerExplainDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineView;
@property (weak, nonatomic) IBOutlet UIButton *iniviteButton;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) NSDictionary *dictionary;

- (IBAction)inviteButtonClicked:(id *)sender;

@end

@implementation MyTeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的合伙人";
    self.dataSource = [[NSMutableArray alloc] init];
    [self initView];
    [self addSdLayout];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"team"] parameters:@{@"uid":UID}success:^(MOCHTTPResponse *response){
        self.dictionary = response.dataDictionary;
        NSArray *array = [response.dataDictionary valueForKey:@"detail"];
        for (NSDictionary *dic in array) {
            TeamDetailObject *obj = [[TeamDetailObject alloc] init];
            obj.name = [dic valueForKey:@"name"];
            obj.money = [dic valueForKey:@"commission"];
            [self.dataSource addObject:obj];
        }
        [self loadData];
        NSLog(@"%@",response.data);
        NSLog(@"%@",response.errorMessage);
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.partenrMoneyLabel.font = FontFactor(12.0f);
    self.partenrMoneyLabel.textColor = [UIColor colorWithHexString:@"989898"];
    self.partenrMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.myMoneyLabel.font = FontFactor(12.0f);
    self.myMoneyLabel.textColor = [UIColor colorWithHexString:@"989898"];
    self.myMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.partenrMoneyCountLabel.font = FontFactor(20.0f);
    self.partenrMoneyCountLabel.textColor = [UIColor colorWithHexString:@"d43c33"];
    self.partenrMoneyCountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.myMoneyCountLabel.font = FontFactor(20.0f);
    self.myMoneyCountLabel.textColor = [UIColor colorWithHexString:@"d43c33"];
    self.myMoneyCountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.verticalLineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.horizontalLineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.firstBlackView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.secondBlackView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    
    self.partenrDetailLabel.font = FontFactor(15.0f);
    self.partenrDetailLabel.textAlignment = NSTextAlignmentLeft;
    self.partenrDetailLabel.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.partnerCountLabel.font = FontFactor(15.0f);
    self.partnerCountLabel.textAlignment = NSTextAlignmentRight;
    self.partnerCountLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.partnerExplainLabel.font = FontFactor(15.0f);
    self.partnerExplainLabel.textAlignment = NSTextAlignmentLeft;
    self.partnerExplainLabel.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.partnerExplainDetailLabel.font = FontFactor(15.0f);
    self.partnerExplainDetailLabel.textColor = [UIColor colorWithHexString:@"565656"];
    
    [self.iniviteButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
    [self.iniviteButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.iniviteButton.titleLabel.font = FontFactor(17.0f);
    
    self.tapView.backgroundColor = [UIColor clearColor];
    self.tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tapView addGestureRecognizer:tapGes];
    
}

- (void)addSdLayout
{
    self.verticalLineView.sd_layout
    .leftSpaceToView(self.view, SCREENWIDTH / 2.0f)
    .centerYIs(MarginFactor(59.0f))
    .widthIs(0.5f)
    .heightIs(MarginFactor(39.0f));
    
    self.partenrMoneyLabel.sd_layout
    .topEqualToView(self.verticalLineView)
    .centerXIs(SCREENWIDTH / 4.0f)
    .autoHeightRatio(0.0f);
    [self.partenrMoneyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.myMoneyLabel.sd_layout
    .topEqualToView(self.verticalLineView)
    .centerXIs(3 * SCREENWIDTH / 4.0)
    .autoHeightRatio(0.0f);
    [self.myMoneyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
  
    self.partenrMoneyCountLabel.sd_layout
    .topSpaceToView(self.partenrMoneyLabel, MarginFactor(5.0f))
    .centerXEqualToView(self.partenrMoneyLabel)
    .autoHeightRatio(0.0f);
    [self.partenrMoneyCountLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.myMoneyCountLabel.sd_layout
    .topSpaceToView(self.myMoneyLabel, MarginFactor(5.0f))
    .centerXEqualToView(self.myMoneyLabel)
    .autoHeightRatio(0.0f);
    [self.myMoneyCountLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.firstBlackView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, MarginFactor(117.0f))
    .heightIs(11.0f);
    
    self.partenrDetailLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.firstBlackView, MarginFactor(22.0f))
    .autoHeightRatio(0.0f);
    [self.partenrDetailLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"rightArrowImage"];
    CGSize size = image.size;
    
    self.rightButton.sd_layout
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .centerYEqualToView(self.partenrDetailLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.partnerCountLabel.sd_layout
    .rightSpaceToView(self.rightButton, MarginFactor(8.0f))
    .centerYEqualToView(self.partenrDetailLabel)
    .autoHeightRatio(0.0f);
    [self.partnerCountLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.secondBlackView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.partenrDetailLabel, MarginFactor(22.00f))
    .heightIs(11.0f);
    
    self.partnerExplainLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.secondBlackView, MarginFactor(22.0f))
    .autoHeightRatio(0.0f);
    [self.partnerExplainLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.horizontalLineView.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.partnerExplainLabel, MarginFactor(22.0f))
    .heightIs(0.5f);
    
    self.partnerExplainDetailLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.horizontalLineView, MarginFactor(18.0f))
    .autoHeightRatio(0.0f);
    
    
    self.iniviteButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .bottomSpaceToView(self.view, MarginFactor(19.0f))
    .heightIs(35.0f);
    
    self.tapView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.firstBlackView, 0.0f)
    .bottomSpaceToView(self.secondBlackView, 0.0f);
}

- (void)loadData
{
    self.partenrMoneyLabel.text = @"合伙人佣金";
    [self.partenrMoneyLabel sizeToFit];
    self.myMoneyLabel.text = @"我的佣金";
    [self.myMoneyLabel sizeToFit];
    self.partenrMoneyCountLabel.text = [NSString stringWithFormat:@"%@ ",[self.dictionary valueForKey:@"team"]];
    [self.partenrMoneyCountLabel sizeToFit];
    self.myMoneyCountLabel.text = [NSString stringWithFormat:@"%@ ",[self.dictionary valueForKey:@"me"]];
    self.myMoneyCountLabel.text = @"100";
    [self.myMoneyCountLabel sizeToFit];
    self.partenrDetailLabel.text = @"合伙人明细";
    [self.partenrDetailLabel sizeToFit];
    self.partnerCountLabel.text = [NSString stringWithFormat:@"%ld人",(long)self.dataSource.count];
    [self.partnerCountLabel sizeToFit];
    self.partnerExplainLabel.text = @"合伙人激励机制说明";
    [self.partnerExplainLabel sizeToFit];
    self.partnerExplainDetailLabel.text = @"1.您邀请的合伙人产生的销售佣金，您可获得其总佣金的5%的额外奖励。\n2.您的合伙人再邀请的成员产生的销售佣金，您也可以获得其总佣金1%的额外奖励。\n3.您每邀请10位好友成功注册且通过认证，将获得50元话费（150元封顶）充值。";
    [self.partnerExplainDetailLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    SHGMyTeamListTableViewController * vc = [[SHGMyTeamListTableViewController alloc]init];
    [vc makeDate:self.dataSource];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)inviteButtonClicked:(id *)sender
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *contentOther =[NSString stringWithFormat:@"%@",@"诚邀您加入大牛圈--金融业务互助平台"];
    
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈--金融业务互助平台！这里有业务互助、人脉嫁接！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    
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
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item5, item4, item3, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, nil];
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
