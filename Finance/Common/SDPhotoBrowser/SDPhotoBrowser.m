//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "SDBrowserImageView.h"
 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"
#import <AssetsLibrary/AssetsLibrary.h>

//  =============================================

@interface SDPhotoBrowser ()<UIActionSheetDelegate>

@property (strong ,nonatomic) UIScrollView *scrollView;
@property (strong ,nonatomic) UILabel *indexLabel;
@property (assign ,nonatomic) BOOL hasShowedFistView;

@end

@implementation SDPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        [self setupScrollView];
        [self setupToolbars];
    }
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake(self.bounds.size.width - 100, self.bounds.size.height - 50, 80, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    self.indexLabel = indexLabel;
    [self addSubview:indexLabel];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longSaveImage:)];
    [self addGestureRecognizer:longPress];
}


- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        UIScrollView *inserScrollView = [[UIScrollView alloc] init];
        inserScrollView.delegate = self;
        inserScrollView.maximumZoomScale = 2.0f;
        inserScrollView.minimumZoomScale = 1.0f;
        inserScrollView.showsHorizontalScrollIndicator = NO;
        inserScrollView.showsVerticalScrollIndicator = NO;
        inserScrollView.decelerationRate = 0.2f;
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        [inserScrollView addSubview:imageView];
        [self.scrollView addSubview:inserScrollView];
        [self setupImageOfImageViewForIndex:i];
    }

    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = [[[self.scrollView.subviews objectAtIndex:index]subviews] objectAtIndex:0];
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView yy_setImageWithURL:[self highQualityImageURLForIndex:index] placeholder:nil];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    __block CGRect frame = self.frame;
    frame.origin.y =  CGRectGetHeight(frame);
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    self.scrollView.bounds = rect;
    self.scrollView.center = self.center;
    
    CGFloat y = SDPhotoBrowserImageViewMargin;
    CGFloat w = self.scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = self.scrollView.frame.size.height - SDPhotoBrowserImageViewMargin * 2;

    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIScrollView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
        UIView *view = [[obj subviews] firstObject];
        view.frame = CGRectMake(0, 0, w, h);
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.subviews.count * self.scrollView.frame.size.width, 0);
    self.scrollView.contentOffset = CGPointMake(self.currentImageIndex * self.scrollView.frame.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    
    if (!self.hasShowedFistView) {
        [self showFirstImage];
    }
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)showFirstImage
{
    __block CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(frame);
    self.frame = frame;
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        frame.origin.y = 0.0f;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        self.hasShowedFistView = YES;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual:self.scrollView]){
        int index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
        NSString *text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
        if(![text isEqualToString:self.indexLabel.text]){
            NSInteger page = [[self.indexLabel.text substringToIndex:[self.indexLabel.text rangeOfString:@"/"].location] integerValue] - 1;
            UIScrollView *insertScrollView = [[scrollView subviews] objectAtIndex:page];
            [insertScrollView setZoomScale:1.0f];
            self.indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
            if(self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:didSlideAtIndex:)]){
                [self.delegate photoBrowser:self didSlideAtIndex:index];
                self.currentImageIndex = index;
            }
        }
    } else{
        
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView subviews][0];
    return view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *view = [self viewForZoomingInScrollView:scrollView];
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    view.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}


- (void)longSaveImage:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            NSString *tips = @"请在iPhone的“设置->隐私->照片”选项中\n允许本App访问你的相册。";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"can't save", nil) message:tips delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        } else {
            
            int index = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
            UIImageView *currentImageView = self.scrollView.subviews[index];
            // 如果取不到image，遍历一次subviews寻找
            if (![currentImageView respondsToSelector:@selector(image)]) {
                for (UIImageView *aView in currentImageView.subviews) {
                    if ([aView respondsToSelector:@selector(image)]) {
                        currentImageView = aView;
                        break;
                    }
                }
            }

            // 这里再一次判断是否
            if ([currentImageView respondsToSelector:@selector(image)]) {
//                [self showWait];
                UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            } else {
                // 取不到图片，不保存
            }
        }
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error){
        [Hud showMessageWithText:@"保存成功"];
    } else {
        [Hud showMessageWithText:@"保存失败"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.5);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Hud hideHud];
        });
    });
}

@end
