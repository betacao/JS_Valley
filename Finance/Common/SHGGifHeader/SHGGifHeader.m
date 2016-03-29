//
//  SHGGifHeader.m
//  Finance
//
//  Created by changxicao on 16/3/29.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGifHeader.h"
#import "SHGProgressHUD.h"

@interface SHGGifHeader ()

@property (strong, nonatomic) SHGProgressHUD *progressHud;

@end

@implementation SHGGifHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];

    // 设置控件的高度
    self.mj_h = MJRefreshHeaderHeight;
    self.progressHud = [[SHGProgressHUD alloc] init];
    self.progressHud.shouldAutoMediate = NO;
    [self addSubview:self.progressHud];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];

}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self.progressHud stopAnimation];
            break;
        case MJRefreshStatePulling:
            [self.progressHud startAnimation];
            break;
        case MJRefreshStateRefreshing:
            [self.progressHud startAnimation];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
