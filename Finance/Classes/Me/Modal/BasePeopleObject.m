//
//  BasePeopleObject.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BasePeopleObject.h"

@implementation BasePeopleObject

@end


@implementation SHGPeopleObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name":@"nick", @"nickname":@"nickname", @"headImageUrl":@"avatar", @"uid":@"username", @"userstatus":@"userstatus", @"company":@"company", @"position":@"position", @"rela":@"rela", @"commonfriend":@"commonfriend", @"commonfriendnum":@"commonfriendnum"};
}

@end