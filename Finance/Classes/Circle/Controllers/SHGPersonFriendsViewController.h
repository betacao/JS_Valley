//
//  SHGPersonFriendsViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SHGPersonFriendsViewController : BaseTableViewController


@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSMutableArray *contactsSource;
-(void)friendStatus: (NSString *)status;
@end
