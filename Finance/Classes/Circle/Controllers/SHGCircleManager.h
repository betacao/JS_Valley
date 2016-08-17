//
//  SHGCircleManager.h
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGCircleManager : NSObject

+ (void)loadHotSearchWordFinishBlock:(void (^)(NSArray *array))block;

@end
