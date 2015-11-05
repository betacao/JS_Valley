//
//  CircleListObj.h
//  Finance
//
//  Created by HuMin on 15/4/15.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"


#define kObjectMargin 10.0f * XFACTOR
#define kPhotoViewLeftMargin 14.0f * XFACTOR
#define kPhotoViewRightMargin 14.0f * XFACTOR
#define kCellContentWidth 292.0f * XFACTOR
#define kPhotoViewTopMargin 6.0f * XFACTOR
#define kCommentTopMargin 15.0f * XFACTOR
#define kCommentMargin 2.0f * XFACTOR
#define kCommentBottomMargin 9.0f * XFACTOR

@class linkOBj;

@interface CircleListObj : MTLModel<MTLJSONSerializing,MTLTransformerErrorHandling>

@property (nonatomic,strong) NSString *cmmtnum;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *isattention;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSArray  *photos;
@property (nonatomic,strong) NSString *potname;
@property (nonatomic,strong) NSString *praisenum;
@property (nonatomic,strong) NSMutableArray *heads;
@property (nonatomic,strong) NSString *iscollection;
@property (nonatomic,strong) NSString *publishdate;
@property (nonatomic,strong) NSString *rid;
@property (nonatomic,strong) NSString *sharenum;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) linkOBj *linkObj;
@property (nonatomic,strong) NSString *postType;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger cellHeight;
@property (nonatomic,assign) BOOL isPull;
@property (nonatomic,strong) NSArray *photoArr;
@property (nonatomic,strong) NSString *ispraise;
@property (nonatomic,strong) NSString *friendship; //好友关系
@property (nonatomic,strong) NSString *userstatus;  //认证状态
@property (nonatomic,strong) NSString *currcity; //城市
@property (nonatomic,strong) NSString *feedhtml; //feed流链接
@property (nonatomic,strong) NSString *displayposition;//广告所在的位置
@property (nonatomic,strong) NSString *pcurl;
-(CGFloat)fetchCellHeight;

@end

@interface commentOBj : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong)  NSString *cdetail ;
@property(nonatomic, strong)  NSString *cid;
@property(nonatomic, strong)  NSString *cnickname;
@property(nonatomic, strong)  NSString *rid ;
@property(nonatomic, strong)  NSString *rnickname;


@end

@interface photoObj : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong)  NSString *photos ;

@end

@interface praiseOBj:NSObject
@property(nonatomic, strong)  NSString *pnickname ;
@property(nonatomic, strong)  NSString *puserid;
@property(nonatomic, strong)  NSString *ppotname;

@end

@interface linkOBj : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong)  NSString *title ;
@property(nonatomic, strong)  NSString *desc;
@property(nonatomic, strong)  NSString *link;
@property (nonatomic, strong) NSString *thumbnail;

@end

