//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAlertWidth MarginFactor(299.0f)
#define kAlertHeight MarginFactor(197.0f)

#define kLineViewTopMargin MarginFactor(52.0f)
#define kSingleButtonWidth MarginFactor(247.0f)
#define kCoupleButtonWidth MarginFactor(117.0f)
#define kButtonHeight MarginFactor(37.0f)
#define kButtonBottomOffset MarginFactor(24.0f)
#define kLineViewLeftMargin MarginFactor(26.0f)

#define kCustomViewButtomMargin MarginFactor(24.0f)
#define kCustomViewTopMargin MarginFactor(18.0f)


@interface DXAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;
- (instancetype)initWithCustomView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;
- (void)show;
- (void)customShow;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, assign) BOOL shouldDismiss;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end