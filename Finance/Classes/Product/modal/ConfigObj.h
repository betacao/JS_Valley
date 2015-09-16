//
//  ConfigObj.h
//  Finance
//
//  Created by HuMin on 15/5/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigObj : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong)NSString *nine;
@property (nonatomic, strong)NSString *six;
@property (nonatomic, strong)NSString *three;
@property (nonatomic, strong)NSString *twelve;

@end
