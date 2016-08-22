//
//  SHGComplianObject.m
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGComplianObject.h"

@implementation SHGComplianObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone",
             @"content":@"content",
             @"userID":@"userid",
             @"complainID":@"complainid",
             @"title":@"title",
             @"modifyNum":@"modifynum",
             @"isDeleted":@"isdeleted",
             @"businessType":@"businesstype",
             @"createTime":@"createtime",
             @"complainAuditstate":@"complainauditstate",
             @"urlArray":@"urllist",@"businessId":@"businessid"};
}
@end
