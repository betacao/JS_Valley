//
//  SHGPersonalTableViewCell.h
//  Finance
//
//  Created by weiqiankun on 16/3/10.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHGPersonalMode;
@interface SHGPersonalTableViewCell : UITableViewCell

@property (nonatomic, strong) SHGPersonalMode *model;
@end
@interface SHGPersonalMode :  NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *count;
@end