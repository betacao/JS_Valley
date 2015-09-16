//
//  TwainContactInfo.h
//  Finance
//
//  Created by HuMin on 15/6/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BasePeopleObject.h"
@interface TwainContactInfo : NSManagedObject

+ (NSArray *)queryAll:(NSString *) uid;
+ (void) deleteAll;
+ (NSArray *)queryAll;
+ (void) insertAll:(BasePeopleObject *) hImage;
@end
