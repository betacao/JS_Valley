//
//  SHGBusinessDelegate.h
//  Finance
//
//  Created by weiqiankun on 16/4/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

@protocol SHGBusinessDelegate <NSObject>

- (void)didCreateNewBusiness:(SHGBusinessObject *)object;
- (void)didModifyBusiness:(SHGBusinessObject *)object;

@end
