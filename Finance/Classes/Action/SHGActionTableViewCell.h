//
//  SHGActionTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGActionObject.h"

@interface SHGActionTableViewCell : UITableViewCell

- (void)loadDataWithObject:(SHGActionObject *)object;

@end
