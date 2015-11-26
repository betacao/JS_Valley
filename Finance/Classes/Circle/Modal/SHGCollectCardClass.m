//
//  SHGCollectCardClass.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGCollectCardClass.h"

@implementation SHGCollectCardClass
-(id )init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{
              @"name":@"name",
              @"headerImageUrl":@"head_img",
              @"companyName":@"companyname",
              @"position":@"position",
              @"tags":@"tags",
              @"titles":@"titles",
              @"time":@"time",
              @"friendShip":@"friendship",
              @"collectTime":@"collecttime",
              @"uid":@"uid",
              };
}

@end
