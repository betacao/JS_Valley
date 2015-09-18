//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"

#define SDPhotoGroupImageMargin 6

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@end

@implementation SDPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
//        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}


- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = idx;
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] placeholderImage:nil];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger imageCount = self.photoItemArray.count;
    NSInteger perRowImageCount = ((imageCount == 4) ? 2 : 3);
    
    CGFloat width = (CGRectGetWidth(self.frame) - 2.0f * SDPhotoGroupImageMargin) / 3.0f;
    CGFloat height = width;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        
        NSInteger rowIndex = idx / perRowImageCount;
        NSInteger columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (width + SDPhotoGroupImageMargin);
        CGFloat y = rowIndex * (height + SDPhotoGroupImageMargin);
        imageView.frame = CGRectMake(x, y, width, height);
    }];
}

- (void)didTapImageView:(UITapGestureRecognizer *)recognizer
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = recognizer.view.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return ((UIImageView *)self.subviews[index]).image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end

