//
//  GameObj.m
//  Finance
//
//  Created by lizeng on 15/6/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "GameObj.h"

@implementation GameObj
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"imageurl":@"imageurl",
             @"name":@"name",
             @"url":@"url"};
}
@end
