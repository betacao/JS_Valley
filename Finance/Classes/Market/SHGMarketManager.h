//
//  SHGMarketManager.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHGMarketObject.h"

@interface SHGMarketManager : NSObject

+ (instancetype)shareManager;

- (void)loadMarketCategoryBlock:(void (^)(NSArray *array))block;

+ (void)loadMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)searchMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)createNewMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)modifyMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)loadMarketDetail:(NSDictionary *)param block:(void (^)(SHGMarketObject *object))block;

+ (void)addPraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

+ (void)deletePraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

+ (void)addCommentWithObject:(SHGMarketObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block;

+ (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block;

- (void)shareAction:(SHGMarketObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block;

+ (void)shareSuccessCallBack:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

@end
