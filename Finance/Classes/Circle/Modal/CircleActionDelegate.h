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
- (void)detailCommentWithRid:(NSString *)rid commentNum:(NSString *)num comments:(NSMutableArray *)comments;
- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString*)num;

- (void)detailDeleteWithRid:(NSString *)rid ;
- (void)detailCollectionWithRid:(NSString *)rid collected:(NSString *)isColle;
- (void)detailHomeListShouldRefresh:(CircleListObj *)currentObj;

@end
