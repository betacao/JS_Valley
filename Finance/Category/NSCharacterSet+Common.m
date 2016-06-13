//
//  NSCharacterSet+Common.m
//  OMNI
//
//  Created by changxicao on 16/6/5.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "NSCharacterSet+Common.h"

@implementation NSCharacterSet (Common)

+ (NSCharacterSet *)formUnionWithArray:(NSArray *)array
{
    NSMutableCharacterSet *set = [[NSMutableCharacterSet alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [set formUnionWithCharacterSet:[NSMutableCharacterSet characterSetWithCharactersInString:obj]];
        }
    }];
    return set;
}

@end
