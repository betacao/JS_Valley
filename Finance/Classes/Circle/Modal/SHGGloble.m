//
//  SHGGloble.m
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGGloble.h"
#import "SHGUserTagModel.h"


@interface SHGGloble ()
/**
 @brief  首页url返回的数据，如果没有数据也不是nil
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSMutableArray *homeArray;

@end

@implementation SHGGloble

+(instancetype)sharedGloble
{
    static SHGGloble *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        self.cityName = @"";
    }
    return self;
}

- (void)setCityName:(NSString *)cityName
{
    if(_cityName != cityName){
        _cityName = cityName;
        if(self.delegate && [self.delegate respondsToSelector:@selector(userlocationDidShow:)]){
            [self.delegate userlocationDidShow:cityName];
        }
    }
}

- (NSMutableArray *)homeArray
{
    if(!_homeArray){
        _homeArray = [NSMutableArray array];
    }
    return _homeArray;
}

- (NSMutableArray *)tagsArray
{
    if(!_tagsArray){
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

- (NSMutableArray *)selectedTagsArray
{
    if(!_selectedTagsArray){
        _selectedTagsArray = [NSMutableArray array];
    }
    return _selectedTagsArray;
}

- (void)requestHomePageData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if(!uid || uid.length == 0){
        //添加一个通知 观察uid的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
        return;
    }
    NSDictionary *param = @{@"uid":uid, @"type":@"all", @"target":@"first", @"rid":@(0), @"num": rRequestNum, @"total":@(0)};
    
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,circleBak] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据成功");
        [weakSelf.homeArray removeAllObjects];
        [weakSelf.homeArray addObjectsFromArray:response.dataArray];
        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(weakSelf.homeArray);
        }
    } failed:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据失败");
        [weakSelf.homeArray removeAllObjects];
        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(weakSelf.homeArray);
        }
    }];
}

- (void)setCompletionBlock:(SHHomeDataCompletionBlock)CompletionBlock
{
    _CompletionBlock = CompletionBlock;
    if(self.homeArray && [self.homeArray count] > 0){
        _CompletionBlock(self.homeArray);
    }
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if(uid && uid.length != 0){
        [self requestHomePageData];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


- (void)downloadUserTagInfo:(void (^)())block
{
    if(self.tagsArray.count > 0){
        block();
        return;
    }
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/user/tag/baseUserTag",rBaseAddRessHttp] class:[SHGUserTagModel class] parameters:nil success:^(MOCHTTPResponse *response) {
        [weakSelf.tagsArray removeAllObjects];
        [weakSelf.tagsArray addObjectsFromArray:response.dataArray];
        block();
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"拉取标签列表失败"];
    } complete:nil];
}

- (void)downloadUserSelectedInfo:(void (^)())block
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/user/tag/getUserTagAndBase",rBaseAddRessHttp] class:[SHGUserTagModel class] parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
        [weakSelf.selectedTagsArray removeAllObjects];
        [weakSelf.selectedTagsArray addObjectsFromArray:response.dataArray];
        block();
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"拉取个人标签失败"];
    } complete:nil];
}

- (void)uploadUserSelectedInfo:(NSArray *)array completion:(void(^)(BOOL finished))block
{
    NSString *string = @"";
    for(NSInteger i = 0;i < array.count;i++){
        SHGUserTagModel *model = [[SHGGloble sharedGloble].tagsArray objectAtIndex:i];
        string = [string stringByAppendingFormat:@",%@",model.tagId];
    }
    if([string rangeOfString:@","].location != NSNotFound){
        string = [string substringFromIndex:1];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",string,@"tagIds",@"edit",@"flag", nil];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/user/tag/saveOrUpdateUserTag",rBaseAddRessHttp] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"上传个人信息成功"];
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"上传个人信息失败"];
        block(NO);
    }];
}

@end
