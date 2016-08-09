//
//  SHGUserHeaderView.h
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGUserHeaderView : UIView

@property (strong, nonatomic) UIImage *image;

- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage userID:(NSString *)userId;

@end
