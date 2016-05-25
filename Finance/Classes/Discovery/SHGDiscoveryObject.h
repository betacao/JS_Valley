//
//  SHGDiscoveryObject.h
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGDiscoveryObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *industryNum;
@property (strong, nonatomic) NSString *industryName;
@property (strong, nonatomic) UIImage *industryImage;

@end

@interface SHGDiscoveryIndustryObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *module;
@property (strong, nonatomic) NSString *counts;
@property (strong, nonatomic) NSString *moduleName;

@end
