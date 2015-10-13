//
//  SHGNoticeView.h
//  Finance
//
//  Created by changxicao on 15/9/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHGNoticeDelegate <NSObject>

@optional
- (void)didClickNoticeViewWithUid:(NSString *)uid;

@end

@interface SHGNoticeView : UIView

@property (assign, nonatomic) id<SHGNoticeDelegate> delegate;
@property (weak, nonatomic) UIView *superView;

- (void)loadUserUid:(NSString *)uid;
- (void)showWithText:(NSString *)string;

@end
