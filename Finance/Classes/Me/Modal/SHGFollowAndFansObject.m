//
//  SHGFollowAndFansObject.m
//  Finance
//
//  Created by weiqiankun on 16/6/1.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGFollowAndFansObject.h"

@implementation SHGFollowAndFansObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name":@"nickname",@"headImageUrl":@"head_img",@"uid":@"uid",@"updateTime":@"time",@"followRelation":@"state",@"userstatus":@"userstatus"};
}

@end
