//
//  SHGGuideView.m
//  Finance
//
//  Created by changxicao on 16/5/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGuideView.h"

@interface SHGGuideView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation SHGGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;

        NSString *imageName = [NSString stringWithFormat:@"guide%ld", (long)SCREENHEIGHT];
        self.imageArray = @[[UIImage imageNamed:[imageName stringByAppendingString:@"_1"]], [UIImage imageNamed:[imageName stringByAppendingString:@"_2"]], [UIImage imageNamed:[imageName stringByAppendingString:@"_3"]]];
        [self addSubview:self.scrollView];

        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageControl_unselect"]];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageControl_select"]];
        self.pageControl.numberOfPages = self.imageArray.count;
        [self addSubview:self.pageControl];
        [self addAutoLayout];
    }
    return self;
}

- (void)addAutoLayout
{
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:i]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        imageView.sd_layout
        .leftSpaceToView(self.scrollView, SCREENWIDTH * i)
        .bottomSpaceToView(self.scrollView, 0.0f)
        .widthIs(SCREENWIDTH)
        .heightRatioToView(self.scrollView, 1.0f);
    }
    UIImageView *imageView = [self.scrollView.subviews lastObject];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"guideButton"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"guideButton"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
    button.sd_layout
    .centerXEqualToView(imageView)
    .bottomSpaceToView(imageView, 0.0f)
    .widthIs(button.currentImage.size.width)
    .heightIs(button.currentImage.size.height);

    self.scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    [self.scrollView setupAutoContentSizeWithRightView:imageView rightMargin:0.0f];

    self.pageControl.sd_layout
    .centerXEqualToView(self)
    .bottomSpaceToView(self, MarginFactor(20.0f))
    .widthIs(SCREENWIDTH)
    .heightIs(MarginFactor(20.0f));
}

- (void)buttonClick:(UIButton *)button
{
    if (self.block) {
        self.block();
    }
}

- (void)didMoveToSuperview
{
    if (self.superview) {
        self.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
}


@end
