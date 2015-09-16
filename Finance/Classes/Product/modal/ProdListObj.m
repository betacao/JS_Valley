//
//  ProdListObj.m
//  Finance
//
//  Created by HuMin on 15/4/22.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProdListObj.h"
@implementation ProdListObj

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
              @"left1":@"character1",
              @"right1":@"character2",
              @"left2":@"character3",
              @"right2":@"character4",
              @"isHot":@"ishot",
              @"commision":@"crate",
              @"pid":@"pid",
              @"time":@"time",
              @"type":@"type",
              @"iscollected":@"iscollected"
              };
}
@end
