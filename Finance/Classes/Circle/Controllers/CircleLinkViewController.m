//
//  CircleLinkViewController.m
//  Finance
//
//  Created by HuMin on 15/5/11.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleLinkViewController.h"

@interface CircleLinkViewController ()
@property (strong, nonatomic) UIWebView *webViewForCUD;

@end

@implementation CircleLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
   _webViewForCUD = [[ UIWebView alloc] initWithFrame: CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT)];
    [_webViewForCUD setUserInteractionEnabled:YES];
    _webViewForCUD.delegate = self;
    
    [self.view addSubview:_webViewForCUD];
    [_webViewForCUD loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link] ]];
    // Do any additional setup after loading the view from its nib.
}
-(void)btnBackClick:(id)sender
{
    [Hud hideHud];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    [Hud showWait];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    [Hud hideHud];
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    [Hud hideHud];

    NSLog(@"DidFailLoadWithError");
    
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
