//
//  SettingAboutUsViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingAboutUsViewController.h"
#define kLblVersionToBgSpace 16.0f * YFACTOR
#define kBgImageY 100.0f * YFACTOR
@interface SettingAboutUsViewController ()

@property (nonatomic, strong) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation SettingAboutUsViewController

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
    [MobClick event:@"SettingAboutUsViewController" label:@"onClick"];
    self.lblVersion.text = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
	self.title = @"关于我们";
    self.bgImage.frame = CGRectMake(self.bgImage.origin.x,kBgImageY, self.bgImage.width, self.bgImage.height);
    self.lblVersion.frame = CGRectMake(self.lblVersion.origin.x, CGRectGetMaxY(self.bgImage.frame) +kLblVersionToBgSpace , self.lblVersion.width, self.lblVersion.height);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
