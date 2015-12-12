//
//  SHGMarketObject.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGMarketObject : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *marketName;
@property (strong, nonatomic) NSString *marketId;
@property (strong, nonatomic) NSString *contactInfo;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *createBy;
@property (strong, nonatomic) NSString *praiseNum;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *shareNum;
@property (strong, nonatomic) NSString *friendShip;
@property (strong, nonatomic) NSString *catalog;
@property (strong, nonatomic) NSString *firstcatalog;
@property (strong, nonatomic) NSString *secondcatalog;
@property (strong, nonatomic) NSString *firstcatalogid;
@property (strong, nonatomic) NSString *secondcatalogid;
@property (strong, nonatomic) NSString *isPraise;
@property (strong, nonatomic) NSString *position;
@end



@interface SHGMarketSecondCategoryObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *rowId;
@property (strong, nonatomic) NSString *catalogName;
@end

@interface SHGMarketFirstCategoryObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *firstCatalogId;
@property (strong, nonatomic) NSString *firstCatalogName;
@property (strong, nonatomic) NSArray *secondCataLogs;
@end