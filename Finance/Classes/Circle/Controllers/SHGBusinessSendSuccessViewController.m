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
@interface SHGBusinessSendSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIImageView *explianImage;
@property (weak, nonatomic) IBOutlet UIButton *sharButton;

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
}

- (void)addSdLayout
{
    UIImage *logoImage = [UIImage imageNamed:@"businessSendSuccessLogo"];
    CGSize logoSize = logoImage.size;
    
    self.centerImage.sd_layout
    .topSpaceToView(self.view, MarginFactor(138.0f))
    .centerXEqualToView(self.view)
    .widthIs(logoSize.width)
    .heightIs(logoSize.height);
    
    UIImage *explainImage = [UIImage imageNamed:@"businessSendSuccessExplian"];
    CGSize explainSize = explainImage.size;
    
    self.explianImage.sd_layout
    .topSpaceToView(self.centerImage, MarginFactor(33.0f))
    .centerXEqualToView(self.centerImage)
    .widthIs(explainSize.width)
    .heightIs(explainSize.height);
    
    self.sharButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .bottomSpaceToView(self.view, MarginFactor(19.0f))
    .heightIs(MarginFactor(40.0f));
    
    [self.sharButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sharButton setBackgroundColor:Color(@"f04241")];
    self.sharButton.titleLabel.font = FontFactor(17.0f);
}

- (IBAction)shareButtonClick:(UIButton *)sender
{
    [[SHGBusinessManager shareManager] shareAction:self.object baseController:self finishBlock:^(BOOL success) {
   
    }];

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
