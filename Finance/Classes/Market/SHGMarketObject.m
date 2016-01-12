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
    return @{ @"loginuserstate":@"loginuserstate",@"price":@"price",@"url":@"url",@"headimageurl":@"headimageurl",@"status":@"status", @"company":@"company", @"title":@"title",@"marketName":@"marketname",@"realname":@"realname", @"contactInfo":@"contactinfo", @"detail":@"detail", @"marketId":@"marketid", @"commentNum":@"commentnum", @"createBy":@"createby", @"praiseNum":@"praisenum", @"createTime":@"createtime", @"shareNum":@"sharenum", @"friendShip":@"friendship", @"catalog":@"catalog", @"firstcatalog":@"firstcatalog", @"secondcatalog":@"secondcatalog", @"firstcatalogid":@"firstcatalogid", @"secondcatalogid":@"secondcatalogid", @"isPraise":@"ispraise", @"position":@"position", @"praiseList":@"praiselist", @"commentList":@"commentlist"};
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
        } else if ([key isEqualToString:@"praiseNum"] || [key isEqualToString:@"commentNum"]){
            if (IsStrEmpty(value)) {
                return @"0";
            }
        }
        return value;
    }];
}

- (BOOL)isEqual:(SHGMarketObject *)object
{
    if ([self.marketId isEqualToString:object.marketId]) {
        return YES;
    } else{
        return NO;
    }
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

@implementation SHGMarketCommentObject

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
