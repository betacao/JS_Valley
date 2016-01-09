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
    // Do any additional setup after loading the view from its nib.
    self.lblVersion.text = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
	self.title = @"关于我们";
    self.bgImage.frame = CGRectMake(self.bgImage.origin.x,kBgImageY, self.bgImage.width, self.bgImage.height);
    self.lblVersion.frame = CGRectMake(self.lblVersion.origin.x, CGRectGetMaxY(self.bgImage.frame) +kLblVersionToBgSpace , self.lblVersion.width, self.lblVersion.height);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingAboutUsViewController" label:@"onClick"];
    self.title = @"关于我们";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.navigationController navbarLeftItemCustomized:@[btnBack] onwer:self.navigationItem];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
