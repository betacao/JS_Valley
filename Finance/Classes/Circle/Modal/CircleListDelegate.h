//
//  Header.h
//  Finance
//
//  Created by changxicao on 15/8/22.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

@protocol CircleListDelegate <NSObject>
@optional
//点赞代理
- (void)praiseClicked:(CircleListObj *)obj;
//评论代理
- (void)commentClicked:(CircleListObj *)obj;
- (void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
- (void)shareClicked:(CircleListObj *)obj;
- (void)attentionClicked:(CircleListObj *)obj;
- (void)deleteClicked:(CircleListObj *)obj;
- (void)moreMessageClicked:(CircleListObj *)obj;
- (void)pullClicked:(CircleListObj *)obj;
- (void)clicked:(NSInteger )index;
- (void)headTap:(NSInteger )index;
- (void)cnickCLick:(NSString * )userId name:(NSString *)name;

@end