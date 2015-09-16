//
//  ClickGes.m
//  Finance
//
//  Created by HuMin on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ClickGes.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ClickGes

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    self.curTickleStart = [touch locationInView:self.view];
    for (id views in self.action) {
        if ([views isKindOfClass:[UIView class] ]) {
            UIView *view = (UIView *)views;
            view.backgroundColor = RGB(242, 242, 242);
            [self performSelector:@selector(clearWithView:) withObject:nil afterDelay:1.5];
        }
    }

    
}

-(void)clearWithView:(UIView *)view
{
    view.backgroundColor = [UIColor clearColor];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id views in self.action) {
        if ([views isKindOfClass:[UIView class] ]) {
            UIView *view = (UIView *)views;
            view.backgroundColor = [UIColor clearColor];
        }
    }
    [self reset];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id views in self.action) {
        if ([views isKindOfClass:[UIView class] ]) {
            UIView *view = (UIView *)views;
            view.backgroundColor = [UIColor clearColor];
        }
    }
    [self reset];
}
-(NSArray *)action
{
    if (!_action) {
        _action = [NSArray array];
    }
    return _action;
}

@end
