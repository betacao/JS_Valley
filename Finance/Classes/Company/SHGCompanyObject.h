//
//  SHGCompanyObject.h
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGCompanyObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *companyID;
@property (strong, nonatomic) NSString *companyName;

@end

