//
//  headerView.m
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "headerView.h"

@interface headerView ()
@property (strong, nonatomic) UIImageView *VImageView;
@property (strong, nonatomic) UIImageView *headerImageView;

@end

@implementation headerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.headerImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.headerImageView];
        
        self.VImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.VImageView.image = [UIImage imageNamed:@""];
        [self.VImageView sizeToFit];
        self.VImageView.center = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
        [self addSubview:self.VImageView];
        self.VImageView.hidden = YES;
        
    }
    return self;
}

- (void)awakeFromNib
{
    CGRect frame = self.bounds;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:self.headerImageView];
    self.VImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.VImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.VImageView.image = [UIImage imageNamed:@"V"];
    [self.VImageView sizeToFit];
    self.VImageView.center = CGPointMake(CGRectGetMaxX(frame) - 2.0f, CGRectGetMaxY(frame) - 2.0f);
    [self addSubview:self.VImageView];
    self.VImageView.hidden = YES;
}


- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage
{
    self.headerImageView.image = placeImage;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:sourceUrl] placeholderImage:placeImage options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
    }];
}

- (void)updateStatus:(BOOL)status
{
    if(status){
        self.VImageView.hidden = NO;
    } else{
        self.VImageView.hidden = YES;
    }
//    self.VImageView.hidden = NO;
}

//- (void)setn

@end
