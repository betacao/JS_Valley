//
//  SHGBusinessManager.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHGBusinessObject.h"
@interface SHGBusinessManager : NSObject

+ (instancetype)shareManager;

- (void)clearCache;

+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *position, NSString *tipUrl, NSString *cfData))block;

+ (void)getMyorSearchDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *total))block;

- (void)getSecondListBlock:(void (^)(NSArray *array, NSString *cityName))block;

+ (void)createNewBusiness:(NSDictionary *)param success:(void (^)( BOOL success,NSString *businessId))block;
+ (void)createBusinessNum:(void(^)(BOOL success, NSString *allowCreate))block;
+ (void)deleteBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL success))block;

+ (void)collectBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL success))block;

+ (void)unCollectBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL success))block;

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *array))block;

+ (void)getBusinessDetail:(SHGBusinessObject *)object success:(void (^)(SHGBusinessObject *detailObject))block;

+ (void)addCommentWithObject:(SHGBusinessObject *)object content:(NSString *)content toOther:(NSString *)otherId finishBlock:(void (^)(BOOL))block;

+ (void)deleteCommentWithID:(NSString *)commentId finishBlock:(void (^)(BOOL))block;

- (void)shareAction:(SHGBusinessObject *)object baseController:(UIViewController *)controller finishBlock:(void (^)(BOOL))block;

+ (void)shareSuccessCallBack:(SHGBusinessObject *)object finishBlock:(void (^)(BOOL))block;

+ (void)editBusiness:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)refreshBusiness:(SHGBusinessObject *)object success:(void (^)(BOOL success))block;

@end
