//
//  SHGActionObject.m
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionObject.h"

@implementation SHGActionObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"headerImageUrl":@"headimageurl", @"status":@"status", @"postion":@"postion", @"department":@"department", @"company":@"company", @"realName":@"realname", @"friendShip":@"friendship", @"meetId":@"meetid", @"startTime":@"starttime", @"theme":@"theme", @"endTime":@"endtime", @"meetArea":@"meetarea", @"meetNum":@"meetnum", @"commentNum":@"commentnum", @"meetState":@"meetstate", @"publisher":@"publisher", @"attendNum":@"attendnum", @"praiseNum":@"praisenum", @"createTime":@"createtime", @"isTimeOut":@"istimeout", @"isPraise":@"ispraise", @"detail":@"detail", @"praiseList":@"praiselist", @"attendList":@"attendlist", @"commentList":@"commentlist", @"createFlag":@"createflag"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"isPraise"]) {
            if ([value isEqualToString:@"true"]) {
                return @"Y";
            } else{
                return @"N";
            }
        }
        return value;
    }];
}


@end

@implementation SHGActionCommentObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"commentId":@"rid", @"commentUserId":@"cid", @"commentDetail":@"cdetail", @"commentUserName":@"cnickname", @"commentOtherName":@"rnickname"};
}
@end
