//
//  SHGNoticeView.m
//  Finance
//
//  Created by changxicao on 15/9/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGNoticeView.h"
#import "UIButton+EnlargeEdge.h"

#define kNoticeFriendViewHeight 30.0f * XFACTOR
#define kCloseButtonMargin 25.0f
#define kCloseButtonEnlargeEdge 20.0f
#define kNoticeMessageViewHeight 25.0f * XFACTOR
#define kNoticeLeftMargin 14.0f

@interface SHGNoticeView()

@property (strong, nonatomic) UILabel *noticeLabel;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) NSString *uid;
@property (assign, nonatomic) SHGNoticeType noticeType;

@end


@implementation SHGNoticeView

- (instancetype)initWithFrame:(CGRect)frame type:(SHGNoticeType)type
{

    self = [super initWithFrame:CGRectZero];
    if(self){
        switch (type) {
            case SHGNoticeTypeNewFriend:
            {
                self.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH, kNoticeFriendViewHeight);
            }
                break;
                
            default:
            {
                self.frame = CGRectMake(kNoticeLeftMargin, 0.0f, SCREENWIDTH - 2 * kNoticeLeftMargin, kNoticeMessageViewHeight);
                self.layer.masksToBounds = YES;
                self.layer.cornerRadius = 3.0f;
                self.noticeType = type;
            }
                break;
        }
        self.clipsToBounds = YES;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    }
    return self;
}

- (UILabel *)noticeLabel
{
    if(!_noticeLabel){
        _noticeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _noticeLabel.textColor = [UIColor whiteColor];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.font = [UIFont systemFontOfSize:14.0f];
        _noticeLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);
        _noticeLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    }
    return _noticeLabel;
}

- (UIButton *)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setEnlargeEdge:kCloseButtonEnlargeEdge];
        [_closeButton setImage:[UIImage imageNamed:@"noticeClose"] forState:UIControlStateNormal];
        [_closeButton sizeToFit];
        CGRect frame = _closeButton.frame;
        frame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) / 2.0f;
        frame.origin.x = SCREENWIDTH - kCloseButtonMargin * XFACTOR;
        _closeButton.frame = frame;
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        if(self.noticeType == SHGNoticeTypeNewMessage){
            _closeButton.hidden = YES;
        }
    }
    return _closeButton;
}


- (UIView *)bgView
{
    if(!_bgView){
        CGRect frame = self.bounds;
        frame.origin.y = -CGRectGetHeight(frame);
        _bgView = [[UIView alloc] initWithFrame:frame];
        [_bgView addSubview:self.noticeLabel];
        [_bgView addSubview:self.closeButton];
        [self addSubview:_bgView];
    }
    return _bgView;
    
}

- (void)showWithText:(NSString *)string
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(self.noticeType == SHGNoticeTypeNewMessage){
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
    }
    self.noticeLabel.text = string;
    [self.superView addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.bounds;
        frame.origin.y = 0.0f;
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.bounds;
        frame.origin.y = -CGRectGetHeight(frame);
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)loadUserUid:(NSString *)uid
{
    self.uid = uid;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickNoticeViewWithUid:)]){
        [self hide];
        [self.delegate didClickNoticeViewWithUid:self.uid];
    }
}

@end
