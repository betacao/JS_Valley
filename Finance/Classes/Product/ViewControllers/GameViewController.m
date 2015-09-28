//
//  GameViewController.m
//  Finance
//
//  Created by lizeng on 15/6/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "GameViewController.h"
@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void) sendMusicContent ;
- (void) sendVideoContent ;
- (void) changeScene:(NSInteger)scene;
@end
@interface GameViewController ()<UIActionSheetDelegate,WXApiDelegate,sendMsgToWeChatViewDelegate>
{
    enum WXScene _scene;
    UIWebView *myWebView;
    UIButton *rightButton;
   
}

@property (strong, nonatomic) NSString *currentURL;
@property (strong, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) NSString *currentHTML;
@property (assign, nonatomic) BOOL  hasRequestData;

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;
@end

@implementation GameViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    NSLog(@"上一页面的url%@",self.url);
    self.hasRequestData = NO;
    [self creatUI];
    rightButton.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    if(!self.hasRequestData){
        self.hasRequestData = YES;
        [self loadURL];
    }
}
-(void)loadURL{
    myWebView = [[UIWebView alloc]init];
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.delegate = self;
    myWebView.scalesPageToFit= YES;
    //取消滚动条
    for (UIView *_aView in [myWebView subviews])
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
        myWebView.frame = CGRectMake(0, 0, 320, 480-64);
    }
    //5/5s
    else if(size_screen.width==320.000000 && size_screen.height == 568.000000 )
    {
        myWebView.frame = CGRectMake(0, 0, 320, 568-64);
        
    }
    //6
    else if(size_screen.width==375.000000 )
    {
        myWebView.frame = CGRectMake(0, 0, 375, 667-64);
        
    }
    //6p
    else if(size_screen.width==414.000000 )
    {
        myWebView.frame = CGRectMake(0, 0, 414, 736-64);
    }

    NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    myWebView.delegate = self;
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [Hud showMessageWithText:@"数据加载中..."];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSInteger width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth;"] intValue];
    CGRect rect = webView.frame;
    rect.size.width = width;
}
#pragma mark -- sdc
#pragma mark -- 获取当前页面的url
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    self.currentTitle =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    
    self.currentURL = webView.request.URL.absoluteString;
    NSLog(@"title-%@--url-%@--",self.currentTitle,self.currentURL);
    
    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    self.currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
    
    if ([self.currentURL rangeOfString:@"game2"].location != NSNotFound) {
        
        NSLog(@"这个字符串中有game2");
        rightButton.hidden = YES;
        
    }else if ([self.currentURL rangeOfString:@"rank"].location != NSNotFound){
        NSLog(@"这个字符串中有rank");
        rightButton.hidden = NO;
    }
    [Hud hideHud];
}

#pragma mark -- sdc
#pragma mark -- 微信分享
- (void)creatUI{
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectZero];
    //[rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton setTitleColor:RGB(255, 0, 40) forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"11@2x.png"] forState :UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightItemShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)rightItemShare:(id)sender{
    //    NSLog(@"%@",self.currentURL);
    UIActionSheet *acSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到朋友圈",@"分享到微信好友", nil];
    acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [acSheet showInView:[[UIApplication sharedApplication]keyWindow]];
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self sendFriednCirlcleContent];
        [_delegate changeScene:WXSceneTimeline];
    }else if (buttonIndex == 1){
        [self sendFriendContent];
        [_delegate changeScene:WXSceneSession];
    }else{
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        
    }
}

-(void) onResp:(BaseResp*)resp
{
    //可以省略
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
    }
}


#pragma mark -- 朋友圈

- (void)sendFriednCirlcleContent
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @" 在本次股神大战中，我击败了91.3%的股神！不服来战！";
        message.description = @"参加炒股大赛，和死工资说goodbye；与牛人共舞，来大牛圈炒股。玩我们的游戏，用我们的资金，赚的不用你给，亏的不要你赔，100万操盘金保准你玩到high！";
        [message setThumbImage:[UIImage imageNamed:@"80.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"www.daniuq.com/weixin/html5/pages/share.html";
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        [alView show];
    }
}
#pragma mark -- 好友
- (void)sendFriendContent
{
    //    if (_delegate)
    //    {
    //        [_delegate sendVideoContent] ;
    //    }
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @" 在本次股神大战中，我击败了91.3%的股神！不服来战！";
        message.description = @"参加炒股大赛，和死工资说goodbye；与牛人共舞，来大牛圈炒股。玩我们的游戏，用我们的资金，赚的不用你给，亏的不要你赔，100万操盘金保准你玩到high！";
        [message setThumbImage:[UIImage imageNamed:@"80.png"]];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"www.daniuq.com/weixin/html5/pages/share.html";
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        [alView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
    }
}
-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _scene = WXSceneSession;
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
