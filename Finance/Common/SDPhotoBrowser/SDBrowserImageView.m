//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBrowserImageView.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowserConfig.h"

@interface SDBrowserImageView ()
@property (assign, nonatomic) BOOL didCheckSize;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIImageView *scrollImageView;
@property (assign, nonatomic) CGFloat height;

@end

@implementation SDBrowserImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.height = 0.0f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height =  self.height == 0.0f ? self.image.size.height : self.height;
    if (self.image.size.height > self.bounds.size.height) {
        if (!self.scroll) {
            self.scroll = [[UIScrollView alloc] init];
            self.scroll.frame = self.bounds;
            self.scroll.backgroundColor = [UIColor whiteColor];
            
            self.scrollImageView = [[UIImageView alloc] init];
            self.scrollImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.scrollImageView .image = self.image;
            self.height = ceilf(self.image.size.height * CGRectGetWidth(self.scroll.bounds) / self.image.size.width);
            CGFloat orgin_Y = self.height > CGRectGetHeight(self.frame) ? 0.0f : (SCREENHEIGHT - self.height) / 2.0f;
            self.scrollImageView.frame = CGRectMake(0, orgin_Y, CGRectGetWidth(self.scroll.bounds), self.height);
            self.scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
            
            [self.scroll addSubview:self.scrollImageView];
            [self addSubview:self.scroll];
        }
    }
    
    self.scroll.contentSize = CGSizeMake(0, self.height);
}



- (void)setProgress:(CGFloat)progress
{
    self.progress = progress;

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    
    __weak SDBrowserImageView *imageViewWeak = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [imageViewWeak removeWaitingView];
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        }
   
    }];
}

// 清除缩放
- (void)eliminateScale
{
}

- (void)removeWaitingView
{
    
}


@end
