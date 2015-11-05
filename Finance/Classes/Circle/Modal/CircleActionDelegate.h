//
//  Header.h
//  Finance
//
//  Created by changxicao on 15/11/4.
//  Copyright © 2015年 HuMin. All rights reserved.
//
@class CircleListObj;

@protocol CircleActionDelegate <NSObject>
@optional
- (void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString*)num isPraised:(NSString *)isPrased;
- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString *)num comments:(NSMutableArray *)comments;
- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString*)num;
- (void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten;
- (void)detailDeleteWithRid:(NSString *)rid ;
- (void)detailCollectionWithRid:(NSString *)rid collected:(NSString *)isColle;
- (void)homeListShouldRefresh:(CircleListObj *)currentObj;

@end
