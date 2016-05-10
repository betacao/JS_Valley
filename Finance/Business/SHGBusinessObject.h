//
//  SHGBusinessObject.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGBusinessObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *browseNum;
@property (strong, nonatomic) NSString *modifyNum;
@property (strong, nonatomic) NSString *businessShow;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *businessID;
@property (strong, nonatomic) NSString *modifyTime;
@property (assign, nonatomic) NSString * isRefresh;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *anonymous;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *bondType;
@property (strong, nonatomic) NSString *clarifyingWay;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *fundUsetime;
@property (strong, nonatomic) NSString *highestRate;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *investAmount;
@property (strong, nonatomic) NSString *investModel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *photo;
//资金方
@property (strong, nonatomic) NSString *businessType;
@property (strong, nonatomic) NSString *clarifyingRequire;
@property (strong, nonatomic) NSString *lowestPaybackRate;
@property (strong, nonatomic) NSString *financingStage;
@property (strong, nonatomic) NSString *fundSource;
@property (strong, nonatomic) NSString *moneysideType;
@property (strong, nonatomic) NSString *totalshareRate;
@property (strong, nonatomic) NSString *vestYears;

@property (strong, nonatomic) NSMutableArray *commentList;//评论列表
@property (assign, nonatomic) BOOL userState;//用户的认证状态
@property (strong, nonatomic) NSString *middleContent;//中间的连串
@property (strong, nonatomic) NSString *isDeleted;//是否已经在服务端删除了
@property (assign, nonatomic) BOOL isCollection;//是否收藏
@property (strong, nonatomic) NSString *createBy;//创建者
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *headImageUrl;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *businessTitle;
@end

@interface SHGBusinessFirstObject : NSObject

@property (strong, nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

@interface SHGBusinessSecondObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *subArray;

@end

@interface SHGBusinessSecondsubObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *code;//代号
@property (strong, nonatomic) NSString *value;//显示的文字
@property (strong, nonatomic) NSString *superCode;//所属的父分类名称，指向对应的secondObject的key

@end

typedef NS_ENUM(NSInteger, SHGBusinessNoticeType)
{
    SHGBusinessTypePositionTop = 0,
    SHGBusinessTypePositionAny
};


@interface SHGBusinessNoticeObject : SHGBusinessObject

@property (strong, nonatomic) NSString *tipUrl;
@property (assign, nonatomic) SHGBusinessNoticeType noticeType;

@end

@interface SHGBusinessCommentObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *commentUserId;
@property (strong, nonatomic) NSString *commentDetail;
@property (strong, nonatomic) NSString *commentUserName;
@property (strong, nonatomic) NSString *commentOtherName;

- (CGFloat)heightForCell;

@end