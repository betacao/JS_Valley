//
//  SHGCompanyBrowserViewController.m
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCompanyBrowserViewController.h"

@interface SHGCompanyBrowserViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SHGCompanyBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)addAutoLayout
{
    self.webView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud showWait];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Hud hideHud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
