//
//  SHGAreaViewController.h
//  Finance
//
//  Created by changxicao on 15/9/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SHGAreaDelegate <NSObject>
@optional

- (void)didSelectCity:(NSString *)city;
@end

@interface SHGProvincesViewController : UITableViewController
@property (assign, nonatomic) id<SHGAreaDelegate> delegate;
@end

@interface SHGCitysViewController : UITableViewController
@property (assign, nonatomic) id<SHGAreaDelegate> delegate;
@property (strong, nonatomic) NSArray *citys;
@end