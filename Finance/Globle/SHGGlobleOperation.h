//
//  SHGGlobleOperation.h
//  Finance
//
//  Created by changxicao on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGGlobleOperation : NSObject

+ (instancetype)sharedGloble;

//关注
+ (void)registerAttationClass:(Class)CClass method:(SEL)selector;

+ (void)addAttation:(id)object;

//动态点赞
+ (void)registerPraiseClass:(Class)CClass method:(SEL)selector;

+ (void)addPraise:(id)object;

//动态删除
+ (void)registerDeleteClass:(Class)CClass method:(SEL)selector;

+ (void)deleteObject:(id)object;

@end