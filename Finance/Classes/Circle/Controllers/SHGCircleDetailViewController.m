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
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.26.114.154:8080/jinrong/feed/20160629113026.html"]]];
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
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height  =  webViewHeight;
    webView.frame = newFrame;
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
