//
//  SHGBusinessObject.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGBusinessObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *browseNum;
@property (strong, nonatomic) NSString *modifyNum;
@property (strong, nonatomic) NSString *businessShow;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *businessID;
@property (strong, nonatomic) NSString *modifyTime;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *anonymous;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *bondType;
@property (strong, nonatomic) NSString *clarifyingWay;
@property (strong, nonatomic) NSString *contact;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *fundUsetime;
@property (strong, nonatomic) NSString *highestRate;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *investAmount;
@property (strong, nonatomic) NSString *investModel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *photo;
//资金方
@property (strong, nonatomic) NSString *businessType;
@property (strong, nonatomic) NSString *clarifyingRequire;
@property (strong, nonatomic) NSString *lowestPaybackRate;
@property (strong, nonatomic) NSString *financingStage;
@property (strong, nonatomic) NSString *fundSource;
@property (strong, nonatomic) NSString *moneysideType;
@property (strong, nonatomic) NSString *totalshareRate;
@property (strong, nonatomic) NSString *vestYears;

@end

@interface SHGBusinessFirstObject : NSObject

@property (strong, nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

@interface SHGBusinessSecondObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *subArray;

@end

@interface SHGBusinessSecondsubObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *value;
@end

