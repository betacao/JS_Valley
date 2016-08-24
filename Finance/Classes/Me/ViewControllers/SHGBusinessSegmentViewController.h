//
//  SHGBusinessSegmentViewController.h
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBaseSegmentViewController.h"

@interface SHGBusinessSegmentViewController : SHGBaseSegmentViewController

- (void)didCreateOrModifyBusiness;
- (void)deleteBusinessWithBusinessID:(NSString *)businessID;
@end
