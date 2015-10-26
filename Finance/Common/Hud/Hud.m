//
//  Hud.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "Hud.h"
#import "AppDelegate.h"
#import "VerifyIdentityViewController.h"
@implementation Hud

+(void)showNoAuthMessage
{
    UIView *view = [AppDelegate currentAppdelegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"您还未认证，请先身份认证";
    hud.color = [UIColor whiteColor];
    hud.size = CGSizeMake(SCREENWIDTH - 40, 80);
    // hud.frame =
    hud.margin = 10.f;
    hud.backgroundColor = RGBA(200, 200, 200,0.6);
    hud.yOffset = -50;
    hud.labelFont = [UIFont systemFontOfSize:16.0f];
   // hud.dimBackground = YES;
    hud.labelColor = TEXT_COLOR;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(SCREENWIDTH - 40,80);
    [hud hide:YES afterDelay:1.2];
 
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
}
+(void)delayMethod
{
    VerifyIdentityViewController *vc = [[VerifyIdentityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    [nav pushViewController:vc animated:YES];
}

+(void)showMessageWithText:(NSString *)text
{
    UIView *view = [AppDelegate currentAppdelegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.yOffset = -50;

    [view bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.2];
}

+ (void)showMessageWithLongText:(NSString *)text
{
    UIView *view = [AppDelegate currentAppdelegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.yOffset = -50;
    
    [view bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud adjustFontToWidth];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.2];
}

+(void)showLoadingWithMessage:(NSString *)message{
    
    BOOL hasShow = NO;
    UIView *superView = [AppDelegate currentAppdelegate].window;
    
    for (UIView *subView in superView.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            hasShow = YES;
        }
    }
    if (!hasShow) {
        if ([NSThread currentThread].isMainThread)
        {
       
            if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
                UIViewController *topView = [nav.viewControllers lastObject];
                MBProgressHUD  *HUD = [[MBProgressHUD alloc] initWithView:topView.view];
                HUD.yOffset = -50;

                [topView.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = message;
                // [HUD showWhileExecuting:selector onTarget:target withObject:nil animated:YES];
                [HUD show:YES];
            }
         
            
        }else{
            [self performSelectorOnMainThread:@selector(showHudWithMessage:) withObject:message waitUntilDone:YES];
        }
        
    }
    
 
}
-(void)showHudWithMessage:(NSString *)message
{
    if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        UIViewController *topView = [nav.viewControllers lastObject];
        MBProgressHUD  *HUD = [[MBProgressHUD alloc] initWithView:topView.view];
        HUD.yOffset = -50;

        [topView.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = message;
        // [HUD showWhileExecuting:selector onTarget:target withObject:nil animated:YES];
        [HUD show:YES];
    }
}
+(void)hideHud
{
    if ([NSThread currentThread].isMainThread) {
        [self hidesHud];
        
    }else{
        [self performSelectorOnMainThread:@selector(hidesHud)
                               withObject:nil
                            waitUntilDone:NO];
    }
}
+ (void)hidesHud
{
    if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        UIViewController *topView = [nav.viewControllers lastObject];
        for (UIView *subView in topView.view.subviews) {
            if ([subView isKindOfClass:[MBProgressHUD class]]) {
                [subView removeFromSuperview];
            }
        }
        
        
    }
   
}

@end
