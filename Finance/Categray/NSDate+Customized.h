//
//  NSDate+Customized.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDateFormatString @"yyMMddHHmmssSSS"

#define kDateFormatSecond @"yyyy-MM-dd HH:mm:ss"

@interface NSDate (Customized)

- (NSString *)stringFromDateFormat:(NSString *)format;
- (NSString *)fullStringFromDate;
- (NSString *)shortStringFromDate;

@end
