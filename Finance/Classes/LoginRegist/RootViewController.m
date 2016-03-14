//
//  RootViewController.m
//  Finance
//
//  Created by HuMin on 15/5/12.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RootViewController.h"
#import "CCLocationManager.h"
#import "ApplyViewController.h"
#import "LoginViewController.h"
#import "ImproveMatiralViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImage;
@property (strong, nonatomic) NSString *isFull;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (assign, nonatomic) CMTime totalTime;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(SCREENHEIGHT < 568.000000){
        self.launchImage.image = [UIImage imageNamed:@"480"];
    } else if(SCREENHEIGHT == 568.000000){
        self.launchImage.image = [UIImage imageNamed:@"568"];
    } else if(SCREENHEIGHT == 667.000000){
        self.launchImage.image = [UIImage imageNamed:@"667"];
    } else if(SCREENHEIGHT > 667.000000){
        self.launchImage.image=[UIImage imageNamed:@"736"];
    }
    if([[SHGGloble sharedGloble] isShowGuideView]){
        [self startPlayVideo];
    } else{
        [self moveToHomePage];
    }
}

- (void)moveToHomePage
{
    NSString *flagStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTOLOGIN];
    BOOL flag = NO;
    if (!IsStrEmpty(flagStr)){
        flag = [flagStr boolValue];
    }
    if (flag) {
        [self autoLogin];
    }else{
        [self showLoginViewController];
    }
}

- (void)startPlayVideo
{
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"15skaiji.mp4" ofType:nil];
    //如果存在视频则直接播放
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        [self playVideo:videoPath];
    }
}


- (void)playVideo:(NSString *)localPath
{
    NSURL *videoUrl = [NSURL fileURLWithPath:localPath];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    //添加跳过按钮
    UIButton *skipVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"skip_video"];
    [skipVideoButton setBackgroundImage:image forState:UIControlStateNormal];

    [skipVideoButton sizeToFit];
    CGSize size = skipVideoButton.frame.size;
    skipVideoButton.frame = CGRectMake(SCREENWIDTH - 1.5f * size.width, 0.5 * size.height, size.width, size.height);
    [skipVideoButton addTarget:self action:@selector(clickSkipVideo:) forControlEvents:UIControlEventTouchUpInside];

    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT);

    [playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:0 context:nil];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view.layer addSublayer:playerLayer];
        [weakSelf.view addSubview:skipVideoButton];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];


}


//当播放器的播放状态发生变化时的通知
- (void)moviePlayDidEnd:(NSNotification *)notif
{
    [self moveToHomePage];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    __weak typeof(self) weakSelf = self;
    if ([keyPath isEqualToString:@"readyForDisplay"]) {
        AVPlayerLayer* layer = (AVPlayerLayer*) object;
        if (layer.readyForDisplay) {
            [layer removeObserver:weakSelf forKeyPath:@"readyForDisplay"];

            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [layer.player play];
                weakSelf.totalTime = weakSelf.playerItem.duration;
                //去掉最上面的的遮罩
                [weakSelf.launchImage removeFromSuperview];
            });
        }
    }
}

- (void)clickSkipVideo:(UIButton *)button
{
    [self.player pause];
    [self moveToHomePage];
    self.player = nil;
    self.playerItem = nil;
}

- (void)showLoginViewController
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [AppDelegate currentAppdelegate].window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
}

- (void)autoLogin
{
    NSString *key_Uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *key_Token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    if(IsStrEmpty(key_Uid) || IsStrEmpty(key_Token)){
        [self showLoginViewController];
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = @{@"uid":key_Uid,@"t":key_Token};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"login",@"auto"] class:nil parameters:param success:^(MOCHTTPResponse *response){
        NSString *code =[response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            NSString *uid = response.dataDictionary[@"uid"];
            NSString *token = response.dataDictionary[@"token"];
            NSString *state = response.dataDictionary[@"state"];
            NSString *name = response.dataDictionary[@"name"];
            NSString *head_img = response.dataDictionary[@"head_img"];
            NSString *area = response.dataDictionary[@"area"];

            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
            [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTOLOGIN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *isfull = response.dataDictionary[@"isfull"];
            weakSelf.isFull = isfull;
            if ([weakSelf.isFull isEqualToString:@"1"]){
                [weakSelf chatLoagin];
                [weakSelf loginSuccess];
            } else{
                [weakSelf showLoginViewController];
            }
        }
    }failed:^(MOCHTTPResponse *response){
        [Hud showMessageWithText:response.errorMessage];
        [AppDelegate currentAppdelegate].window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }];
}

#ifdef __IPHONE_7_0
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#endif
- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error)
    {
         if (loginInfo && !error)
         {
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
             //发送自动登陆状态通知
             //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             //将旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error)
             {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             [[ApplyViewController shareController] loadDataSourceFromLocalDB];
             
         }else
         {
             switch (error.errorCode)
             {
                 case EMErrorServerNotReachable:
                     NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     NSLog(@"%@",[NSString stringWithFormat:@"%@", error.description]);
                     break;
                 case EMErrorServerTimeout:
                     NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     //	TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                     break;
             }
         }
     } onQueue:nil];
}
#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BaseNavigationController *nav = nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess)
    {//登陆成功加载主窗口控制器
    } else{
        //登陆失败加载登陆页面控制器
        LoginViewController *loginController = [[LoginViewController alloc] init];
        nav = [[BaseNavigationController alloc] initWithRootViewController:loginController];
        loginController.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
    }
    
    [AppDelegate currentAppdelegate].window.rootViewController = nav;
    
    [nav setNavigationBarHidden:YES];
    [nav setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
#pragma mark - Navigation
*/
-(void)loginSuccess
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AppDelegate currentAppdelegate] moveToRootController:weakSelf.rid];
    });

}

@end
