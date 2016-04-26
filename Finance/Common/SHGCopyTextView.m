//
//  SHGCopyTextView.m
//  Finance
//
//  Created by changxicao on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCopyTextView.h"

@implementation SHGCopyTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

@end
