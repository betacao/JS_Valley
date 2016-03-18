//
//  SHGNoticeView.h
//  Finance
//
//  Created by changxicao on 15/9/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHGNoticeType)
{
    SHGNoticeTypeNewFriend = 0,
    SHGNoticeTypeNewMessage = 1
};

@interface SHGNoticeView : UIView

@property (weak, nonatomic) UIView *superView;
- (void)loadUserUid:(NSString *)uid;
- (void)showWithText:(NSString *)string;
- (instancetype)initWithFrame:(CGRect)frame type:(SHGNoticeType)type;

@end
