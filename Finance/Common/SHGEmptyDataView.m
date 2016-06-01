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

@end

@implementation SHGEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.type = SHGEmptyDateNormal;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setType:(SHGEmptyDateType)type
{
    _type = type;
    self.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
    switch (type) {
        case SHGEmptyDateNormal:
            self.imageView.image = [UIImage imageNamed:@"emptyBg"];
            [self.imageView sizeToFit];
            break;
        case SHGEmptyDateMarketDeleted:
            self.imageView.image = [UIImage imageNamed:@"deleted_market"];
            [self.imageView sizeToFit];
            break;
        case SHGEmptyDateBusinessDeleted:
            self.imageView.image = [UIImage imageNamed:@"deleted_market"];
            [self.imageView sizeToFit];
            break;
        case SHGEmptyDateDiscoverySearch:
            self.backgroundColor = [UIColor whiteColor];
            self.imageView.image = [UIImage imageNamed:@"discovery_search_none"];
            self.imageView.sd_layout
            .centerXEqualToView(self)
            .topSpaceToView(self, MarginFactor(65.0f))
            .widthIs(self.imageView.image.size.width)
            .heightIs(self.imageView.image.size.height);
            break;
        default:
            break;
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.type == SHGEmptyDateNormal ||self.type == SHGEmptyDateMarketDeleted||self.type == SHGEmptyDateBusinessDeleted) {
        CGPoint point = self.window.center;
        point = [self convertPoint:point fromView:self.window];
        self.imageView.center = point;
    }
}


@end
