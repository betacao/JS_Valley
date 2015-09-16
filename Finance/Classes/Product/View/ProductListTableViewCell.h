//
//  ProductListTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdListObj.h"
@interface ProductListTableViewCell : UITableViewCell
-(void)loadDatasWithObj:(ProdListObj *)obj;

@end
