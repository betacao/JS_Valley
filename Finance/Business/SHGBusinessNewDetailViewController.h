//
//  SHGBusinessNewDetailViewController.h
//  Finance
//
//  Created by weiqiankun on 16/6/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGBusinessObject.h"
#import "SHGDiscoveryViewController.h"
@interface SHGBusinessNewDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGBusinessObject *object;
- (void)didCreateOrModifyBusiness;
@end


@interface SHGBusinessCategoryButton : SHGDiscoveryCategoryButton

@property (strong, nonatomic) id pdfObject;

@end