//
//  SHGGlobleOperation.m
//  Finance
//
//  Created by changxicao on 16/5/30.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGlobleOperation.h"
#import "SHGDiscoveryObject.h"
#import "RecmdFriendObj.h"

@interface SHGGlobleOperation()

@property (strong, nonatomic) NSMutableArray *attationArray;

@end

@implementation SHGGlobleOperation

+ (instancetype)sharedGloble
{
    static SHGGlobleOperation *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (NSMutableArray *)attationArray
{
    if (!_attationArray) {
        _attationArray = [NSMutableArray array];
    }
    return _attationArray;
}

+ (void)registerAttationClass:(Class)CClass method:(SEL)selector
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:NSStringFromClass(CClass) forKey:NSStringFromSelector(selector)];
    [[SHGGlobleOperation sharedGloble].attationArray insertUniqueObject:dictionary];
}

+ (void)addAttation:(id)object
{
    [Hud showWait];
    NSString *targetUserID = @"";
    BOOL attationState = NO;
    if ([object isKindOfClass:[CircleListObj class]]) {
        CircleListObj *circleListObject = (CircleListObj *)object;
        targetUserID = circleListObject.userid;
        attationState = circleListObject.isAttention;
    } else if ([object isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
        SHGDiscoveryPeopleObject *peopleObject = (SHGDiscoveryPeopleObject *)object;
        targetUserID = peopleObject.userID;
        attationState = peopleObject.isAttention;
        [[SHGGloble sharedGloble] recordUserAction:targetUserID type:@"newdiscover_attention"];
    } else if ([object isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
        SHGDiscoveryDepartmentObject *departmentObject = (SHGDiscoveryDepartmentObject *)object;
        targetUserID = departmentObject.userID;
        attationState = departmentObject.isAttention;
        [[SHGGloble sharedGloble] recordUserAction:targetUserID type:@"newdiscover_attention"];
    } else if ([object isKindOfClass:[SHGDiscoveryRecommendObject class]]) {
        SHGDiscoveryRecommendObject *recommendObject = (SHGDiscoveryRecommendObject *)object;
        targetUserID = recommendObject.userID;
        attationState = recommendObject.isAttention;
        [[SHGGloble sharedGloble] recordUserAction:targetUserID type:@"newdiscover_attention"];
    } else if ([object isKindOfClass:[RecmdFriendObj class]]) {
        RecmdFriendObj *friendObject = (RecmdFriendObj *)object;
        targetUserID = friendObject.uid;
        attationState = friendObject.isAttention;
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":UID, @"oid":targetUserID};
    if (!attationState) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                //记录行为轨迹
                [MobClick event:@"ActionAttentionClicked" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] addAttationSuccess:targetUserID attationState:YES];
                [Hud showMessageWithText:@"关注成功"];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else {
        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                //记录行为轨迹
                [MobClick event:@"ActionAttentionClickedFalse" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] addAttationSuccess:targetUserID attationState:NO];
                [Hud showMessageWithText:@"取消关注成功"];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
}

- (void)addAttationSuccess:(NSString *)targetUserID attationState:(BOOL)attationState
{
    UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    NSMutableArray *controllerArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    [controllerArray addObjectsFromArray:[TabBarViewController tabBar].viewControllers];
    [self.attationArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString([dictionary.allValues firstObject]);
        SEL selector = NSSelectorFromString([dictionary.allKeys firstObject]);
        for (UIViewController *controller in controllerArray) {
            if ([controller isKindOfClass:class]) {
                IMP imp = [controller methodForSelector:selector];
                void (*func)(id, SEL, id, BOOL) = (void *)imp;
                func(controller, selector, targetUserID, attationState);
            }
        }

    }];
}

@end

