//
//  BRCommonPopup.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-13.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "BRCommonPopup.h"

@interface BRCommonPopup ()

@property (nonatomic, assign) CGRect rectViewContainer;

@end

@implementation BRCommonPopup

- (void)dealloc
{
    _viewContainer = nil;
}

- (id)initWithSuperFrame:(CGRect)superFrame isController:(BOOL)isController
{
    if (isController) {//
        CGRect rectScreen = [[UIScreen mainScreen] bounds];
        rectScreen = [self getNoneNaviViewFrame:rectScreen];
        self = [super initWithFrame:rectScreen];
        
    }else {
        self = [super initWithFrame:superFrame];
    }
    
    if (self) {//
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.clipsToBounds = YES;
        self.popupDirection = BRCommonPopupDirectionFromTop;
        self.popupArrow = BRCommonPopupArrowNone;
//        [self initBackgroudView];
        
    }
    return self;
}
-(CGRect)getNoneNaviViewFrame:(CGRect)rect
{
    rect.origin.y = 20;
    rect.size.height -= 20;
    return rect;
}
- (void)initBackgroudView
{
    UIView *viewBg = [[UIView alloc] initWithFrame:self.bounds];
    viewBg.alpha = 0;
    viewBg.backgroundColor = [UIColor blackColor];
    [self addSubview:viewBg];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.viewContainer.frame, point)) {
        
        [self hideWithAnimated:YES];
    }
}

- (void)setViewContainer:(UIView *)viewContainer
{
    if (_viewContainer != viewContainer) {
        _viewContainer = viewContainer;
        //保存位置信息
        self.rectViewContainer = _viewContainer.frame;
        [self addSubview:_viewContainer];
    }

}

- (void)showWithAnimated:(BOOL)animated
{
    UIImage *image = nil;
    if (self.popupArrow == BRCommonPopupArrowLeft) {
        image = [UIImage imageNamed:@"common_line_arrow_left.png"];
    }else if (self.popupArrow == BRCommonPopupArrowMiddle) {
        image = [UIImage imageNamed:@"common_line_arrow_middle.png"];
    }else if (self.popupArrow == BRCommonPopupArrowRight) {
        image = [UIImage imageNamed:@"common_line_arrow_right@2x.png"];//
    }
    
    if (self.popupArrow != BRCommonPopupArrowNone) {
        CGRect rectArrow = self.rectViewContainer;//
        
        rectArrow.origin.y -= 6;
        rectArrow.size.height = 6;
        UIImageView *imageVArrow = [[UIImageView alloc] initWithFrame:rectArrow];
        imageVArrow.image = image;
        [self addSubview:imageVArrow];
    }
    
    if (animated) {
        
        if (self.isDropdown) {
            CGRect rectOrigin = self.viewContainer.frame;//
            
            rectOrigin.size.height = 0;
            self.viewContainer.frame = rectOrigin;
        }else {
            CGRect rectOrigin = self.viewContainer.frame;
            if (self.popupDirection == BRCommonPopupDirectionFromTop) {
                rectOrigin.origin.y = -rectOrigin.size.height;
            }else if (self.popupDirection == BRCommonPopupDirectionFromButton) {
                rectOrigin.origin.y = CGRectGetHeight(self.bounds);
            }else if (self.popupDirection == BRCommonPopupDirectionFromLeft) {
                rectOrigin.origin.x = -CGRectGetWidth(self.bounds);
            }else if (self.popupDirection == BRCommonPopupDirectionFromRight) {
                rectOrigin.origin.x = CGRectGetWidth(self.bounds);
            }
            self.viewContainer.frame = rectOrigin;
        }
    
        self.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.viewContainer.frame = self.rectViewContainer;
            
        } completion:^(BOOL finished){
            
        }];
        
    }else {
        self.hidden = NO;
    }
}

- (void)hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.isDropdown) {
                CGRect rectOrigin = self.viewContainer.frame;
                rectOrigin.size.height = 0;
                self.viewContainer.frame = rectOrigin;
            }else{
                CGRect rectOrigin = self.viewContainer.frame;
                if (self.popupDirection == BRCommonPopupDirectionFromTop) {
                    rectOrigin.origin.y = -rectOrigin.size.height;
                }else if (self.popupDirection == BRCommonPopupDirectionFromButton) {
                    rectOrigin.origin.y = CGRectGetHeight(self.bounds);
                }else if (self.popupDirection == BRCommonPopupDirectionFromLeft) {
                    rectOrigin.origin.x = -CGRectGetWidth(self.bounds);
                }else if (self.popupDirection == BRCommonPopupDirectionFromRight) {
                    rectOrigin.origin.x = CGRectGetWidth(self.bounds);
                }
                self.viewContainer.frame = rectOrigin;
            }
            
        } completion:^(BOOL finished){
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
        
    }else {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
    if (_delegate &&
        [_delegate respondsToSelector:@selector(commonPopupDidDismiss:)]) {
        [_delegate commonPopupDidDismiss:self];
    }
    
}

- (void)reloadDatas
{
}

@end
