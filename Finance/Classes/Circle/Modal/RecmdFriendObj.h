//
//  RecmdFriendObj.h
//  Finance
//
//  Created by lizeng on 15/8/18.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface RecmdFriendObj : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *recomfri;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *vocation;
@property (nonatomic, assign) BOOL isFocus;
@property (nonatomic, strong) NSString *commonCount;
@end
