//
//  NSObject+Extend.h
//  OMNI
//
//  Created by changxicao on 16/6/7.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)

- (void)performSelectorOnMainThread:(SEL)selector withObjects:(NSArray *)array waitUntilDone:(BOOL)wait;

- (void)performSelector:(SEL)aSelector withObjects:(NSArray *)array afterDelay:(NSTimeInterval)delay;

@end
