//
//  SHGMarketDetailViewController.h
//  Finance
//
//  Created by changxicao on 15/12/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGMarketObject.h"
@protocol SHGMarketAddCommentDelegate <NSObject>

- (void)didCommentAction:(SHGMarketObject *)object;

@end

@interface SHGMarketDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGMarketObject *object;
@property (weak, nonatomic) id<SHGMarketAddCommentDelegate> delegate;
@end
