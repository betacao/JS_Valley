//
//  main.m
//  Finance
//
//  Created by HuMin on 15/4/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
int main(int argc, char * argv[]) {
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        NSArray * arr = [exception callStackSymbols];
        NSString * reason = [exception reason];
        NSString * name = [exception name];
        NSString * url = [NSString stringWithFormat:@"catch捕获\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
        NSString *finale=[NSString stringWithFormat:@"%s:%d %@", __FUNCTION__, __LINE__, url];
        NSLog(@"%@",finale);
    }

//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
}
