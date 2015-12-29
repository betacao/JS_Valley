//
//  SHGMarketManager.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGMarketManager : NSObject

+ (instancetype)shareManager;

- (void)loadMarketCategoryBlock:(void (^)(NSArray *array))block;

+ (void)loadMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)searchMarketList:(NSDictionary *)param block:(void (^)(NSArray *array))block;

+ (void)createNewMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;

+ (void)modifyMarket:(NSDictionary *)param success:(void (^)(BOOL success))block;
@end
