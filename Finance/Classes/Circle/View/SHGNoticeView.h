//
//  SHGNoticeView.h
//  Finance
//
//  Created by changxicao on 15/9/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGNoticeView : UIView

@property (weak, nonatomic) UIView *superView;

- (void)showWithText:(NSString *)string;

@end
