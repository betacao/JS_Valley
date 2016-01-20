//
//  SHGEmptyDataView.m
//  Finance
//
//  Created by changxicao on 15/12/5.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGEmptyDataView.h"
#define kImageViewTopMargin 80.0f * XFACTOR
#define kActionButtonFrame CGRectMake(kObjectMargin, CGRectGetMaxY(self.imageView.frame) + kImageViewTopMargin, SCREENWIDTH - 2 * kObjectMargin, 35.0f)

@interface SHGEmptyDataView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *actionButton;
@end

@implementation SHGEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
        self.imageView = [[UIImageView alloc] init];
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.type = SHGEmptyDateTypeNormal;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setType:(SHGEmptyDateType)type
{
    _type = type;
    switch (type) {
        case SHGEmptyDateTypeNormal:
            self.actionButton.hidden = YES;
            self.imageView.image = [UIImage imageNamed:@"emptyBg"];
            [self.imageView sizeToFit];
            break;
        case SHGEmptyDateTypeMarketDeleted:
            self.actionButton.hidden = YES;
            self.imageView.image = [UIImage imageNamed:@"deleted_market"];
            [self.imageView sizeToFit];
            break;
        case SHGEmptyDateTypeMarketEmptyRecommended:
            self.actionButton.hidden = NO ;
            self.imageView.image = [UIImage imageNamed:@"market_emptyUser"];
            [self.imageView sizeToFit];
            [self.actionButton setTitle:@"立即创建" forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ee4341"]] forState:UIControlStateNormal];
            [self addSubview:self.actionButton];
            [self setNeedsLayout];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.type == SHGEmptyDateTypeMarketEmptyRecommended) {
        self.imageView.origin = CGPointMake((SCREENWIDTH - CGRectGetWidth(self.imageView.frame)) / 2.0f, kImageViewTopMargin);
        self.actionButton.frame = kActionButtonFrame;
        return;
    } else{
        CGPoint point = self.window.center;
        point = [self convertPoint:point fromView:self.window];
        self.imageView.center = point;
    }
}


@end
