//
//  SHGMarketObject.h
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHGMarketObject : MTLModel<MTLJSONSerializing>
@property (strong, nonatomic) NSString *firstCatalogId;
@property (strong, nonatomic) NSString *firstCatalogName;
@property (strong, nonatomic) NSString *secondCatalogId;
@property (strong, nonatomic) NSString *secondCatalogName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *marketName;
@property (strong, nonatomic) NSString *contactInfo;
@property (strong, nonatomic) NSString *detail;
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