//
//  Hud.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "Hud.h"
#import "AppDelegate.h"
#import "SHGProgressHUD.h"


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
    [hud hide:YES afterDelay:2.0f];

}

+ (void)showOnMainThread
{
    if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        UIViewController *topController = [nav.viewControllers lastObject];
        UIView *view = topController.view;

        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        SHGProgressHUD *progressHud = [[SHGProgressHUD alloc] initWithFrame:view.bounds];
        HUD.opacity = 0.0f;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = progressHud;
    }
}

+ (void)showGratOnMainThread
{
    if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        UIViewController *topController = [nav.viewControllers lastObject];
        UIView *view = topController.view;

        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        SHGProgressHUD *progressHud = [[SHGProgressHUD alloc] initWithFrame:view.bounds];
        progressHud.type = SHGProgressHUDTypeGray;
        HUD.opacity = 0.0f;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = progressHud;
    }
}

+ (void)showWait
{
    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showOnMainThread) withObject:nil waitUntilDone:YES];
}

+ (void)showGrayWait
{
    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showGratOnMainThread) withObject:nil waitUntilDone:YES];
}

+ (void)hideHud
{
    if ([[AppDelegate currentAppdelegate].window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
        UIViewController *topController = nav.topViewController;
        for (UIView *subView in topController.view.subviews) {
            if ([subView isKindOfClass:[MBProgressHUD class]]) {
                [((MBProgressHUD *)subView) hide:YES];
            }
        }
    }
}

@end
