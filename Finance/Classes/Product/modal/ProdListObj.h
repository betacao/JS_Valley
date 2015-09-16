//
//  ProdListObj.h
//  Finance
//
//  Created by HuMin on 15/4/22.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdListObj : MTLModel<MTLJSONSerializing>


@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *left1;

@property (nonatomic, strong)NSString *left2;

@property (nonatomic, strong)NSString *right1;

@property (nonatomic, strong)NSString *right2;

@property (nonatomic, strong)NSString *commision;

@property (nonatomic, strong)NSString *isHot;
@property (nonatomic, strong)NSString *iscollected;
@property (nonatomic, strong)NSString *pid;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *type;


@end
