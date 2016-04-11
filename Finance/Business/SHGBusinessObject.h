//
//  SHGBusinessObject.h
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGBusinessObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *businessID;
@property (strong, nonatomic) NSString *modifyTime;
@end

@interface SHGBusinessFirstObject : NSObject

@property (strong, nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

@interface SHGBusinessSecondObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *subTitleArray;

@end

