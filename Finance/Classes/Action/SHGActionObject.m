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
    return @{@"headerImageUrl":@"headimageurl", @"status":@"status", @"postion":@"postion", @"department":@"department", @"company":@"company", @"realName":@"realname", @"friendShip":@"friendship", @"meetId":@"meetid", @"startTime":@"starttime", @"theme":@"theme", @"endTime":@"endtime", @"meetArea":@"meetarea", @"meetNum":@"meetnum", @"commentNum":@"commentnum", @"meetState":@"meetstate", @"publisher":@"publisher", @"attendNum":@"attendnum", @"praiseNum":@"praisenum", @"createTime":@"createtime", @"isTimeOut":@"istimeout", @"isPraise":@"ispraise", @"detail":@"detail", @"praiseList":@"praiselist", @"attendList":@"attendlist", @"commentList":@"commentlist", @"createFlag":@"createflag", @"reason":@"reason"};
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


@end

@implementation SHGActionCommentObject

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

@interface SHGActionAttendObject()

@end

@implementation SHGActionAttendObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"status":@"status",@"uid":@"uid",@"position":@"position",@"reason":@"reason",@"meetid":@"meetid",@"company":@"company",@"title":@"title",@"realname":@"realname",@"headimageurl":@"headimageurl",@"meetattendid":@"meetattendid",@"state":@"state",};
}

@end
