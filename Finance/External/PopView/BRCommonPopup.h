//
//  BRCommonPopup.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-13.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BRCommonPopupDirectionFromTop,
    BRCommonPopupDirectionFromButton,
    BRCommonPopupDirectionFromLeft,
    BRCommonPopupDirectionFromRight,
} BRCommonPopupDirection;

typedef enum : NSUInteger {
    BRCommonPopupArrowNone,
    BRCommonPopupArrowLeft,
    BRCommonPopupArrowMiddle,
    BRCommonPopupArrowRight,
} BRCommonPopupArrow;

@class BRCommonPopup;

@protocol BRCommonPopupDelegate <NSObject>

@optional
- (void)commonPopupDidDismiss:(BRCommonPopup *)owner;

@end

@interface BRCommonPopup : UIView

@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, assign) BRCommonPopupDirection popupDirection;
@property (nonatomic, assign) BRCommonPopupArrow popupArrow;
@property (nonatomic, assign) BOOL isDropdown;//下拉形式
@property (nonatomic, weak) id<BRCommonPopupDelegate> delegate;

- (id)initWithSuperFrame:(CGRect)superFrame isController:(BOOL)isController;

- (void)reloadDatas;
- (void)showWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;

@end