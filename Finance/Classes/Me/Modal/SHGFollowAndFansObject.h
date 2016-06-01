//
//  SHGFollowAndFansObject.h
//  Finance
//
//  Created by weiqiankun on 16/6/1.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGFollowAndFansObject : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *headImageUrl;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *updateTime;
@property (nonatomic, strong)NSString *followRelation;
@property (nonatomic, strong)NSString *userstatus;
@end
