//
//  SHGCompanyManager.h
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHGCompanyObject.h"

@interface SHGCompanyManager : NSObject

+ (void)loadBlurCompanyInfo:(NSDictionary *)param success:(void (^)(NSArray *array))block;

+ (void)loadExactCompanyInfo:(NSDictionary *)param success:(void (^)(SHGCompanyObject *object))block;

@end
