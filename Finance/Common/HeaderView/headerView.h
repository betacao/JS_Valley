//
//  headerView.h
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerView : UIView

- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage;

- (void)updateStatus:(BOOL)status;
@end
