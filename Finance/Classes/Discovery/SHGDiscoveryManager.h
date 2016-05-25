//
//  SHGDiscovryManager.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGDiscoveryManager : NSObject

+ (instancetype)shareManager;

+ (void)loadDiscoveryData:(NSDictionary *)param block:(void (^)(NSArray *dataArray))block;

@end
