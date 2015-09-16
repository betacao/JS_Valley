//
//  GameObj.h
//  Finance
//
//  Created by lizeng on 15/6/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface GameObj : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

@end
