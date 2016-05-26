//
//  SHGUserHeaderView.m
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGUserHeaderView.h"
#import "UIKit+AFNetworking.h"
#import "SHGPersonalViewController.h"

@interface SHGUserHeaderView ()
@property (strong, nonatomic) UIImageView *VImageView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) NSString *userId;

@end

@implementation SHGUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.headerImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.headerImageView];

        self.headerImageView.sd_layout
        .topSpaceToView(self, 0.0f)
        .leftSpaceToView(self, 0.0f)
        .bottomSpaceToView(self, 0.0f)
        .rightSpaceToView(self, 0.0f);

        self.VImageView = [[UIImageView alloc] init];
        self.VImageView.image = [UIImage imageNamed:@"V"];
        [self.VImageView sizeToFit];
        [self addSubview:self.VImageView];

        self.VImageView.hidden = YES;

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderView)];
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (void)awakeFromNib
{
    
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_head"]];
    [self addSubview:self.headerImageView];
    
    self.headerImageView.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f);
    
    
    self.VImageView = [[UIImageView alloc] init];
    self.VImageView.image = [UIImage imageNamed:@"V"];
    [self.VImageView sizeToFit];
    [self addSubview:self.VImageView];
    
    self.VImageView.hidden = YES;

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderView)];
    [self addGestureRecognizer:recognizer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.VImageView.center = self.VImageView.center = CGPointMake(CGRectGetMaxX(bounds) - 2.0f, CGRectGetMaxY(bounds) - 2.0f);
}


- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage status:(BOOL)status userID:(NSString *)userId
{
    if(status){
        self.VImageView.hidden = NO;
    } else{
        self.VImageView.hidden = YES;
    }
    self.userId = userId;
    self.headerImageView.image = placeImage;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sourceUrl]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.headerImageView setImageWithURLRequest:request placeholderImage:placeImage success:nil failure:nil];
}


- (void)tapUserHeaderView
{
    if (self.userId) {
        [[SHGGloble sharedGloble] recordUserAction:self.userId type:@"personalDynamic_index"];
        SHGPersonalViewController *personController = [[SHGPersonalViewController alloc] init];
        personController.userId = self.userId;
        UIViewController *controller = [[SHGGloble sharedGloble] getCurrentRootViewController];
        [self pushIntoViewController:controller newViewController:personController];
    }
}

- (void)pushIntoViewController:(UIViewController*)viewController newViewController:(UIViewController*)newController
{
    UINavigationController *navs;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        navs = (UINavigationController *)viewController;
        if (navs.visibleViewController.navigationController){
            [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
        }
    }else if ([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)viewController;
        navs = (UINavigationController *)tab.selectedViewController;
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
        }
    }else{
        navs = viewController.navigationController;
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
        }
    }
}

@end
