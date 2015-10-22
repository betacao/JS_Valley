//
//  SHGNavigationView.m
//  Finance
//
//  Created by changxicao on 15/10/21.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGNavigationView.h"

@implementation SHGNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}

@end
