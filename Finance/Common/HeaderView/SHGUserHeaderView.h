//
//  SHGUserHeaderView.h
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGUserHeaderView : UIView

- (void)updateHeaderView:(NSString *)sourceUrl placeholderImage:(UIImage *)placeImage status:(BOOL)status userID:(NSString *)userId;

@end
