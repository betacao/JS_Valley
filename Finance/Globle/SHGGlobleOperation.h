//
//  SHGGlobleOperation.h
//  Finance
//
//  Created by changxicao on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGGlobleOperation : NSObject

+ (instancetype)sharedGloble;

+ (void)registerAttationClass:(Class)CClass method:(SEL)selector;

+ (void)addAttation:(id)object;

@end