//
//  CircleListObj.m
//  Finance
//
//  Created by HuMin on 15/4/15.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListObj.h"
#import "SHGGloble.h"
#import "MLEmojiLabel.h"

@interface CircleListObj()

@end

@implementation CircleListObj

- (id)init
{
    self = [super init];
    if (self) {
        self.isPull = NO;
    }
    return self;
}

- (NSMutableArray*)heads
{
    if (!_heads) {
        _heads = [NSMutableArray array];
    }
    return _heads;
}

-(NSMutableArray *)comments
{
    if (!_comments)
    {
        _comments = [NSMutableArray array];
    }
    return _comments;
    
}

- (NSArray *)photoArr
{
    if (!_photoArr)
    {
        _photoArr = [NSArray array];
    }
    return _photoArr;
    
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"businesstotal": @"businesstotal",@"realname": @"realname",@"position": @"position",@"picname": @"picname",@"phone": @"phone",@"companyname": @"companyname",@"cmmtnum": @"cmmtnum", @"nickname":@"nickname", @"comments": @"comments", @"company": @"company", @"detail": @"detail", @"isAttention": @"isattention", @"potname": @"potname", @"praisenum": @"praisenum", @"publishdate": @"publishdate", @"rid": @"rid", @"photos":@"attach", @"sharenum": @"sharenum", @"status": @"status", @"title": @"title", @"userid": @"userid", @"ispraise":@"ispraise", @"type":@"attachtype", @"linkObj":@"link", @"postType":@"type", @"friendship":@"friendship", @"userstatus":@"userstatus", @"currcity":@"currcity", @"feedhtml":@"feedhtml", @"displayposition":@"displayposition", @"pcurl":@"pcurl", @"shareTitle":@"sharetitle"};
}


+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[commentOBj class]];
}

+ (NSValueTransformer *)linkObjJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[linkOBj class]];
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

@implementation linkOBj

- (id)init
{
    self = [super init];
    if (self) {
        self.thumbnail = @"1";
    }
    return self;
}
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"title":@"title", @"desc":@"desc", @"link":@"link", @"thumbnail":@"thumbnail"};
}


@end
