//
//  CircleListObj.m
//  Finance
//
//  Created by HuMin on 15/4/15.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListObj.h"
#import "SHGGloble.h"

@interface CircleListObj()

@end

@implementation CircleListObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heads = [NSMutableArray array];
        self.comments = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"cmmtnum": @"cmmtnum", @"nickname":@"nickname", @"comments": @"comments", @"company": @"company", @"detail": @"detail", @"isAttention": @"isattention", @"potname": @"potname", @"praisenum": @"praisenum", @"publishdate": @"publishdate", @"rid": @"rid", @"photos":@"attach", @"sharenum": @"sharenum", @"status": @"status", @"title": @"title", @"userid": @"userid", @"ispraise":@"ispraise", @"type":@"attachtype", @"postType":@"type", @"friendship":@"friendship", @"userstatus":@"userstatus", @"currcity":@"currcity", @"feedhtml":@"feedhtml", @"displayposition":@"displayposition", @"pcurl":@"pcurl", @"shareTitle":@"sharetitle", @"businessStatus":@"businessstatus", @"groupPostTitle":@"groupposttitle", @"businessID":@"businessid"};
}


+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[commentOBj class]];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"isAttention"]) {
            if ([value isEqualToString:@"Y"]) {
                return @(YES);
            } else {
                return @(NO);
            }
        }

        return value;
    }];
}

@end

@implementation commentOBj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"cdetail":@"cdetail", @"cid":@"cid", @"cnickname":@"cnickname",@"rid":@"rid" ,@"replyid":@"replyid", @"rnickname":@"rnickname"};
}

@end

@implementation praiseOBj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{

    return @{@"pnickname":@"pnickname", @"puserid":@"puserid", @"ppotname":@"ppotname"};
}

@end

@implementation photoObj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"photos":@"photos"};
}

@end
