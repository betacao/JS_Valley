//
//  ProdSubViewController.m
//  Finance
//
//  Created by HuMin on 15/5/5.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProdSubViewController.h"

@interface ProdSubViewController ()
- (IBAction)actionTel:(id)sender;
- (IBAction)actionGo:(id)sender;

@end

@implementation ProdSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布产品";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionTel:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:MANAGER_PHONE otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *call = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",MANAGER_PHONE]];
        if ([[UIApplication sharedApplication] canOpenURL:call]) {
            [[UIApplication sharedApplication] openURL:call];
        }
    }
}

- (IBAction)actionGo:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES]
    ;}
@end
