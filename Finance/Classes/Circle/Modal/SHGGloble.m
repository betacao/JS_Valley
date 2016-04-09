 //
//  SHGGloble.m
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGGloble.h"
#import "SHGUserTagModel.h"
#import "SHGMarketSegmentViewController.h"
#import "HeadImage.h"

@interface SHGGloble ()

/**
 @brief  当前用户名

 @since 1.5.0
 */
@property (strong, nonatomic) NSString *currentUserID;
/**
 @brief  首页url返回的数据，如果没有数据也不是nil
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSMutableArray *homeListArray;

/**
 @brief  返回首页的推广数据

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *homeAdArray;

/**
 @brief  返回首页总数据，即时上面数据的合并

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *homeArray;


@end

@implementation SHGGloble

+ (instancetype)sharedGloble
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
        //添加一个通知 观察uid的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
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

- (NSMutableArray *)homeListArray
{
    if(!_homeListArray){
        _homeListArray = [NSMutableArray array];
    }
    return _homeListArray;
}

- (NSMutableArray *)homeAdArray
{
    if(!_homeAdArray){
        _homeAdArray = [NSMutableArray array];
    }
    return _homeAdArray;
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
    self.currentUserID = UID;
    if(IsStrEmpty(UID)){
        return;
    }
    [[SHGHomeViewController sharedController] requestRecommendFriends];
    [[SHGHomeViewController sharedController] loadRegisterPushFriend];
    NSDictionary *param = @{@"uid":UID, @"type":@"all", @"target":@"first", @"rid":@(0), @"num": rRequestNum, @"tagId": @"-1"};
    
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,dynamicAndNews] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
        NSLog(@"首页预加载数据成功");
        NSArray *array = [response.dataDictionary objectForKey:@"normalpostlist"];
        array = [self parseServerJsonArrayToJSONModel:array class:[CircleListObj class]];
        [weakSelf.homeListArray removeAllObjects];
        [weakSelf.homeListArray addObjectsFromArray:array];

        array = [response.dataDictionary objectForKey:@"adlist"];
        array = [self parseServerJsonArrayToJSONModel:array class:[CircleListObj class]];
        [weakSelf.homeAdArray removeAllObjects];
        [weakSelf.homeAdArray addObjectsFromArray:array];

        [weakSelf.homeArray removeAllObjects];
        [weakSelf.homeArray addObjectsFromArray:weakSelf.homeListArray];
        if(weakSelf.homeArray.count > 0){
            for(CircleListObj *obj in weakSelf.homeAdArray){
                NSInteger index = [obj.displayposition integerValue] - 1;
                [weakSelf.homeArray insertObject:obj atIndex:index];
            }
        }else{
            [weakSelf.homeArray addObjectsFromArray:weakSelf.homeAdArray];
        }

        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(weakSelf.homeArray, weakSelf.homeListArray, weakSelf.homeAdArray);
        }
    } failed:^(MOCHTTPResponse *response){
        [weakSelf.homeListArray removeAllObjects];
        if(weakSelf.CompletionBlock){
            weakSelf.CompletionBlock(weakSelf.homeArray, weakSelf.homeListArray, weakSelf.homeAdArray);
        }
    }];
}

- (void)setCompletionBlock:(SHHomeDataCompletionBlock)CompletionBlock
{
    _CompletionBlock = CompletionBlock;
    _CompletionBlock(self.homeArray, self.homeListArray, self.homeAdArray);
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if(uid && uid.length != 0 && ![self.currentUserID isEqualToString:uid]){
        self.currentUserID = uid;
        SHGMarketSegmentViewController *controller = [SHGMarketSegmentViewController sharedSegmentController];
        if ([controller isViewLoaded]) {
            [controller refreshListViewController];
        }
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
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/tag/baseUserTag",rBaseAddressForHttp] class:[SHGUserTagModel class] parameters:nil success:^(MOCHTTPResponse *response) {
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
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/tag/getUserSelectedTags",rBaseAddressForHttp] class:[SHGUserTagModel class] parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
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
    for(NSNumber *number in array){
        NSInteger index = [number integerValue];
        if(index < self.tagsArray.count){
            SHGUserTagModel *model = [self.tagsArray objectAtIndex:index];
            string = [string stringByAppendingFormat:@",%@",model.tagId];
        }
    }
    if([string rangeOfString:@","].location != NSNotFound){
        string = [string substringFromIndex:1];
    }

    __weak typeof(self) weakSelf = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",string,@"tagIds",@"edit",@"flag", nil];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/tag/saveOrUpdateUserTag",rBaseAddressForHttp] parameters:param success:^(MOCHTTPResponse *response) {
        [weakSelf.selectedTagsArray removeAllObjects];
        [weakSelf.selectedTagsArray addObjectsFromArray:array];
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


- (NSArray *)parseServerJsonArrayToJSONModel:(NSArray *)array class:(Class)class
{
    if ([class isSubclassOfClass:[MTLModel class]]) {
        NSMutableArray *saveArray = [NSMutableArray array];
        for(id obj in array){
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSError *error;
                id model = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:obj error:&error];
                if (error) {
                    MOCLogDebug(error.domain);
                }else{
                    [saveArray addObject:model];
                }
            }else{
                MOCLogDebug(@"服务器返回的数据应该为字典形式");
            }
        }
        return saveArray;
    }else{
        MOCLogDebug(@"class没有继承于JSONModel,只做单纯的返回数据,不处理");
        return nil;
    }
}


- (void)requsetUserVerifyStatus:(NSString *)str completion:(void (^)(BOOL))block failString:(NSString *)string
{
    [Hud showWait];
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/auth/isAuth"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        //未认证
        if ([[response.dataDictionary objectForKey:@"status"] isEqualToString:@"0"]) {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:string leftButtonTitle:@"取消" rightButtonTitle:@"去认证"];
            alert.rightBlock = ^{
                if (block) {
                    block(NO);
                    if ([str isEqualToString:@"market"]){
                        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"market_identity"];
                    } else if ([str isEqualToString:@"circle"]){
                        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity"];
                    }
                }
            };

            alert.leftBlock = ^{
                if ([str isEqualToString:@"market"]){
                    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"market_identity_cancel"];
                } else if ([str isEqualToString:@"circle"]){
                    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity_cancel"];
                }
            };
            [alert show];

        } else{
            if (block) {
                block(YES);
            }
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"获取用户认证状态失败"];
    }];
}

- (void)recordUserAction:(NSString *)recordIdStr type:(NSString *)typeStr
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/record/recordUserAction"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID ];
    NSString *recordId = recordIdStr;
    NSString *type = typeStr;
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"uid":uid, @"recordId":recordId,@"type":type} success:^(MOCHTTPResponse *response) {
    } failed:^(MOCHTTPResponse *response) {
    }];
}

- (void)registerToken:(NSDictionary *)param block:(void (^)(BOOL, MOCHTTPResponse *))block
{
    [MOCHTTPRequestOperationManager putWithURL:rBaseAddressForHttpUBpush class:nil parameters:param success:^(MOCHTTPResponse *response) {
        block(YES, response);
    } failed:^(MOCHTTPResponse *response) {
        block(NO, response);
    }];
}

- (UIViewController *)getCurrentRootViewController
{
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    } else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    } else{
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    }
    return result;
}

- (void)checkForUpdate:(void (^)(BOOL state))block
{
    NSString *request = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttp,@"/version"];
    [MOCHTTPRequestOperationManager getWithURL:request parameters:@{@"os":@"iOS"} success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = response.dataDictionary;
        NSString *version = [dictionary objectForKey:@"version"];
        BOOL force = [[dictionary objectForKey:@"force"] isEqualToString:@"Y"] ? YES : NO;
        NSString *detail = [dictionary objectForKey:@"detail"];

        NSString *localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        if ([localVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
            if (block) {
                block(YES);
            } else{
                DXAlertView *alert = nil;
                UILabel *label = [[UILabel alloc] init];
                label.text = detail;
                label.numberOfLines = 0;
                label.textColor = [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1];
                label.font = FontFactor(13.0f);
                label.origin = CGPointMake(kLineViewLeftMargin, kCustomViewButtomMargin);
                CGSize size = [label sizeThatFits:CGSizeMake(kAlertWidth - 2 * kLineViewLeftMargin, CGFLOAT_MAX)];
                label.size = size;
                UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAlertWidth, size.height + kCustomViewButtomMargin)];
                [contentView addSubview:label];
                alert = [[DXAlertView alloc] initWithTitle:@"提示" customView:contentView leftButtonTitle:nil rightButtonTitle:@"立即更新"];
                alert.rightBlock = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-niu-quan-jin-rong-zheng/id984379568?mt=8"]];
                };
                alert.shouldDismiss = NO;
                if(force){
                    [alert show];
                } else{
                    [alert showWithClose];
                }
            }
        } else{
            if (block) {
                block(NO);
            }
        }

    } failed:^(MOCHTTPResponse *response) {
        if (block) {
            block(NO);
        }
    }];
}


- (void)refreshFriendListWithUid:(NSString *)userId finishBlock:(void (^)(BasePeopleObject *))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/%@",rBaseAddressForHttp,userId] parameters:nil success:^(MOCHTTPResponse *response) {
            NSMutableArray *arr = [NSMutableArray array];
            NSDictionary *dic = response.dataDictionary;

            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nick"];
            obj.headImageUrl = [dic valueForKey:@"avatar"];
            obj.uid = [dic valueForKey:@"username"];
            obj.rela = [dic valueForKey:@"rela"];
            obj.company = [dic valueForKey:@"company"];
            obj.commonfriend = @"";
            obj.commonfriendnum = @"";
            [arr addObject:obj];
            [HeadImage inertWithArr:arr];
            block(obj);
            
        } failed:^(MOCHTTPResponse *response) {
            
        }];
    });
}

@end
