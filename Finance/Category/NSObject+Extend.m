//
//  NSObject+Extend.m
//  OMNI
//
//  Created by changxicao on 16/6/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "NSObject+Extend.h"

@implementation NSObject (Extend)

- (void)performSelectorOnMainThread:(SEL)selector withObjects:(NSArray *)array waitUntilDone:(BOOL)wait
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) return;

    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invo setArgument:&obj atIndex:idx + 2];
    }];
    [invo retainArguments];
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

- (void)performSelector:(SEL)aSelector withObjects:(NSArray *)array afterDelay:(NSTimeInterval)delay
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (!sig) return;

    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:aSelector];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invo setArgument:&obj atIndex:idx + 2];
    }];
    [invo retainArguments];
    [invo performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

@end
