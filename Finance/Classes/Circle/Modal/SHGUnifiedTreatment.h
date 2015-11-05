//
//  SHGUnifiedTreatment.h
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//  统一处理首页的关注，分享 点赞和评论

#import <Foundation/Foundation.h>
#import "CircleListDelegate.h"

@interface SHGUnifiedTreatment : NSObject<CircleListDelegate,CircleActionDelegate>

+ (instancetype)sharedTreatment;

@end
