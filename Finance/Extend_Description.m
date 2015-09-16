//
//  Extend_Description.m
//  100Data
//
//  Created by Lee on 14-3-14.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "Extend_Description.h"
//#import "NSString+Extensions.h"

@implementation NSDictionary (Extend_Description)
- (NSString *)description
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *query = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return query;
    
}

//+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString
//{
//    NSMutableDictionary* result = [NSMutableDictionary dictionary];
//    NSArray* pairs = [encodedString componentsSeparatedByString:@"&"];
//    
//    for (NSString* kvp in pairs) {
//        if ([kvp length] == 0)
//            continue;
//        
//        NSRange pos = [kvp rangeOfString:@"="];
//        NSString *key;
//        NSString *val;
//        
//        if (pos.location == NSNotFound) {
//            key = [kvp urlEncodedString];
//            val = @"";
//        } else {
//            key = [[kvp substringToIndex:pos.location] urlEncodedString];
//            val = [[kvp substringFromIndex:pos.location + pos.length] urlEncodedString];
//        }
//        
//        if (!key || !val)
//            continue; // I'm sure this will bite my arse one day
//        
//        [result setObject:val forKey:key];
//    }
//    return result;
//}
@end

@implementation NSArray (Extend_Description)
- (NSString *)description
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *query = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return query;
    
}
@end

