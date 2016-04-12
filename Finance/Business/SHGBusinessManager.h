//
//  SHGBusinessManager.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGBusinessManager : NSObject

+ (instancetype)shareManager;

+ (void)getListDataWithParam:(NSDictionary *)param block:(void (^)(NSArray *dataArray, NSString *position, NSString *tipUrl))block;

- (void)getSecondListBlock:(void (^)(NSArray *array))block;

@end
