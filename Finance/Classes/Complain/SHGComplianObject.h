//
//  SHGComplianObject.h
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGComplianObject : MTLModel<MTLJSONSerializing>

@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *complainID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *modifyNum;
@property(nonatomic, strong) NSString *isDeleted;
@property(nonatomic, strong) NSString *businessType;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *complainAuditstate;
@property(nonatomic, strong) NSArray *urlArray;

@end
