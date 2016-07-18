//
//  SHGGloble.m
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGGloble.h"
#import "SHGUserTagModel.h"
#import "SHGBusinessListViewController.h"
#import "SHGDiscoveryViewController.h"
#import "SHGBusinessManager.h"
#import "HeadImage.h"
#import "sys/utsname.h"
#import <MessageUI/MessageUI.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface SHGGloble ()<MFMessageComposeViewControllerDelegate>

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

/**
 @brief 业务key和value对应的值

 @since 1.8.0
 */
@property (strong, nonatomic) NSDictionary *businessDictionary;

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
        self.provinceName = @"";
        self.currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
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

- (NSString *)platform
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
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
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,dynamicNew] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response){
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
        SHGBusinessListViewController *controller = [SHGBusinessListViewController sharedController];
        if ([controller isViewLoaded]) {
            [[SHGBusinessManager shareManager] clearCache];
            controller.needReloadData = YES;
        }
        [[SHGDiscoveryViewController sharedController] loadData];
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


- (void)requestUserVerifyStatusCompletion:(void (^)(BOOL, NSString *))completionblock showAlert:(BOOL)showAlert leftBlock:(void(^)())leftblock failString:(NSString *)string
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/auth/isAuth"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
        //未认证
        NSString *auditState = [response.dataDictionary objectForKey:@"auditstate"];
        if ([[response.dataDictionary objectForKey:@"status"] isEqualToString:@"0"]) {
            if (showAlert) {
                SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:string leftButtonTitle:@"取消" rightButtonTitle:@"去认证"];
                alert.leftBlock = leftblock;
                alert.rightBlock = ^{
                    completionblock(NO,auditState);
                };
                [alert show];
            } else {
                completionblock(NO,auditState);
            }
        } else {
            completionblock(YES,auditState);
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"获取用户认证状态失败"];
    }];

}


- (void)recordUserAction:(NSString *)recordIdStr type:(NSString *)typeStr
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/record/recordUserAction"];
    [MOCHTTPRequestOperationManager postWithURL:request parameters:@{@"uid":UID, @"recordId":recordIdStr,@"type":typeStr} success:^(MOCHTTPResponse *response) {
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
                UILabel *label = [[UILabel alloc] init];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = MarginFactor(4.0f);
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:Color(@"8d8d8d"), NSFontAttributeName:FontFactor(17.0f)}];
                label.attributedText = string;
                label.numberOfLines = 0;
                label.origin = CGPointMake(MarginFactor(26.0f), MarginFactor(17.0f));
                CGSize size = [label sizeThatFits:CGSizeMake(MarginFactor(300.0f) - 2 * MarginFactor(26.0f), CGFLOAT_MAX)];
                label.size = size;
                UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MarginFactor(300.0f), size.height + MarginFactor(17.0f))];
                [contentView addSubview:label];
                SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"版本更新" customView:contentView leftButtonTitle:nil rightButtonTitle:@"立即更新"];
                [alert addSubTitle:[@"V" stringByAppendingString: version]];
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


