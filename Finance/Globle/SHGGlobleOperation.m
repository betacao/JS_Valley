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

@property (strong, nonatomic) NSMutableArray *praiseArray;

@property (strong, nonatomic) NSMutableArray *commentArray;

@property (strong, nonatomic) NSMutableArray *deleteArray;

@property (strong, nonatomic) NSMutableArray *collectionArray;

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

- (NSMutableArray *)praiseArray
{
    if (!_praiseArray) {
        _praiseArray = [NSMutableArray array];
    }
    return _praiseArray;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)collectionArray
{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

#pragma mark ------关注
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
                void (*func)(id, SEL, id, NSNumber *) = (void *)imp;
                func(controller, selector, targetUserID, @(attationState));
            }
        }

    }];
}

#pragma mark ------动态的点赞
+ (void)registerPraiseClass:(Class)CClass method:(SEL)selector
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:NSStringFromClass(CClass) forKey:NSStringFromSelector(selector)];
    [[SHGGlobleOperation sharedGloble].praiseArray insertUniqueObject:dictionary];
}

+ (void)addPraise:(id)object
{
    [Hud showWait];
    NSString *targetID = @"";
    BOOL praiseState = NO;
    if ([object isKindOfClass:[CircleListObj class]]) {
        CircleListObj *circleListObject = (CircleListObj *)object;
        targetID = circleListObject.rid;
        praiseState = [circleListObject.ispraise isEqualToString:@"Y"];
    }
    NSString *url = [rBaseAddressForHttpCircle stringByAppendingString:@"/praisesend"];
    NSDictionary *param = @{@"uid":UID,@"rid":targetID};
    if (!praiseState) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                //记录行为轨迹
                [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] addPraiseSuccess:targetID praiseState:YES];
                [Hud showMessageWithText:@"点赞成功"];
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
                [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] addPraiseSuccess:targetID praiseState:NO];
                [Hud showMessageWithText:@"取消点赞成功"];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
}

- (void)addPraiseSuccess:(NSString *)targetID praiseState:(BOOL)praiseState
{
    UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    NSMutableArray *controllerArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    [controllerArray addObjectsFromArray:[TabBarViewController tabBar].viewControllers];
    [self.praiseArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString([dictionary.allValues firstObject]);
        SEL selector = NSSelectorFromString([dictionary.allKeys firstObject]);
        for (UIViewController *controller in controllerArray) {
            if ([controller isKindOfClass:class]) {
                IMP imp = [controller methodForSelector:selector];
                void (*func)(id, SEL, id, NSNumber *) = (void *)imp;
                func(controller, selector, targetID, @(praiseState));
            }
        }
    }];
}

#pragma mark ------动态的评论

#pragma mark ------动态的删除
+ (void)registerDeleteClass:(Class)CClass method:(SEL)selector
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:NSStringFromClass(CClass) forKey:NSStringFromSelector(selector)];
    [[SHGGlobleOperation sharedGloble].deleteArray insertUniqueObject:dictionary];
}

+ (void)deleteObject:(id)object
{
    void(^block)(void) = ^() {
        [Hud showWait];
        NSString *targetID = @"";
        NSString *targetUserID = @"";
        if ([object isKindOfClass:[CircleListObj class]]) {
            CircleListObj *circleListObject = (CircleListObj *)object;
            targetID = circleListObject.rid;
            targetUserID = circleListObject.userid;
        }

        NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
        NSDictionary *dic = @{@"rid":targetID, @"uid":targetUserID};

        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:dic success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                [Hud showMessageWithText:@"删除成功"];
                [MobClick event:@"ActionDeletepost" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] deleteObjectSuccess:targetID];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    };
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alert.rightBlock = block;
    [alert show];

}

- (void)deleteObjectSuccess:(NSString *)targetID
{
    UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    NSMutableArray *controllerArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    [controllerArray addObjectsFromArray:[TabBarViewController tabBar].viewControllers];
    [self.deleteArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString([dictionary.allValues firstObject]);
        SEL selector = NSSelectorFromString([dictionary.allKeys firstObject]);
        for (UIViewController *controller in controllerArray) {
            if ([controller isKindOfClass:class]) {
                IMP imp = [controller methodForSelector:selector];
                void (*func)(id, SEL, id) = (void *)imp;
                func(controller, selector, targetID);
            }
        }
    }];
}

#pragma mark ---动态列表收藏---

+ (void)registerCollectClass:(Class)CClass method:(SEL)selector
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:NSStringFromClass(CClass) forKey:NSStringFromSelector(selector)];
    [[SHGGlobleOperation sharedGloble].collectionArray insertUniqueObject:dictionary];
}

+ (void)collectObject:(id)object
{
    [Hud showWait];
    NSString *targetID = @"";
    BOOL collectionState = NO;
    if ([object isKindOfClass:[CircleListObj class]]) {
        CircleListObj *circleListObject = (CircleListObj *)object;
        targetID = circleListObject.rid;
        collectionState = [circleListObject.iscollection isEqualToString:@"Y"];
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circlestore"];
    NSDictionary *param = @{@"uid":UID, @"rid":targetID};
    if (!collectionState){
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                [Hud showMessageWithText:@"收藏成功"];
                [MobClick event:@"ActionCollection_On" label:@"onClick"];
                [[SHGGlobleOperation sharedGloble] addcollectState:targetID collectState:YES];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        
        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                [MobClick event:@"ActionCollection_Off" label:@"onClick"];
                [Hud showMessageWithText:@"取消收藏"];
                [[SHGGlobleOperation sharedGloble] addcollectState:targetID collectState:NO];
            }
            
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }

}

- (void)addcollectState:(NSString *)targetID collectState:(BOOL)collectState
{
    UINavigationController *nav = (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    NSMutableArray *controllerArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    [controllerArray addObjectsFromArray:[TabBarViewController tabBar].viewControllers];
    [self.collectionArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString([dictionary.allValues firstObject]);
        SEL selector = NSSelectorFromString([dictionary.allKeys firstObject]);
        for (UIViewController *controller in controllerArray) {
            if ([controller isKindOfClass:class]) {
                IMP imp = [controller methodForSelector:selector];
                void (*func)(id, SEL, id, NSNumber *) = (void *)imp;
                func(controller, selector, targetID, @(collectState));
            }
        }
    }];
}
@end

