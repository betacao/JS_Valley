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

- (void)setupNeedShowAccessorView:(BOOL)hidden;

@end

@interface SHGGlobleModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL lineViewHidden;
@end