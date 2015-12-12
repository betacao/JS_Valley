//
//  SHGMarketObject.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketObject.h"

@implementation SHGMarketObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"firstCatalogId":@"firstcatalogid", @"firstCatalogName":@"firstcatalogname", @"secondCatalogId":@"secondcatalogid", @"secondCatalogName":@"secondcatalogname", @"price":@"price", @"marketName":@"marketname", @"contactInfo":@"contactinfo", @"detail":@"detail", @"marketId":@"marketid"};
}
@end


@implementation SHGMarketFirstCategoryObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"firstCatalogId":@"firstcatalogid", @"firstCatalogName":@"firstcatalogname", @"secondCataLogs":@"secondcatalogs"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"secondCataLogs"] && [value isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)value;
            array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:array class:[SHGMarketSecondCategoryObject class]];
            return array;
        }
        return value;
    }];
}

@end

@implementation SHGMarketSecondCategoryObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"parentId":@"parentid", @"rowId":@"rowid", @"catalogName":@"catalogname"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end