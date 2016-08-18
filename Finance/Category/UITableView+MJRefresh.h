//
//  UITableView+MJRefresh.h
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (MJRefresh)

- (void)addRefreshHeaderWithTarget:(NSObject *)target;

- (void)addRefreshFooterrWithTarget:(NSObject *)target;

@end
