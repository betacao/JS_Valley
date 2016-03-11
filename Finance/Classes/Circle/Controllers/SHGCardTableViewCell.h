//
//  SHGCardTableViewCell.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGCollectCardClass.h"
@interface SHGCardTableViewCell : UITableViewCell
//-(void)loadCardDatasWithObj:(SHGCollectCardClass *)obj;
@property (nonatomic, strong) SHGCollectCardClass *object;
@end
