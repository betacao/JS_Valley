//
//  SHGActionObject.h
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, SHGActionState) {
    SHGActionStateVerying = 0,//审核中
    SHGActionStateSuccess = 1,//通过审核
    SHGActionStateFailed = 2,//驳回
    SHGActionStateOver = 3//结束
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
@property (strong, nonatomic) NSString *createFlag;
//活动属性
@property (strong, nonatomic) NSString *meetId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *meetArea;
@property (strong, nonatomic) NSString *meetNum;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *reason;//驳回原因
@property (assign, nonatomic) SHGActionState meetState;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *attendNum;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *isTimeOut;
@property (strong, nonatomic) NSString *isPraise;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSMutableArray *attendList;
@property (strong, nonatomic) NSMutableArray *praiseList;
@property (strong, nonatomic) NSMutableArray *commentList;

@end

@interface SHGActionCommentObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *commentUserId;
@property (strong, nonatomic) NSString *commentDetail;
@property (strong, nonatomic) NSString *commentUserName;
@property (strong, nonatomic) NSString *commentOtherName;

- (CGFloat)heightForCell;

@end

@interface SHGActionAttendObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSString *meetid;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *headimageurl;
@property (strong, nonatomic) NSString *meetattendid;
@property (strong, nonatomic) NSString *state;

@end
