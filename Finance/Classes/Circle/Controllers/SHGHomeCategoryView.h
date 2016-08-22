//
//  SHGHomeCategoryView.h
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGNoticeView.h"

@interface SHGHomeCategoryView : UIView

+ (instancetype)sharedCategoryView;

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) SHGNoticeView *messageNoticeView;

- (NSArray *)targetObjectsByRid:(NSString *)string;

@end
