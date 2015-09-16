//
//  RecommendModel.h
//  Finance
//
//  Created by zhuaijun on 15/8/17.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface RecommendModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *flag;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *area;;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *headImg;
@end
