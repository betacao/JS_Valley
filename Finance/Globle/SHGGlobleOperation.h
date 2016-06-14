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

//关注
+ (void)registerAttationClass:(Class)CClass method:(SEL)selector;

+ (void)addAttation:(id)object;

//分享
+ (void)share:(id)object;
@end