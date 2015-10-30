//
//  LinkViewController.m
//  Finance
//
//  Created by lizeng on 15/7/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LinkViewController.h"

@interface LinkViewController ()<UIWebViewDelegate>
{
    UIWebView *gameWebView;
   
    
}
@property (nonatomic,strong)NSString *stringUrl;
@end
@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"链接详情";
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
    gameWebView = [[UIWebView alloc] init];
    gameWebView.backgroundColor = [UIColor clearColor];
    gameWebView.delegate = self;
    gameWebView.scalesPageToFit= YES;
//    gameWebView.sho
//    //取消滚动条
//    for (UIView *_aView in [gameWebView subviews])
//    {
//        if ([_aView isKindOfClass:[UIScrollView class]])
//        {
//            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
//            //右侧的滚动条
//            
//            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
//            //下侧的滚动条
//            
//            for (UIView *_inScrollview in _aView.subviews)
//            {
//                if ([_inScrollview isKindOfClass:[UIImageView class]])
//                {
//                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
//                }
//            }
//        }
//    }

    NSString *Url = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.stringUrl,NULL,NULL,kCFStringEncodingUTF8));
    NSLog(@"Url%@",Url);
    NSURL *url = [NSURL URLWithString:Url];
    NSLog(@"urlurlurl%@",url);

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [gameWebView loadRequest:request];
    [self.view addSubview:gameWebView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [Hud showMessageWithText:@"数据加载中..."];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [Hud hideHud];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
