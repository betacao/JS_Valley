//
//  SHGActionObject.h
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, SHGActionState) {
    SHGActionStateVerying = 1,//审核中
    SHGActionStateSuccess = 2,//通过审核
    SHGActionStateFailed = 3,//驳回
    SHGActionStateOver = 4//结束
};

@interface SHGActionObject : MTLModel<MTLJSONSerializing>

//人员属性
@property (strong, nonatomic) NSString *headerImageUrl;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *postion;
@property (strong, nonatomic) NSString *friendShip;
//活动属性
@property (strong, nonatomic) NSString *meetId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *meetArea;
@property (strong, nonatomic) NSString *meetNum;
@property (strong, nonatomic) NSString *commentNum;
@property (assign, nonatomic) SHGActionState meetState;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *attendNum;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *isTimeOut;
@property (strong, nonatomic) NSString *isPraise;
@property (strong, nonatomic) NSString *introduce;
@end
