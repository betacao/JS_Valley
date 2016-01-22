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

@property (strong, nonatomic) NSString *cityName;

+ (instancetype)shareManager;

- (void)clearAllData;

- (void)userSelectedArray:(void (^)(NSArray *array))block;

- (void)modifyUserSelectedArray:(NSArray *)array;

- (void)userListArray:(void (^)(NSArray *array))block;

- (void)userTotalArray:(void (^)(NSArray *array))block;

- (void)loadHotCitys:(void (^)(NSArray *array))block;

+ (void)loadTotalMarketList:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSArray *tipArray))block;

+ (void)loadMineMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)uploadUserMarket:(NSDictionary *)param block:(void(^)(void))block;

+ (void)searchMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)createNewMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)modifyMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)deleteMarket:(SHGMarketObject *)object success:(void (^)(BOOL success))block;

+ (void)loadMarketDetail:(NSDictionary *)param block:(void (^)(SHGMarketObject *object))block;

+ (void)addPraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

+ (void)deletePraiseWithObject:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

+ (void)addCommentWithObject:(SHGMarketObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block;

+ (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block;

- (void)shareAction:(SHGMarketObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block;

+ (void)shareSuccessCallBack:(SHGMarketObject *)object finishBlock:(void (^)(BOOL))block;

@end
