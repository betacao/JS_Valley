//
//  MOWHttpManager.h
//  CommonFramework
//
//  Created by 吴仕海 on 4/3/15.
//  Copyright (c) 2015 408939786@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOCHTTPRequestOperationManager.h"

@interface MOWHttpManager : MOCHTTPRequestOperationManager

+ (void)postWithURL:(NSString *)url method:(NSString *)method parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)postWithURL:(NSString *)url method:(NSString *)method class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;

@end
