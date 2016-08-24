//
//  UIView+HUD.h
//  OMNI
//
//  Created by changxicao on 16/5/16.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "UIView+HUD.h"
#import "NSObject+Extend.h"
#import "SHGProgressHUD.h"

@implementation UIView (HUD)

- (void)showLoading
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showOnMainThread) withObject:nil waitUntilDone:YES];
}

- (void)showOnMainThread
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    SHGProgressHUD *progressHud = [[SHGProgressHUD alloc] initWithFrame:self.bounds];
    HUD.opacity = 0.0f;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = progressHud;
    HUD.removeFromSuperViewOnHide = YES;
    [self bringSubviewToFront:HUD];
}


- (void)showWithText:(NSString *)text
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(showTextOnMainThread:enable:duration:) withObjects:@[text, @(YES), @(2.0f)] waitUntilDone:YES];
}

- (void)showWithText:(NSString *)text enable:(BOOL)enable duration:(NSTimeInterval)duration
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];

    [self performSelectorOnMainThread:@selector(showTextOnMainThread:enable:duration:) withObjects:@[text, @(enable) ,@(0.0f)] waitUntilDone:YES];
}

- (void)showTextOnMainThread:(NSString *)text enable:(NSNumber *)enable duration:(NSNumber *)duration
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FontFactor(15.0f);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [label sizeToFit];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = label;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0.85f;
    hud.margin = MarginFactor(18.0f);
    hud.userInteractionEnabled = [enable boolValue];
    if ([duration floatValue] > 0.0f) {
        [hud hide:YES afterDelay:[duration floatValue]];
    }
}

- (void)hideHudOnMainThread
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subView) hide:YES];
        }
    }
}

- (void)hideHud
{
    [self performSelectorOnMainThread:@selector(hideHudOnMainThread) withObject:nil waitUntilDone:YES];
}

- (void)removeAllSubviews
{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
