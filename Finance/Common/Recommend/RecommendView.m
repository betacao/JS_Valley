//
//  RecommendBtn.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-12.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "RecommendView.h"
#import <QuartzCore/QuartzCore.h>

@interface RecommendView ()


@property (nonatomic, strong) UILabel *lblTitle;

@end

@implementation RecommendView

- (void)dealloc
{
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLongTagGesture];
        self.isShaking = NO;
        
        CGRect rect = self.bounds;
//        rect.size.height -= 30;
        
        UIImageView *imageVTemp = [[UIImageView alloc] initWithFrame:rect];
        imageVTemp.backgroundColor = [UIColor clearColor];
        self.imageVInfo = imageVTemp;
        UILongPressGestureRecognizer *longGestureRec = [[UILongPressGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(longGestureTaped:)];
        DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        longGestureRec.minimumPressDuration = 0.4;
        [self.imageVInfo addGestureRecognizer:longGestureRec];
        self.imageVInfo.userInteractionEnabled = YES;
        [self addSubview:_imageVInfo];
        
//        rect.origin.y = rect.size.height;
//        rect.size.height = 30;
//        UILabel *lblTemp = [[UILabel alloc] initWithFrame:rect];
//        lblTemp.textAlignment = NSTextAlignmentCenter;
//        lblTemp.backgroundColor = [UIColor clearColor];
//        lblTemp.textColor = [UIColor blackColor];
//        lblTemp.font = [UIFont systemFontOfSize:14];
//        self.lblTitle = lblTemp;
//        [lblTemp release];
//        [self addSubview:_lblTitle];
    }
    return self;
}
-(void)tap
{
    NSLog(@"tap");
}
- (void)addLongTagGesture
{
   
    

}

#pragma mark ----- Action Handler -----



- (void)longGestureTaped:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"aaaa");
    if (self.isShaking == NO) {
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            if (_delegate && [_delegate respondsToSelector:@selector(recommendBtnLongTapedWithTag:)]) {
                [_delegate recommendBtnLongTapedWithTag:self.tag];
            }
            self.isShaking = YES;
            [self beginShake];
        }
    }
    
}

//停止晃动
- (void)stopShake
{
    self.isShaking = NO;
    CALayer *viewLayer = [self layer];
    [viewLayer removeAnimationForKey:@"wiggle"];
    self.btnDelete.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopShake];
}

//开始晃动
- (void)beginShake
{
    CALayer*viewLayer=[self layer];
    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration=0.1;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses=YES;
    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                         (viewLayer.transform, -0.1, 0.1, 0.1, 0.1)];
    
    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                       (viewLayer.transform, 0.1, 0.1, 0.1, 0.1)];
    [viewLayer addAnimation:animation forKey:@"wiggle"];
    
    self.btnDelete.hidden = NO;
    [self bringSubviewToFront:self.btnDelete];
    
}

- (void)setImage:(UIImage *)image
{
    self.imageVInfo.image = image;
}

//- (void)setTitle:(NSString *)title
//{
//    self.lblTitle.text = title;
//}

- (UIButton *)btnDelete
{
    if (_btnDelete) {
        return _btnDelete;
    }
    CGRect rect = self.bounds;
    rect.origin.x = -5;
    rect.origin.y = -4;
    rect.size.width = 20;
    rect.size.height = 20;
    
    UIButton *btnBegin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBegin setFrame:rect];
    [btnBegin setBackgroundImage:[UIImage imageNamed:@"payment_btn_delete.png"] forState:UIControlStateNormal];
    self.btnDelete = btnBegin;
    [self addSubview:_btnDelete];
    self.btnDelete.hidden = YES;
    return _btnDelete;
    
}

@end
