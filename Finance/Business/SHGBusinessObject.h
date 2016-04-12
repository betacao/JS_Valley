//
//  SHGBusinessObject.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGBusinessObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *businessId;
@property (strong, nonatomic) NSString *modifyTime;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *browseNum;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *modifyNum;
@property (strong, nonatomic) NSString *businessShow;
@property (strong, nonatomic) NSString *investAmount;
@property (strong, nonatomic) NSString *createTime;
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

