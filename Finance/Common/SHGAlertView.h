//
//  SHGAlertView.h
//  Finance
//
//  Created by changxicao on 16/5/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle;
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle;
- (instancetype)initWithCustomView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle;

- (void)addSubTitle:(NSString *)subTitle;
- (void)show;
- (void)showWithClose;

@property (copy, nonatomic) dispatch_block_t leftBlock;
@property (copy, nonatomic) dispatch_block_t rightBlock;
@property (copy, nonatomic) dispatch_block_t dismissBlock;

@property (assign, nonatomic) BOOL shouldDismiss;
@property (assign, nonatomic) BOOL touchOtherDismiss;//点击黑色区域是否也消失

@end


@interface SHGBusinessContactAlertView : SHGAlertView

@property (strong, nonatomic) NSAttributedString *text;

- (instancetype)initWithLeftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle;

@end