//此功能------当此用户注册成功的时候调用通知给其他的好友用户
- (void)dealFriendPush
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/dealFriendPush"];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    if (IsStrEmpty(name)) {
        name = @"";
    }
    NSDictionary *parm = @{@"uid":UID, @"name":name};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {

    } failed:^(MOCHTTPResponse *response) {

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

- (NSDictionary *)getBusinessKeysAndValues
{
    if (!self.businessDictionary) {
        self.businessDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SHGBusinessSelectString" ofType:@"plist"]];
    }
    return self.businessDictionary;
}


- (NSString *)businessKeysForValues:(NSString *)values showEmptyKeys:(BOOL)show;
{
    __block NSString *key = @"";
    __block NSString *value = @"";
    __block NSString *result = @"";
    NSArray *globleKeyArray = [[self getBusinessKeysAndValues] allKeys];
    NSArray *globleValueArray = [[self getBusinessKeysAndValues] allValues];
    NSArray *keys = [values componentsSeparatedByString:@"#"];

    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        key = [[obj componentsSeparatedByString:@":"] firstObject];
        value = [[obj componentsSeparatedByString:@":"] lastObject];
        if (show) {
            __block NSString *string = [NSString stringWithFormat:@"%@：%@\n",key, value];

            NSArray *valueArray = [value componentsSeparatedByString:@";"];
            string = [string stringByReplacingOccurrencesOfString:@";" withString:@"，"];
            [valueArray enumerateObjectsUsingBlock:^(NSString *subValue, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([globleValueArray containsObject:subValue]) {
                    string = [string stringByReplacingOccurrencesOfString:subValue withString:[globleKeyArray objectAtIndex:[globleValueArray indexOfObject:subValue]]];
                }
            }];
            result = [result stringByAppendingString:string];
        } else{
            if (!IsStrEmpty(value)) {
                __block NSString *string = [NSString stringWithFormat:@"%@：%@\n",key, value];

                NSArray *valueArray = [value componentsSeparatedByString:@";"];
                string = [string stringByReplacingOccurrencesOfString:@";" withString:@"，"];
                [valueArray enumerateObjectsUsingBlock:^(NSString *subValue, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([globleValueArray containsObject:subValue]) {
                        string = [string stringByReplacingOccurrencesOfString:subValue withString:[globleKeyArray objectAtIndex:[globleValueArray indexOfObject:subValue]]];
                    }
                }];
                result = [result stringByAppendingString:string];
            }
        }

    }];
    return  result;
}


- (NSMutableArray *)editBusinessKeysForValues:(NSArray *)nameArray middleContentArray:(NSArray *)middleContentArray
{

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [middleContentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[obj componentsSeparatedByString:@"："] firstObject];
        NSString *value = [[obj componentsSeparatedByString:@"："] lastObject];
        for (NSInteger i = 0; i < nameArray.count; i ++) {
            if ([key isEqualToString:[nameArray objectAtIndex:i]]) {
                [resultArray addObject:value];
            }

        }
    }];
    return resultArray;
}

- (NSString *)checkPhoneNumber:(NSString *)mobileNum
{
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[3578]+\\d{9}|\\d{8}|\\d{7}"];

    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(0[1,2]{1}\\d{1}-?\\d{8})|(0[3-9] {1}\\d{2}-?\\d{7,8})|(0[1,2]{1}\\d{1}-?\\d{8}-(\\d{1,4}))|(0[3-9]{1}\\d{2}-? \\d{7,8}-(\\d{1,4}))|0[7,8]\\d{2}-?\\d{8}|0\\d{2,3}-?\\d{7,8}"];

    if (([mobilePredicate evaluateWithObject:mobileNum] == YES) || ([phonePredicate evaluateWithObject:mobileNum] == YES)){
        return nil;
    } else{
        return @"请输入正确的手机号码或座机号";
    }
}

- (void)dialNumber:(NSString *)number
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",number]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)showMessageView:(NSArray *)phones body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [[self getCurrentRootViewController] presentViewController:controller animated:YES completion:nil];
    } else {
        SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"该设备不支持短信功能" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    }
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功

            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

- (NSString *)formatStringToHtml:(NSString *)string
{
    __block NSString *copyString = [NSString stringWithString:string];
    NSString *urlRegular = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:urlRegular options:0 error:nil];
    NSArray *resultArray = [expression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSTextCheckingResult *obj1, NSTextCheckingResult *obj2) {
        if (obj1.range.location < obj2.range.location) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];

    NSMutableArray *titleArray = [NSMutableArray array];
    [resultArray enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray insertUniqueObject:[string substringWithRange:obj.range]];
    }];

    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *replaceString = [NSString stringWithFormat:@"<a href='%@'>网页链接</a>",obj];
        copyString = [copyString stringByReplacingOccurrencesOfString:obj withString:replaceString];
    }];
    return copyString;
}

+ (void)addHtmlListener:(UIWebView *)webView key:(NSString *)key block:(void (^)(void))block
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[key] = block;
}


@end
