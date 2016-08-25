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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[CommonMethod imageWithColor:Color(@"d43c33")] forBarMetrics:UIBarMetricsDefault];
}

- (void)initView
{
    self.title = self.object.companyName;

    NSHTTPCookie *cookie = nil;;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    self.webView.backgroundColor = Color(@"d43c33");
    self.webView.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.object.companyUrl]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0f];
    [self.webView loadRequest:request];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Hud hideHud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
