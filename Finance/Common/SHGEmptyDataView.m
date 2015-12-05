//
//  SHGEmptyDataView.m
//  Finance
//
//  Created by changxicao on 15/12/5.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGEmptyDataView.h"

@interface SHGEmptyDataView()
@property (strong, nonnull) UIImageView *imageView;
@end

@implementation SHGEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"emptyBg"];
        [self.imageView sizeToFit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint point = self.window.center;
    point = [self convertPoint:point fromView:self.window];
    self.imageView.center = point;
}


@end
