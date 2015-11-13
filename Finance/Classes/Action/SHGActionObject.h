//
//  SHGActionObject.h
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SHGActionObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *meetId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *meetArea;
@property (strong, nonatomic) NSString *meetNum;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *meetState;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *attendNum;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *isTimeOut;
@property (strong, nonatomic) NSString *isPraise;

@end
