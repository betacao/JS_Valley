//
//  NSString+Customized.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "NSString+Customized.h"

@implementation NSString (Customized)

- (NSDate *)dateFromStringFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromSecondString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromFullString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
   
}

- (NSDate *)dateFromShortString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSString *)validLength
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
