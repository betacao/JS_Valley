//
//  HeadImage.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "HeadImage.h"

static NSString * const kUid				= @"uid";
static NSString * const kHeadImg			= @"headimg";
static NSString * const kNickName			= @"nickname";
static NSString * const kRela			= @"rela";
static NSString * const kCompany			= @"company";
static NSString * const kCommonFriend			= @"commonfriend";
static NSString * const kCommonFNum			= @"commonnum";

@implementation HeadImage

@dynamic uid;
@dynamic headimg;
@dynamic nickname;

+ (NSArray *)queryAll:(NSString *) uid
{
    NSArray *array = [HeadImage MR_findByAttribute:kUid withValue:uid];
    return array;
}

+ (NSArray *)queryAll
{
    NSArray *array = [HeadImage MR_findAll];
    return array;
}

+ (void) deleteAll
{
    NSPredicate *userFilter = [NSPredicate predicateWithFormat:@"1 = 1"];
    [HeadImage MR_deleteAllMatchingPredicate:userFilter];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"删除成功!");
    }];
}
+ (void)inertWithArr:(NSArray *)arr
{
    NSArray *user = [HeadImage queryAll];
    for (BasePeopleObject *bObj in arr) {
        
        BOOL hasExsist = NO;
        NSString *uid;
        for (NSManagedObject *obj in user)
        {
            uid  =  [obj valueForKey:@"uid"];
            if ([uid isEqualToString:bObj.uid]) {
                hasExsist = YES;
                break;
            }
        }
        if (!hasExsist) {
            //
            [HeadImage insertAll:bObj];
        }
        
        
        
    }
//    for (BasePeopleObject *obj in arr) {
//    }
}
+ (void)insertAll:(BasePeopleObject *) hImage
{
    HeadImage *hi = [HeadImage MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
    [hi setValue:hImage.uid forKey:kUid];
    [hi setValue:hImage.headImageUrl forKey:kHeadImg];
    [hi setValue:hImage.name forKey:kNickName];
    [hi setValue:hImage.rela forKey:kRela];
    [hi setValue:hImage.company forKey:kCompany];
    [hi setValue:hImage.commonfriend forKey:kCommonFriend];
    [hi setValue:hImage.commonfriendnum forKey:kCommonFNum];

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
