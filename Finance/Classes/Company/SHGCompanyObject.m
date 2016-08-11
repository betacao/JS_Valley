//
//  SHGCompanyObject.m
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCompanyObject.h"

@implementation SHGCompanyObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"companyName":@"companyname",
             @"companyID":@"cid"};
}

@end
