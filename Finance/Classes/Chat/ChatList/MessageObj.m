//
//  MessageObj.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MessageObj.h"
#define contentLabelFont [UIFont systemFontOfSize:13.0f]
const CGFloat kContentWidth = 212.0f;
const CGFloat kMargin = 128.0f;



@implementation MessageObj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"title": @"title", @"content":@"content", @"time":@"time", @"code":@"code", @"oid":@"oid", @"feedHtml":@"feedhtml", @"marketId":@"marketid"};
}

- (CGFloat)heightForCell
{
    CGSize size = [self.content sizeWithSize:CGSizeMake(kContentWidth * XFACTOR, CGFLOAT_MAX) font:contentLabelFont];
    
    return size.height + kMargin;
}

@end

@implementation SHGFriendGropingObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"module": @"module",
              @"counts":@"counts"
              };
}



@end
