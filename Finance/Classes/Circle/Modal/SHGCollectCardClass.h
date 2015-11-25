//
//  SHGCollectCardClass.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGCollectCardClass : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSString *headerImageUrl;

@property (nonatomic, strong)NSString *companyName;

@property (nonatomic, strong)NSString *position;

@property (nonatomic, strong)NSString *tags;

@property (nonatomic, strong)NSString *titles;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *collectTime;
@property (nonatomic, strong)NSString *friendShip;




@end
