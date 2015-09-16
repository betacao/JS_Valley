//
//  SettingAboutUsViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingAboutUsViewController.h"

@interface SettingAboutUsViewController ()

@property (nonatomic, strong) IBOutlet UILabel *lblVersion;

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
    self.lblVersion.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
	self.title = @"关于我们";

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
