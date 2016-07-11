//
//  SHGCircleDetailViewController.m
//  Finance
//
//  Created by changxicao on 16/7/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleDetailViewController.h"

@interface SHGCircleDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SHGCircleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.title = @"动态详情";
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)addAutoLayout
{
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud showWait];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Hud hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Hud hideHud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
