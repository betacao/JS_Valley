//
//  NSString+Customized.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Customized)

- (NSDate *)dateFromStringFormat:(NSString *)format;
- (NSDate *)dateFromSecondString;
- (NSDate *)dateFromFullString;
- (NSDate *)dateFromShortString;

- (NSString *)validLength;

@end
