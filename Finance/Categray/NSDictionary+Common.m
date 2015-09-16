//
//  NSDictionary+Common.m
//  
//
//  Created by 吴仕海 on 4/3/15.
//
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)

- (NSString *)JSONString{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
