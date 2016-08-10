//
//  SHGMyComplianObject.h
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGMyComplianObject : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *complainid;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *modifynum;
@property(nonatomic, strong) NSString *isdeleted;
@property(nonatomic, strong) NSString *businesstype;
@property(nonatomic, strong) NSString *createtime;
@property(nonatomic, strong) NSString *complainauditstate;
@property(nonatomic, strong) NSArray *urlArray;
@end
