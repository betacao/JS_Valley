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

    return @{@"isRefresh" : @"isrefresh", @"browseNum" : @"browsenum", @"modifyNum" : @"modifyNum", @"businessShow" : @"businessshow",@"createTime" : @"createtime", @"businessID" : @"businessid", @"modifyTime" : @"modifytime", @"anonymous" : @"anonymous",@"type":@"type",@"area":@"area",@"bondType":@"bondtype",@"clarifyingWay":@"clarifyingway",@"contact":@"contact",@"detail":@"detail", @"fundUsetime":@"fundusetime", @"highestRate":@"highestrate",@"industry":@"industry",@"investAmount":@"investamount", @"investModel":@"investmodel", @"title":@"title", @"uid":@"uid", @"photo":@"photo",@"businessType":@"businesstype",@"clarifyingRequire":@"clarifyingrequire",@"lowestPaybackRate":@"lowestpaybackrate",@"financingStage":@"financingstage",@"fundSource":@"fundsource",@"moneysideType":@"moneysidetype",@"totalshareRate":@"totalsharerate",@"vestYears":@"vestyears", @"userState":@"loginuserstate", @"middleContent":@"middlecontent", @"isDeleted":@"isdeleted", @"isCollection":@"iscollected", @"createBy":@"createby", @"commentList":@"commentlist", @"realName":@"realname", @"company":@"company", @"status":@"status", @"headImageUrl":@"headimageurl", @"url":@"url", @"businessTitle":@"businesstitle"};
    
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([key isEqualToString:@"isCollection"]) {
            if ([value isEqualToString:@"true"]) {
                return @(YES);
            } else{
                return @(NO);
            }
        } else if ([key isEqualToString:@"userState"]) {
            if ([value isEqualToString:@"1"]) {
                return @(YES);
            } else{
                return @(NO);
            }
        }
        return value;
    }];
}

+ (NSValueTransformer *)commentListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SHGBusinessCommentObject class]];
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

@implementation SHGBusinessCommentObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"commentId":@"rid", @"commentUserId":@"cid", @"commentDetail":@"cdetail", @"commentUserName":@"cnickname", @"commentOtherName":@"rnickname"};
}

- (CGFloat)heightForCell
{

    UIFont *font = [UIFont systemFontOfSize:14.0f];
    NSString *text = @"";
    if (IsStrEmpty(self.commentOtherName))
    {
        text = [NSString stringWithFormat:@"%@:x%@",self.commentUserName,self.commentDetail];
    } else{
        text = [NSString stringWithFormat:@"%@回复%@:x%@",self.commentUserName, self.commentOtherName, self.commentDetail];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = [UIFont systemFontOfSize:14.0f];
    replyLabel.attributedText = string;
    CGSize size = [replyLabel sizeThatFits:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, MAXFLOAT)];
    NSLog(@"%f",size.height);
    CGFloat height = size.height;
    return height;
}

@end