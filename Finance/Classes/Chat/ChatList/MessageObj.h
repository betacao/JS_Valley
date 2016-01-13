//
//  MessageObj.h
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface MessageObj : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *oid;
@property (strong, nonatomic) NSString *feedHtml;

- (CGFloat)heightForCell;
@end


@interface SHGFriendGropingObject : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *module;
@property (nonatomic,strong) NSString *counts;

@end