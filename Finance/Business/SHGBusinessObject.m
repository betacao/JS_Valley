//
//  SHGBusinessObject.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessObject.h"

@implementation SHGBusinessObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
@end

@implementation SHGBusinessFirstObject

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end

@implementation SHGBusinessSecondObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}
@end