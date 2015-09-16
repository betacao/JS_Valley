//
//  LoginObj.h
//  Finance
//
//  Created by HuMin on 15/4/23.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginObj : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString *state;

@end
