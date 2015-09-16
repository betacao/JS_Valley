//
//  ProdConsulutionViewController.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProdConsulutionViewController.h"

@interface ProdConsulutionViewController ()
- (IBAction)actonTel:(id)sender;
- (IBAction)actionGo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *actionTel;

@end

@implementation ProdConsulutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品顾问服务";
    self.lblCodeStr.text = self.codeStr;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actonTel:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:MANAGER_PHONE otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (IBAction)actionGo:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
