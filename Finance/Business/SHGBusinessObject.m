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

    return @{ @"browseNum" : @"browsenum", @"modifyNum" : @"modifyNum", @"businessShow" : @"businessshow",@"createTime" : @"createtime", @"businessID" : @"businessid", @"modifyTime" : @"modifytime", @"anonymous" : @"anonymous",@"type":@"type",@"area":@"area",@"bondType":@"bondtype",@"clarifyingWay":@"clarifyingway",@"contact":@"contact",@"detail":@"detail", @"fundUsetime":@"fundusetime", @"highestRate":@"highestrate",@"industry":@"industry",@"investAmount":@"investamount", @"investModel":@"investmodel", @"title":@"title", @"uid":@"uid", @"photo":@"photo",@"businessType":@"businesstype",@"clarifyingRequire":@"clarifyingrequire",@"lowestPaybackRate":@"lowestpaybackrate",@"financingStage":@"financingstage",@"fundSource":@"fundsource",@"moneysideType":@"moneysidetype",@"totalshareRate":@"totalsharerate",@"vestYears":@"vestyears"};
    
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

@implementation SHGBusinessNoticeObject



@end