//
//  SHGMarketNoticeTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGMarketObject.h"

#define kImageTableViewCellHeight 206.0f * SCREENWIDTH / 960.0f

@interface SHGMarketImageTableViewCell : UITableViewCell

@property (strong ,nonatomic) NSString *tipUrl;

@end


@interface SHGMarketLabelTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *text;

@end