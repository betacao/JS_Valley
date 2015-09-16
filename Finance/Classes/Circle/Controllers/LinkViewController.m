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
   
    
    if ([self.url hasPrefix:@"http://"])
    {
        NSLog(@"1");
        self.stringUrl  = self.url;
    }else{
        self.stringUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.url];
        NSLog(@"2");
    }
    
     [self loadURL];
}
- (void)loadURL
{
    gameWebView = [[UIWebView alloc]init];
    //myWebView.scrollView.clipsToBounds = NO;
    gameWebView.backgroundColor = [UIColor clearColor];
    gameWebView.delegate = self;
    //myWebView.autoresizesSubviews = YES;
    gameWebView.scalesPageToFit= YES;
    
    //    myWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    //    myWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //取消滚动条
    for (UIView *_aView in [gameWebView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    //对屏幕进行适配
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    NSLog(@"size_screen:宽度%f---高度%f",size_screen.width,size_screen.height);
    //1.2.3.4/4s
    if(size_screen.width==320.000000 && size_screen.height == 480.000000)
    {
        gameWebView.frame = CGRectMake(0, 0, 320, 480+130);
    }
    //5/5s
    else if(size_screen.width==320.000000 && size_screen.height == 568.000000 )
    {
        gameWebView.frame = CGRectMake(0, 0, 320, 568+30);
        
    }
    //6
    else if(size_screen.width==375.000000 )
    {
        gameWebView.frame = CGRectMake(0, 0, 375, 667-65);
        
    }
    //6p
    else if(size_screen.width==414.000000 )
    {
        gameWebView.frame = CGRectMake(0, 0, 414, 700);
    }
    
    NSString *Url = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.stringUrl,NULL,NULL,kCFStringEncodingUTF8));
    NSLog(@"Url%@",Url);
    NSURL *url = [NSURL URLWithString:Url];
    NSLog(@"urlurlurl%@",url);
    //[[UIApplication sharedApplication]openURL:url];
//    [Hud showMessageWithText:@"数据加载中..."];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        NSData *data =[NSData dataWithContentsOfURL:url];
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            [gameWebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
//        });
//    });
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
