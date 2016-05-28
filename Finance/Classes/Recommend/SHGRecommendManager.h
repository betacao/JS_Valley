//
//  SHGRecommendObject.h
//  Finance
//
//  Created by changxicao on 16/5/27.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGRecommendManager : NSObject

+ (instancetype)shareManager;

+ (void)loadRegistRecommendList:(NSDictionary *)param block:(void (^)(NSArray *dataArray))block;

@end
