//
//  BaseViewController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGHomeViewController.h"
#import "ProductListViewController.h"
#import "MeViewController.h"
#import "ChatListViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
       

    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapGes setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGes];
    self.view.userInteractionEnabled = YES;
}

- (void)initUI
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName ;
    if (IsStrEmpty(self.leftItemtitleName)){
        if (!IsStrEmpty(self.leftItemImageName)){
            imageName = self.leftItemImageName;
        } else{
            imageName = @"common_backImage";
        }
        [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    } else{
        [leftButton setTitle:self.leftItemtitleName forState:UIControlStateNormal];
        [leftButton setTitleColor:RGB(255, 0, 40) forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }

    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    NSString *rightImageName ;
    if (!IsStrEmpty(self.rightItemImageName))
    {
        rightImageName = self.rightItemImageName;
        [rightButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    else if(!IsStrEmpty(self.rightItemtitleName))
    {
        [rightButton setTitle:self.rightItemtitleName forState:UIControlStateNormal];
        [rightButton setTitleColor:RGB(255, 0, 40) forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    else
    {
        
    }
    if (!IsStrEmpty(self.rightItemtitleName) || !IsStrEmpty(self.rightItemImageName))
    {
        [rightButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
}
- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed){
        
    }
    else{
        
    }
}


-(void)tapAction:(UITapGestureRecognizer *)ges
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *view = (UITextField *)subView;
            [view resignFirstResponder];
        }
    }
}

#ifdef __IPHONE_7_0

- (BOOL)prefersStatusBarHidden
{
     //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return NO;
}
#endif
- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(id)sender
{
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    CGRect rect = self.view.frame;
    rect.origin.y = rect.origin.y- self.upDistance;
    self.view.frame = rect;
    [UIView setAnimationDuration:0.3];
    
    [UIView commitAnimations];
    
}// became first responder
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];

    CGRect rect = self.view.frame;
    rect.origin.y = rect.origin.y + self.upDistance;
    self.view.frame = rect;
    [UIView setAnimationDuration:0.3];
    
    [UIView commitAnimations];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
