//
//  MOWHttp.m
//  CommonFramework
//
//  Created by 吴仕海 on 4/3/15.
//  Copyright (c) 2015 408939786@qq.com. All rights reserved.
//

#import "MOWHttp.h"
#import "MOWHttpManager.h"
#import "WSHHTTPTestModel.h"

@implementation MOWHttp

+ (void)test{

    //test
//    [MOWHttpManager postWithURL:ToolActionArea method:NewListMethod parameters:@{@"num":@"10"} success:^(MOCHTTPResponse *response) {
//        
//    } failed:^(MOCHTTPResponse *response) {
//        
//    }];
    
    [MOWHttpManager postWithURL:ToolActionArea method:NewListMethod class:[WSHHTTPTestModel class] parameters:@{@"num":@"10"} success:^(MOCHTTPResponse *response) {
        NSLog(@"success");
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"failed");
    }];
}
//+ (void)test:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
//    
//    //test
//    //    [MOWHttpManager postWithURL:ToolActionArea method:NewListMethod parameters:@{@"num":@"10"} success:^(MOCHTTPResponse *response) {
//    //
//    //    } failed:^(MOCHTTPResponse *response) {
//    //
//    //    }];
//    
//    [MOWHttpManager postWithURL:ToolActionArea method:NewListMethod class:[WSHHTTPTestModel class] parameters:@{@"num":@"10"} success:^(MOCHTTPResponse *response) {
//        NSLog(@"success");
//    } failed:^(MOCHTTPResponse *response) {
//        NSLog(@"failed");
//    }];
//}

@end
