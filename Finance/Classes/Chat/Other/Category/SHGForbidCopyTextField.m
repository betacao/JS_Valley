//
//  ForbidCopyTextField.m
//  Finance
//
//  Created by weiqiankun on 16/8/3.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGForbidCopyTextField.h"

@implementation SHGForbidCopyTextField

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cut:)){
        if (self.text.length > 0) {
            return YES;
        } else{
            return NO;
        }
    } else if(action == @selector(copy:)){
        if (self.text.length > 0) {
            return YES;
        } else{
            return NO;
        }
    } else if(action == @selector(paste:)){
        
        return NO;
        
    } else if(action == @selector(select:)){
        if (self.text.length > 0) {
            return YES;
        } else{
            return NO;
        }
    } else if(action == @selector(selectAll:)){
        if (self.text.length > 0) {
            return YES;
        } else{
            return NO;
        }
    } else{
        
        return NO;
        
    }
    
}

@end
