//
//  LinkViewController.m
//  Finance
//
//  Created by lizeng on 15/7/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LinkViewController.h"
#import "SHGUnifiedTreatment.h"

@interface LinkViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSString *stringUrl;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.linkTitle.length > 0) {
        self.title = self.linkTitle;
    } else{
       self.title = @"详情"; 
    }
    
    if ([self.url hasPrefix:@"http://"] || [self.url hasPrefix:@"https://"]){
        NSLog(@"1");
        self.stringUrl  = self.url;
    }
    [self loadURL];
}

- (void)loadURL
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT - kNavigationBarHeight - kStatusBarHeight)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit= YES;

    NSString *Url = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.stringUrl,NULL,NULL,kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:Url];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [Hud showMessageWithText:@"数据加载中..."];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Hud hideHud];
    [SHGGloble addHtmlListener:webView key:@"openShare" block:^{
        [[SHGUnifiedTreatment sharedTreatment] shareFeedhtmlString:self.object];
    }];
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
