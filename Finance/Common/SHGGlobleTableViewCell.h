//
//  SHGGlobleTableViewCell.h
//  Finance
//
//  Created by weiqiankun on 16/1/21.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHGGlobleModel;

@interface SHGGlobleTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGGlobleModel *model;

@end

@interface SHGGlobleModel : NSObject

@property (strong, nonatomic) NSString *text;

@end