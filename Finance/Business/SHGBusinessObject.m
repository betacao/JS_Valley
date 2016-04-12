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
    return @{@"area" : @"area", @"browseNum" : @"browsenum", @"title" : @"title", @"modifyNum" : @"modifyNum", @"businessShow" : @"businessshow", @"investAmount" : @"investamount", @"createTime" : @"createtime", @"businessId" : @"businessid", @"modifyTime" : @"modifytime"};

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
    return @{@"title":@"title",@"key":@"key",@"subArray":@"list"};
}

+ (NSValueTransformer *)subArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SHGBusinessSecondsubObject class]];
}
@end

@implementation SHGBusinessSecondsubObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"code":@"code",@"value":@"value"};
}

@end