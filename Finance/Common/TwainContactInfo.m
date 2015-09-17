//
//  TwainContactInfo.m
//  Finance
//
//  Created by HuMin on 15/6/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "TwainContactInfo.h"
static NSString * const kUid				= @"uid";
static NSString * const kHeadImg			= @"headimg";
static NSString * const kNickName			= @"nickname";
static NSString * const kRela               = @"rela";
static NSString * const kCompany			= @"company";
static NSString * const kCommonFriend		= @"commonfriend";
static NSString * const kCommonFNum			= @"commonnum";

@implementation TwainContactInfo

+ (NSArray *)queryAll:(NSString *) uid
{
    NSArray *array = [TwainContactInfo MR_findByAttribute:kUid withValue:uid];
    return array;
}

+ (NSArray *)queryAll
{
    NSArray *array = [TwainContactInfo MR_findAll];
    return array;
}

+ (void) deleteAll
{
//    NSPredicate *userFilter = [NSPredicate predicateWithFormat:@"1 = 1"];
//    [TwainContactInfo MR_deleteAllMatchingPredicate:userFilter];
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        NSLog(@"删除成功!");
//    }];
}

+ (void) insertAll:(BasePeopleObject *) hImage
{
//    TwainContactInfo *hi = [TwainContactInfo MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
//    [hi setValue:hImage.uid forKey:kUid];
//    [hi setValue:hImage.headImageUrl forKey:kHeadImg];
//    [hi setValue:hImage.name forKey:kNickName];
//    [hi setValue:hImage.rela forKey:kRela];
//    [hi setValue:hImage.company forKey:kCompany];
//    [hi setValue:hImage.commonfriend forKey:kCommonFriend];
//    [hi setValue:hImage.commonfriendnum forKey:kCommonFNum];
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        NSLog(@"插入成功!");
//    }];
}
@end
