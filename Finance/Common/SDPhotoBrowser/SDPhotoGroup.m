//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"

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
        NSString *url = obj.thumbnail_pic;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = idx;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView addGestureRecognizer:recognizer];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_image"]];
        [self addSubview:imageView];
    }];
    [self makeupSubViews];
}

- (void)makeupSubViews
{
    NSInteger imageCount = self.photoItemArray.count;
    NSInteger perRowImageCount = ((imageCount == 4) ? 2 : 3);

    CGFloat width = ceilf((SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELL_PHOTO_SEP * 2.0f) / 3.0f);
    CGFloat height = width;
    __block CGFloat totalHeight = 0.0f;
    if(self.subviews.count > 1){
        [self.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
            NSInteger rowIndex = idx / perRowImageCount;
            NSInteger columnIndex = idx % perRowImageCount;
            CGFloat x = columnIndex * (width + CELL_PHOTO_SEP);
            CGFloat y = rowIndex * (height + CELL_PHOTO_SEP);
            imageView.frame = CGRectMake(x, y, width, height);
            totalHeight = CGRectGetMaxY(imageView.frame);
        }];
    } else if(self.subviews.count == 1){
        UIImageView *imageView = (UIImageView *)[self.subviews firstObject];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(0.0f, 0.0f, 2 * width + CELL_PHOTO_SEP, 2 * height + CELL_PHOTO_SEP);
        totalHeight = 2 * width + CELL_PHOTO_SEP;
    }

    self.frame = CGRectMake(0.0f, 0.0f, SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin, totalHeight);
    
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)recognizer
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoItemArray.count;
    browser.currentImageIndex = recognizer.view.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.photoItemArray[index] thumbnail_pic];
    return [NSURL URLWithString:urlStr];
}

- (void)photoBrowser:(SDPhotoBrowser *)browser didSlideAtIndex:(NSInteger)index
{
}
@end
