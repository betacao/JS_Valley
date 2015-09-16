//
//  BasePopupView.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-17.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "BasePopupView.h"

@implementation BasePopupView

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *)type name:(NSString *)name
{
    if (isController) {
        CGRect rectScreen = [[UIScreen mainScreen] bounds];
        rectScreen = [self getNoneNaviViewFrame:rectScreen];
        self = [super initWithFrame:rectScreen];
        
    }else {
        self = [super initWithFrame:superFrame];
    }
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController
{
    if (isController) {
        CGRect rectScreen = [[UIScreen mainScreen] bounds];
        rectScreen = [self getNoneNaviViewFrame:rectScreen];
        self = [super initWithFrame:rectScreen];
        
    }else {
        self = [super initWithFrame:superFrame];
    }
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
 
    }
    return self;
}
-(CGRect)getNoneNaviViewFrame:(CGRect)rect
{
    rect.origin.y = 20;
    rect.size.height -= 20;
    return rect;
}

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *)type
{
    if (isController) {
        CGRect rectScreen = [[UIScreen mainScreen] bounds];
        rectScreen = [self getNoneNaviViewFrame:rectScreen];
        self = [super initWithFrame:rectScreen];
        
    }else {
        self = [super initWithFrame:superFrame];
    }
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController defaultDate:(NSString *) defaultDate
{
    if (isController) {
        CGRect rectScreen = [[UIScreen mainScreen] bounds];
        rectScreen = [self getNoneNaviViewFrame:rectScreen];
        self = [super initWithFrame:rectScreen];
        
    }else {
        self = [super initWithFrame:superFrame];
    }
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
    }
    return self;
}

- (void)showWithAnimated:(BOOL)animated
{
    if (animated) {
        self.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            self.viewContainer.transform = CGAffineTransformMakeTranslation(0, -(CGRectGetHeight(self.viewContainer.bounds)+(CGRectGetHeight(self.bounds)-CGRectGetHeight(self.viewContainer.bounds))/2));
            
        } completion:^(BOOL finished){
            
        }];
        
    }else {
        self.hidden = NO;
    }
}

- (void)hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.viewContainer.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished){
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
        
    }else {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}



@end
