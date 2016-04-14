//
//  SHGBusinessNoticeTableViewCell.h
//  Finance
//
//  Created by changxicao on 16/4/13.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessObject.h"

#define kImageTableViewCellHeight 206.0f * SCREENWIDTH / 960.0f

@interface SHGBusinessNoticeTableViewCell : UITableViewCell

@end

@interface SHGBusinessImageTableViewCell : SHGBusinessNoticeTableViewCell

@property (strong ,nonatomic) NSString *tipUrl;

@end


@interface SHGBusinessLabelTableViewCell : SHGBusinessNoticeTableViewCell

@property (strong, nonatomic) NSString *text;

@end
