//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAlertWidth 250.0f * XFACTOR
#define kAlertHeight 167.0f * XFACTOR

#define kLineViewTopMargin 44.0f * XFACTOR
#define kSingleButtonWidth 155.0f * XFACTOR
#define kCoupleButtonWidth 99.0f * XFACTOR
#define kButtonHeight 32.0f * XFACTOR
#define kButtonBottomOffset 20.0f * XFACTOR
#define kLineViewLeftMargin 20.0f * XFACTOR
#define kCustomViewButtomMargin 18.0f * YFACTOR

@interface DXAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;

- (void)show;
- (void)customShow;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end