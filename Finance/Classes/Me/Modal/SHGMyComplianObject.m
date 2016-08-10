//
//  SHGMyComplianObject.m
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyComplianObject.h"

@implementation SHGMyComplianObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone",@"content":@"content",@"userid":@"userid",@"complainid":@"complainid",@"title":@"title",@"modifynum":@"modifynum",@"isdeleted":@"isdeleted",@"businesstype":@"businesstype",@"createtime":@"createtime",@"complainauditstate":@"complainauditstate",@"urlArray":@"urllist"};
}
@end
