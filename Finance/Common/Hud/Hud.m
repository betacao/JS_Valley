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
#import "SHGProgressHUD.h"

#define kTagWaitView 10099

@implementation Hud

+ (void)showMessageWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FontFactor(15.0f);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [label sizeToFit];

    UIView *view = [AppDelegate currentAppdelegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    [view bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = label;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0.85f;
    hud.margin = MarginFactor(18.0f);
    [hud hide:YES afterDelay:1.2];

}

+ (void)showOnMainThread
{
    UIView *view = [AppDelegate currentAppdelegate].window;
    SHGProgressHUD *hud = (SHGProgressHUD *)[view viewWithTag:kTagWaitView];
    if(!hud) {
        hud = [[SHGProgressHUD alloc] initWithFrame:view.bounds];
    }
    [hud setTag: kTagWaitView];
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
}

+ (void)showWait
{
    [self performSelectorOnMainThread:@selector(showOnMainThread) withObject:nil waitUntilDone:YES];
}

+ (void)hideHud
{
    UIView *view = [AppDelegate currentAppdelegate].window;
    SHGProgressHUD *hud = (SHGProgressHUD *)[view viewWithTag:kTagWaitView];
    if(hud) {
        [hud stopAnimation];
        [hud removeFromSuperview];
    }
}

@end
