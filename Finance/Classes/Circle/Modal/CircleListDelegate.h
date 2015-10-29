//
//  Header.h
//  Finance
//
//  Created by changxicao on 15/8/22.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

@protocol CircleListDelegate <NSObject>
@optional

- (void)praiseClicked:(CircleListObj *)obj;

- (void)commentClicked:(CircleListObj *)obj;
- (void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;

- (void)shareClicked:(CircleListObj *)obj;

- (void)attentionClicked:(CircleListObj *)obj;

- (void)deleteClicked:(CircleListObj *)obj;
- (void)cityClicked:(CircleListObj *)obj;

- (void)pullClicked:(CircleListObj *)obj;
- (void)clicked:(NSInteger )index;
- (void)headTap:(NSInteger )index;
- (void)didSelectPerson:(NSString *)uid name:(NSString *)userName;
- (void)cnickCLick:(NSString * )userId name:(NSString *)name;

-(void)photosTapWIthIndex:(NSInteger)index imageIndex:(NSInteger) imageIndex;

@end