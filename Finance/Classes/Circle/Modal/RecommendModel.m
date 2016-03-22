//
//  RecommendModel.m
//  Finance
//
//  Created by zhuaijun on 15/8/17.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel
-(instancetype)init
{
    self =[super init];
    if (self){
        
    }
    return  self;
}
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"flag":@"flag", @"username":@"username", @"phone":@"phone", @"area":@"area", @"company":@"company", @"uid":@"uid", @"headImg":@"headImg"};
}
@end
