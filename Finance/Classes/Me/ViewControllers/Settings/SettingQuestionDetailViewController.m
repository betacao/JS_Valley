//
//  SettingQuestionDetailViewController.m
//  DingDCommunity
//
//  Created by haibo li on 14-6-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingQuestionDetailViewController.h"
#import "SettingQuestionObj.h"

@interface SettingQuestionDetailViewController ()

@end

@implementation SettingQuestionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initQuestion];
	self.title  = @"常见问题";
}

- (void) initQuestion
{
    self.title=_name;
    if(_type==0)
    {
        _txContext.text=@"①您手机本身设置不接受叮咚生活推送的即时消息，请在设置→通知中心→叮咚生活中，打开推送功能；\n②叮咚生活APP将推送关闭了：您可以点击我的叮咚-系统设置-将消息推送打开。";
    }else if(_type==1)
    {
        _txContext.text=@"登陆界面点击忘记密码，输入注册的手机号，获取验证码，设置新密码。";
    }else if(_type==2)
    {
        _txContext.text=@"点击社区活动进入社区活动界面，点击右上角按钮即可显示往期报名信息。";
    }else if(_type==3)
    {
        _txContext.text=@"详细的叮咚柜使用明细可查阅叮咚柜-帮助说明，同时，小区内叮咚的柜面也有详细的操作指南哦！";
    }else if(_type==4)
    {
        _txContext.text=@"叮咚生活将不定期的为大家展现新的功能模块，同时，如果您有意见或者建议也可以直接将您的意见投递是我们的意见箱（叮咚生活-我的叮咚-系统设置-意见反馈）、致电你所在小区的客服中心或者我们的服务监督电话400-828-9555。";
    }else if(_type==5)
    {
        _txContext.text=@"①您可通过小区内张贴的宣传海报上面的二维码进行扫描安装\n②微信关注“叮咚生活”点击进入主页，右下角-APP下载，来下载叮咚生活APP\n③管家送至您手中的邀请函上同时也有APP二维码可供扫描，进行安装";
    }else if (_type==6)
    {
        _txContext.text=@"您可致电您的管家，由管家核实后向叮咚公司提交申请，获取房号验证码，并告知您。";
    }else if (_type == 7){
        _txContext.text = @"叮咚币是用于本软件的优惠券，用户可用叮咚币抵用一部分折扣,且仅限于叮咚平台内使用。";
    }else if (_type == 8){
        _txContext.text = @"叮咚生活中所有活动和活动奖品由我司负责组织和解释，如有纠纷，与苹果公司无关。活动详情以APP公布内容为准。";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxContext:nil];
    [super viewDidUnload];
}
@end
