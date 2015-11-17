//
//  SHGGloble.h
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SHHomeDataCompletionBlock)(NSArray *allList, NSArray *normalList, NSArray *adList);

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
 @brief  个人标签数据(供选择)

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *tagsArray;

/**
 @brief  用户选择的标签

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *selectedTagsArray;

/**
 @brief  获取到的通讯录数组

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *contactArray;

/**
 @brief  用户浏览的数据字典，从服务端读取 然后返回给服务端
 用于下拉刷新

 @since 1.5.0
 */
@property (strong, nonatomic) NSDictionary *maxUserTags;

/**
 @brief  用户浏览的数据字典，从服务端读取 然后返回给服务端
 用于上拉加载

 @since 1.5.0
 */
@property (strong, nonatomic) NSDictionary *minUserTags;

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
 @brief  是否需要启动界面

 @return 是否是第一次启动 或者是升级了应用

 @since 1.5.0
 */
- (BOOL)isShowGuideView;

/**
 @brief  程序首次启动未显示首页的情况下去请求数据
 
 @since 1.4.1
 */
- (void)requestHomePageData;

/**
 @brief  获取所有的标签

 @since 1.5.0
 */
- (void)downloadUserTagInfo:(void(^)())block;

/**
 @brief  获取用户选择的标签

 @param block

 @since 1.5.0
 */
- (void)downloadUserSelectedInfo:(void (^)())block;

/**
 @brief  上传用户选择的标签

 @since 1.5.0
 */
- (void)uploadUserSelectedInfo:(NSArray *)array completion:(void(^)(BOOL finished))block;

/**
 @brief  获取用户的通讯录

 @param block 是否完成获取操作

 @since 1.5.0
 */
- (void)getUserAddressList:(void(^)(BOOL finished))block;

/**
 @brief  上传用户的通讯录

 @param block 是否完成上传操作

 @since 1.5.0
 */
- (void)uploadPhonesWithPhone:(void(^)(BOOL finish))block;


/**
 @brief  格式化得到的数据到object数组

 @param array 字典数据
 @param class 固定的类

 @return object数据

 @since 1.5.0
 */
- (NSArray *)parseServerJsonArrayToJSONModel:(NSArray *)array class:(Class)class;

/**
 @brief  获取用户认证状态

 @param block 返回状态

 @since 1.6.0
 */
- (void)requsetUserVerifyStatus:(void(^)(BOOL status))block;

@end
