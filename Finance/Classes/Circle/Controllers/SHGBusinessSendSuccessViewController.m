//
//  SHGBusinessSendSuccessViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/28.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessSendSuccessViewController.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessShareToDynamicViewController.h"
#import "SHGTitleLabelCenterButton.h"

@interface SHGBusinessSendSuccessViewController ()
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) id publishContent;
@property (strong, nonatomic) id smsPublishContent;
@property (strong, nonatomic) NSString *friendContent;
@property (strong, nonatomic) NSString *messageContent;
@end

@implementation SHGBusinessSendSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布成功";
    self.view.backgroundColor = Color(@"efeeef");
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self addSdLayout];
    [self initView];
    
}

- (void)addSdLayout
{
    UIImage *image = [UIImage imageNamed:@"businessShareToCircle"];
    CGSize size = image.size;
    
    self.titleImageView.sd_layout
    .topSpaceToView(self.view, MarginFactor(107.0f))
    .centerXEqualToView(self.view)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.shareView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .centerYEqualToView(self.view);
}

- (void)initView
{
    self.titleImageView.image = [UIImage imageNamed:@"businessShareToCircle"];
    self.shareView.backgroundColor = Color(@"efeeef");
    CGFloat margin = MarginFactor(20.0f);
    CGFloat width = (SCREENWIDTH - 4 * margin) / 3.0f;
    NSArray *imageTitleArray = [[NSArray alloc] init];
    NSArray *imageArray = [[NSArray alloc] init];
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            imageTitleArray = @[@"动态",@"朋友圈",@"微信",@"QQ",@"短信",@"圈内好友"];
            imageArray = @[@"圈子图标",@"sns_icon_23",@"sns_icon_22",@"sns_icon_24",@"sns_icon_19",@"圈内好友图标"];
        } else{
            imageTitleArray = @[@"动态",@"朋友圈",@"微信",@"短信",@"圈内好友"];
            imageArray = @[@"圈子图标",@"sns_icon_23",@"sns_icon_22",@"sns_icon_19",@"圈内好友图标"];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            imageTitleArray = @[@"动态",@"QQ",@"短信",@"圈内好友"];
            imageArray = @[@"圈子图标",@"sns_icon_24",@"sns_icon_19",@"圈内好友图标"];
        } else{
            imageTitleArray = @[@"动态",@"短信",@"圈内好友"];
            imageArray = @[@"圈子图标",@"sns_icon_19",@"圈内好友图标"];
        }
    }

   
    for (NSInteger i = 0; i < imageTitleArray.count; i ++) {
        SHGTitleLabelCenterButton * button = [SHGTitleLabelCenterButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(margin + i%3 * (width + margin), i/3 * (width + margin), width, width);
        button.titleLabel.font = FontFactor(10.0f);
        [button setTitleColor:Color(@"787878") forState:UIControlStateNormal];
        [button setTitle:[imageTitleArray objectAtIndex:i] image:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:button];
    }
    if (imageTitleArray.count > 3) {
        self.shareView.sd_resetLayout
        .leftSpaceToView(self.view, 0.0f)
        .rightSpaceToView(self.view, 0.0f)
        .centerYIs(self.view.centerY + MarginFactor(20.0f))
        .heightIs(margin + 2 * width);
    } else{
        self.shareView.sd_resetLayout
        .leftSpaceToView(self.view, 0.0f)
        .rightSpaceToView(self.view, 0.0f)
        .centerYIs(self.view.centerY + MarginFactor(20.0f))
        .heightIs(width);
    }
    
    
}

- (UIImageView *)titleImageView
{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc]init];
        [self.view addSubview:_titleImageView];
    }
    return _titleImageView;
}

- (UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
        _shareView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shareView];
    }
    return _shareView;
}

- (void)buttonClick:(SHGTitleLabelCenterButton *)btn
{
    [self makePublishContent];
    int shareType = 0;
    id publishContent;
    publishContent = self.publishContent;
    if ([btn.titleLabel.text isEqualToString:@"微信"]) {
        shareType = ShareTypeWeixiSession;
    } else if ([btn.titleLabel.text isEqualToString:@"朋友圈"]){
        shareType = ShareTypeWeixiTimeline;
    } else if ([btn.titleLabel.text isEqualToString:@"QQ"]){
        shareType = ShareTypeQQ;
    } else if ([btn.titleLabel.text isEqualToString:@"短信"]){
        shareType = ShareTypeSMS;
        publishContent = self.smsPublishContent;
    } else if ([btn.titleLabel.text isEqualToString:@"圈内好友"]){
        shareType = ShareTypeOther;
        FriendsListViewController *vc = [[FriendsListViewController alloc] init];
        vc.isShare = YES;
        vc.shareContent = self.friendContent;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:@"动态"]){
        shareType = ShareTypeOther;
        SHGBusinessShareToDynamicViewController *viewController = [[SHGBusinessShareToDynamicViewController alloc] init];
        viewController.object = self.object;
        viewController.controller = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [ShareSDK showShareViewWithType:shareType container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id statusInfo, id error, BOOL end) {
        if (state == SSResponseStateSuccess)
        {
            [Hud showMessageWithText:@"分享成功"];
        }
        else if (state == SSResponseStateFail)
        {
            [Hud showMessageWithText:@"分享失败"];
        }
    }];

}

- (void)makePublishContent
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *request = [rBaseAddressForHttpBusinessShar stringByAppendingFormat:@"/business/share/businessDetail?rowId=%@&uid=%@&businessType=%@",self.object.businessID, uid, self.object.type];
    UIImage *png = [UIImage imageNamed:@"80.png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:png];
    NSString *title = self.object.businessTitle;
    NSString *theme = self.object.detail;
    if (theme.length > 15) {
        theme = [NSString stringWithFormat:@"%@...",[theme substringToIndex:15]];
    }
    //NSString *postContent = [NSString stringWithFormat:@"【业务】%@", theme];
    NSString *shareContent = [NSString stringWithFormat:@"【业务】%@", theme];
    
    self.friendContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我发布了一个非常棒的业务,关于",theme,@"，赶快去业务版块查看吧！",request];
    self.messageContent = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上发布了一个非常棒的业务,关于",theme,@"，赶快下载大牛圈查看吧！",@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"];
    NSString *shareUrl = request;
    self.publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:title url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    self.smsPublishContent = [ShareSDK content:self.messageContent defaultContent:self.messageContent image:image title:title url:shareUrl description:shareContent mediaType:SHARE_TYPE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

- (void)btnBackClick:(id)sender
{
    [[SHGBusinessListViewController sharedController] didCreateOrModifyBusiness:self.object];
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
}
@end
