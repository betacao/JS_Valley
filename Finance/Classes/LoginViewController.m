//
//  LoginViewController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
- (IBAction)actionShowMem:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionFogetPwd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textPwd;
@property (weak, nonatomic) IBOutlet UITextField *textUser;

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.upDistance = 60;
        self.title = @"登录";
    }
    
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)initUI
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0, 44, 44)];
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NavRTitleColor forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [rightBtn addTarget:self action:@selector(actionRegist:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =============  Button Action =============

-(void)actionRegist:(id)sender
{
    NSLog(@"regist");
}

- (IBAction)actionShowMem:(id)sender {
    NSLog(@"showMem");

}

- (IBAction)actionLogin:(id)sender {
    NSLog(@"login");

}

- (IBAction)actionFogetPwd:(id)sender {
    NSLog(@"goget");

}
@end
