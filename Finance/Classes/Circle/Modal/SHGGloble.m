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
    _cityName = cityName;
    if(self.delegate && [self.delegate respondsToSelector:@selector(userlocationDidShow:)]){
        [self.delegate userlocationDidShow:cityName];
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

- (NSMutableArray *)contactArray
{
    if(!_contactArray){
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

- (BOOL)isShowGuideView
{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kShowVersion];
    NSString *newVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    if(!oldVersion || ![oldVersion isEqualToString:newVersion]){
        [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:kShowVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

#pragma mark ------ 请求首页数据 ------
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


#pragma mark ------ 标签功能 ------
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
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/user/tag/getUserSelectedTags",rBaseAddRessHttp] class:[SHGUserTagModel class] parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
        [weakSelf.selectedTagsArray removeAllObjects];
        [weakSelf.selectedTagsArray addObjectsFromArray:response.dataArray];
        block();
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"拉取个人标签失败"];
    } complete:nil];
}

- (void)uploadUserSelectedInfo:(NSArray *)array completion:(void(^)(BOOL finished))block
{
    if(array.count == 0){
        block(YES);
        return;
    }
    NSString *string = @"";
    for(NSNumber *number in array){
        NSInteger index = [number integerValue];
        if(index < [SHGGloble sharedGloble].tagsArray.count){
            SHGUserTagModel *model = [[SHGGloble sharedGloble].tagsArray objectAtIndex:index];
            string = [string stringByAppendingFormat:@",%@",model.tagId];
        }
    }
    if([string rangeOfString:@","].location != NSNotFound){
        string = [string substringFromIndex:1];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",string,@"tagIds",@"edit",@"flag", nil];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/v1/user/tag/saveOrUpdateUserTag",rBaseAddRessHttp] parameters:param success:^(MOCHTTPResponse *response) {
        block(YES);
    } failed:^(MOCHTTPResponse *response) {
        block(NO);
    }];
}

#pragma mark ------ 通讯录功能 ------

- (void)getUserAddressList:(void (^)(BOOL))block
{
    __weak typeof(self) weakSelf = self;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            if (error){
                NSLog(@"Error: %@", (__bridge NSError *)error);
                block(NO);
            } else if (!granted){
                block(NO);
            } else{
                CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
                for(int i = 0; i < CFArrayGetCount(results); i++){
                    ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    for (int k = 0; k < ABMultiValueGetCount(phone); k++){
                        //获取該Label下的电话值
                        NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                        NSString *phone = [personPhone validPhone];
                        NSString *personNameFirst = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        NSString *personNameLast = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                        NSString *personName = @"";

                        if (!IsStrEmpty(personNameLast)){
                            personName =[NSString stringWithFormat:@"%@",personNameLast];

                        }
                        if (!IsStrEmpty(personNameFirst)){
                            personName =[NSString stringWithFormat:@"%@%@",personNameLast,personNameFirst];
                        }
                        NSString *text = [NSString stringWithFormat:@"%@#%@",personName,phone];
                        BOOL hasExsis = NO;
                        NSInteger index = 0;
                        for (NSInteger i = 0 ; i < self.contactArray.count; i ++){
                            NSString *phoneStr = self.contactArray[i];
                            if ([phoneStr hasSuffix:phone]) {
                                hasExsis = YES;
                                index = i;
                                break;
                            }
                        }
                        if ([phone isValidateMobile]){
                            if (hasExsis){
                                [weakSelf.contactArray replaceObjectAtIndex:index withObject:text];
                            } else{
                                [weakSelf.contactArray addObject:text];
                            }
                        }
                    }
                }
                block(YES);
            }
        });
    });
}

- (void)uploadPhonesWithPhone:(void(^)(BOOL finish))block
{
    if(self.contactArray.count == 0){
        block(YES);
    } else{
        NSInteger num = self.contactArray.count / 100 + 1;
        for (NSInteger i = 1; i <= num; i++) {
            NSMutableArray *arr = [NSMutableArray array];

            NSInteger count = 0;
            if (self.contactArray.count > i * 100) {
                count =  i * 100;
            }
            else{
                count = (i - 1) *100 + self.contactArray.count % 100;
            }
            for (NSInteger j = (i - 1) * 100; j < count; j ++){
                [arr addObject:self.contactArray[j]];
            }
            if (!IsArrEmpty(arr)) {
                [self uploadPhone:arr finishBlock:block];
            }
        }
    }
}


- (void)uploadPhone:(NSMutableArray *)arr finishBlock:(void(^)(BOOL finish))block
{
    NSString *str = arr[0];
    for (int i = 1 ; i < arr.count; i ++) {
        str = [NSString stringWithFormat:@"%@,%@",str,arr[i]];
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/contact"];
    NSDictionary *parm = @{@"phones":str, @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [MobClick event:@"ActionUpdatedContacts" label:@"onClick"];
            block(YES);
        } else{
            block(NO);
        }
    } failed:^(MOCHTTPResponse *response) {
        block(NO);
    }];
}


@end
