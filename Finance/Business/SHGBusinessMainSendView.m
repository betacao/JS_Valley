//
//  SHGBusinessSendMainView.m
//  Finance
//
//  Created by changxicao on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessMainSendView.h"

@implementation SHGBusinessMainSendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = [UIImage imageNamed:@""];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:backgroundView];

    backgroundView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

}

- (void)addAutoLayout
{

}
@end
