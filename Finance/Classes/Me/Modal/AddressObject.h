//
//  AddressObject.h
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *addressDescription;

@end
