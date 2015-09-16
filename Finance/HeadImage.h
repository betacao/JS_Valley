//
//  HeadImage.h
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

#import "BasePeopleObject.h"

@interface HeadImage : NSManagedObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * headimg;
@property (nonatomic, retain) NSString * nickname;

+ (NSArray *)queryAll:(NSString *) uid;
+ (void) deleteAll;
+ (NSArray *)queryAll;
+ (void) insertAll:(BasePeopleObject *) hImage;
+ (void)inertWithArr:(NSArray *)arr;
@end
