//
//  LinkViewController.m
//  Finance
//
//  Created by lizeng on 15/7/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LinkViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>  
#import "SHGUnifiedTreatment.h"

@interface LinkViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSString *stringUrl;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    NSLog(@"%@",self.url);
    if ([self.url hasPrefix:@"http://"]){
        NSLog(@"1");
        self.stringUrl  = self.url;
    } else{
        self.stringUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.url];
        NSLog(@"2");
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
    [self addHtmlListener];
    [Hud hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (void)addHtmlListener
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"openShare"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        [[SHGUnifiedTreatment sharedTreatment] shareFeedhtmlString:self.object];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
