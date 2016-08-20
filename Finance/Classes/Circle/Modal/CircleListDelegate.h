//
//  Header.h
//  Finance
//
//  Created by changxicao on 15/8/22.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

@protocol CircleListDelegate <NSObject>
@optional
- (void)shareClicked:(CircleListObj *)obj;
- (void)moreMessageClicked:(CircleListObj *)obj;
- (void)pullClicked:(CircleListObj *)obj;
- (void)cnickCLick:(NSString * )userId name:(NSString *)name;

@end