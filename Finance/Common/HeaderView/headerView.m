//
//  headerView.m
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "headerView.h"
#import "UIKit+AFNetworking.h"

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
    
    self.headerImageView = [[UIImageView alloc] init];
    [self addSubview:self.headerImageView];
    
    self.headerImageView.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f);
    
    
    self.VImageView = [[UIImageView alloc] init];
    self.VImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.VImageView.image = [UIImage imageNamed:@"V"];
    [self.VImageView sizeToFit];
    [self addSubview:self.VImageView];
    
    self.VImageView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.VImageView.center = self.VImageView.center = CGPointMake(CGRectGetMaxX(bounds) - 2.0f, CGRectGetMaxY(bounds) - 2.0f);
}


- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage
{
    self.headerImageView.image = placeImage;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sourceUrl]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.headerImageView setImageWithURLRequest:request placeholderImage:placeImage success:nil failure:nil];
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
