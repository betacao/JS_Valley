//
//  SHGDiscoveryObject.m
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryObject.h"

@implementation SHGDiscoveryObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"industryNum":@"industrynum", @"industryName":@"industryname", @"industryImage":@"industry"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"industryImageName"]) {
            if ([value containsString:@""]) {
                
            }
        }
        return value;
    }];
}
@end
