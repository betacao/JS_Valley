//
//  WSHHTTPTestModel.h
//  FuelTreasureProject
//
//  Created by 吴仕海 on 4/13/15.
//  Copyright (c) 2015 XiTai. All rights reserved.
//

#import "MTLModel.h"

@interface WSHHTTPTestModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *testModelProperty;

@end
