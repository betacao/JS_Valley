//
//  SHGCircleManager.h
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGCircleManager : NSObject

+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *normalArray, NSArray *adArray))block;

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *array))block;

+ (void)getListDataWithCategory:(NSDictionary *)param block:(void (^)(NSArray *array))block;

@end
