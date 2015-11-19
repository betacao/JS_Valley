//
//  SGHActionSignTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGActionObject.h"
#define kActionSignCellHeight 54.0f

@interface SHGActionSignTableViewCell : UITableViewCell

- (void)loadCellWithDictionary:(NSDictionary *)dictionary;

@end
