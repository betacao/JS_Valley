//
//  CircleListObj.h
//  Finance
//
//  Created by HuMin on 15/4/15.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"


#define kObjectMargin 10.0f * XFACTOR
#define kPhotoViewLeftMargin MarginFactor(12.0f)
#define kPhotoViewRightMargin MarginFactor(12.0f)
#define kCellContentWidth 292.0f * XFACTOR
#define kPhotoViewTopMargin 10.0f * XFACTOR
#define kCommentTopMargin 11.0f * XFACTOR
#define kCommentMargin 2.0f * XFACTOR
#define kCommentBottomMargin 9.0f * XFACTOR

@class linkOBj;

@interface CircleListObj : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *businesstotal;
@property (strong, nonatomic) NSString *cmmtnum;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *detail;
@property (assign, nonatomic) BOOL isAttention;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSArray  *photos;
@property (strong, nonatomic) NSString *potname;
@property (strong, nonatomic) NSString *praisenum;
@property (strong, nonatomic) NSMutableArray *heads;
@property (strong, nonatomic) NSString *iscollection;
@property (strong, nonatomic) NSString *publishdate;
@property (strong, nonatomic) NSString *rid;
@property (strong, nonatomic) NSString *sharenum;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) linkOBj *linkObj;
@property (strong, nonatomic) NSString *postType;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) NSInteger cellHeight;
@property (assign, nonatomic) BOOL isPull;
@property (strong, nonatomic) NSArray *photoArr;
@property (strong, nonatomic) NSString *ispraise;
@property (strong, nonatomic) NSString *friendship; //好友关系
@property (strong, nonatomic) NSString *userstatus;  //认证状态
@property (strong, nonatomic) NSString *currcity; //城市
@property (strong, nonatomic) NSString *feedhtml; //feed流链接
@property (strong, nonatomic) NSString *displayposition;//广告所在的位置
@property (strong, nonatomic) NSString *pcurl;
@property (strong, nonatomic) NSString *shareTitle;

@property (strong, nonatomic)  NSString *companyname;
@property (strong, nonatomic)  NSString *phone;
@property (strong, nonatomic)  NSString *picname;
@property (strong, nonatomic)  NSString *position;
@property (strong, nonatomic)  NSString *realname;

@property (assign, nonatomic) BOOL businessStatus;
/**
 @brief 动态标题

 @since 1.8.4
 */
@property (strong, nonatomic)  NSString *groupPostTitle;
@property (strong, nonatomic)  NSString *groupPostUrl;
@property (strong, nonatomic)  NSString *businessID;


@end

@interface commentOBj : MTLModel<MTLJSONSerializing>
@property(strong, nonatomic)  NSString *cdetail ;
@property(strong, nonatomic)  NSString *cid;
@property(strong, nonatomic)  NSString *cnickname;
@property(strong, nonatomic)  NSString *rid;
@property(strong, nonatomic)  NSString *replyid ;
@property(strong, nonatomic)  NSString *rnickname;


@end

@interface photoObj : MTLModel<MTLJSONSerializing>
@property(strong, nonatomic)  NSString *photos ;

@end

@interface praiseOBj: MTLModel<MTLJSONSerializing>
@property(strong, nonatomic)  NSString *pnickname ;
@property(strong, nonatomic)  NSString *puserid;
@property(strong, nonatomic)  NSString *ppotname;

@end

@interface linkOBj : MTLModel<MTLJSONSerializing>
@property(strong, nonatomic)  NSString *title ;
@property(strong, nonatomic)  NSString *desc;
@property(strong, nonatomic)  NSString *link;
@property(strong, nonatomic) NSString *thumbnail;

@end



