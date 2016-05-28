//
//  MessageObj.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MessageObj.h"



@implementation MessageObj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"title": @"title", @"content":@"content", @"time":@"time", @"code":@"code", @"oid":@"oid", @"feedHtml":@"feedhtml", @"unionID":@"unionid"};
}

@end

@implementation SHGFriendGropingObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return  @{@"module": @"module", @"counts":@"counts"};
}



@end
