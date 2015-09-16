//
//  RecommendBtn.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-12.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecommendBtnDelegate <NSObject>

- (void)recommendBtnLongTapedWithTag:(NSInteger)tag;

@end

@interface RecommendView : UIView

@property (nonatomic, weak) id<RecommendBtnDelegate> delegate;
//button 状态
@property (nonatomic, assign) BOOL isShaking;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) UIImageView *imageVInfo;
//@property (nonatomic, retain) NSString  *title;

//停止晃动
- (void)stopShake;
//开始晃动
- (void)beginShake;


@end
