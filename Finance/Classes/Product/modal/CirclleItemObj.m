//
//  CirclleItemObj.m
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CirclleItemObj.h"

@implementation CirclleItemObj

-(id)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"tname":@"tname",
             @"tcode":@"tcode",
             @"timg":@"timg"};
}

@end
