//
//  BasePeopleObject.h
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasePeopleObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *simpleDescription;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *updateTime;
// 0为关注 1为粉丝 2为互相关注
@property (nonatomic, assign) NSInteger followRelation;

//@property (nonatomic, strong) NSString *userStatus;
@property (nonatomic, strong) NSString *userstatus;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *rela;

@property (nonatomic, strong) NSString *commonfriend;
@property (nonatomic, strong) NSString *commonfriendnum;
@property (nonatomic, strong) NSString *poststring;
@property (nonatomic, strong) NSString *position;  //职位
@end
