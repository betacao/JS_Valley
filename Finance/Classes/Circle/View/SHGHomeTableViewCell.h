//
//  SHGHomeTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/4/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleLinkViewController.h"
#import "CircleListDelegate.h"


@interface SHGHomeTableViewCell : UITableViewCell
@property (nonatomic , assign ) NSInteger index;
@property (nonatomic, weak) id<CircleListDelegate> delegate;
-(void)loadDatasWithObj:(CircleListObj *)obj;

@end

