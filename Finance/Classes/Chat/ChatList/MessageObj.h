//
//  MessageObj.h
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface MessageObj : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *oid;
@property (strong, nonatomic) NSString *feedHtml;
@property (strong, nonatomic) NSString *marketId;

- (CGFloat)heightForCell;
@end


@interface SHGFriendGropingObject : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *module;
@property (nonatomic,strong) NSString *counts;

@end