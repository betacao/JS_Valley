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
    return @{@"industryNum":@"industrynum", @"industryName":@"industryname", @"industryImage":@"industry", @"industry":@"industry"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"industryImage"]) {
            NSString *imageName = [NSString stringWithFormat:@"discovery_%@", value];
            UIImage *image = [UIImage imageNamed:imageName];
            return image;
        }
        return value;
    }];
}

- (BOOL)isEqual:(SHGDiscoveryObject *)object
{
    if ([self.industryName isEqualToString:object.industryName]) {
        return YES;
    }
    return NO;
}
@end


@implementation SHGDiscoveryIndustryObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"module":@"module", @"counts":@"counts", @"moduleName":@"modulename"};
}

@end


@implementation SHGDiscoveryPeopleObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone", @"area":@"area", @"status":@"status", @"userID":@"id", @"title":@"title", @"company":@"company", @"headImg":@"headimg", @"isAttention":@"isattention", @"realName":@"realname", @"industry":@"industry", @"hideAttation":@"isattention"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"status"]) {
            if ([value isEqualToString:@"0"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        if ([key isEqualToString:@"isAttention"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        if ([key isEqualToString:@"hideAttation"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }

        return value;
    }];
}
@end



@implementation SHGDiscoveryInvateObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone", @"realName":@"realname"};
}

@end


@implementation SHGDiscoveryDepartmentObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone", @"realName":@"realname", @"userID":@"id", @"position":@"position", @"title":@"title", @"headImg":@"headimg", @"company":@"company", @"friendTypeImage":@"friendtype", @"commonFriendCount":@"commonfriendcount", @"commonFriend":@"commonfriend", @"userStatus":@"userstatus", @"area":@"area", @"isAttention":@"isattention", @"hideAttation":@"isattention"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"userStatus"]) {
            if ([value isEqualToString:@"0"]) {
                return @(NO);
            }
            return @(YES);
        }
        if ([key isEqualToString:@"friendTypeImage"]) {
            if ([value isEqualToString:@"first"]) {
                return [UIImage imageNamed:@"discovery_first"];
            }
            return [UIImage imageNamed:@"discovery_second"];
        }
        if ([key isEqualToString:@"isAttention"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        if ([key isEqualToString:@"hideAttation"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        return value;
    }];
}

@end

@implementation SHGDiscoveryRecommendObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"phone":@"phone", @"realName":@"realname", @"userID":@"userid", @"position":@"position", @"title":@"title", @"picName":@"picname", @"companyName":@"companyname", @"isAttention":@"isattention", @"userStatus":@"userstatus", @"hideAttation":@"isattention"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"userStatus"]) {
            if ([value isEqualToString:@"0"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        if ([key isEqualToString:@"isAttention"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }
        if ([key isEqualToString:@"hideAttation"]) {
            if ([value isEqualToString:@"false"]) {
                return @(NO);
            } else {
                return @(YES);
            }
        }

        return value;
    }];
}
@end




