//
//  SHGGloble.h
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SHHomeDataCompletionBlock)(NSArray *dataArray);
typedef void (^SHHomeDataCompletionBlock)(NSArray *dataArray);

@protocol SHGGlobleDelegate <NSObject>

@optional

- (void)userlocationDidShow:(NSString *)cityName;

@end

@interface SHGGloble : NSObject

/**
 @brief  全局代理

 @since 1.5.0
 */
@property (assign, nonatomic) id<SHGGlobleDelegate> delegate;

/**
 @brief  当前的省份名称
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSString *provinceName;

/**
 @brief  当前城市的名称
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSString *cityName;

/**
 @brief  首页请求完成的回掉
 
 @since 1.4.1
 */
@property (copy, nonatomic) SHHomeDataCompletionBlock CompletionBlock;

/**
 @brief  globle单例
 
 @return 当前对象
 
 @since 1.4.1
 */
+ (instancetype)sharedGloble;

/**
 @brief  程序首次启动未显示首页的情况下去请求数据
 
 @since 1.4.1
 */
- (void)requestHomePageData;


@end
