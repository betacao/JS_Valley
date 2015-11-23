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

@protocol SHGActionSignDelegate <NSObject>

- (void)meetAttend:(SHGActionAttendObject *)object clickCommitButton:(UIButton *)button;
- (void)meetAttend:(SHGActionAttendObject *)object clickRejectButton:(UIButton *)button reason:(NSString *)reason ;

@end

@interface SHGActionSignTableViewCell : UITableViewCell

@property (assign, nonatomic) id<SHGActionSignDelegate> delegate;
- (void)loadCellWithObject:(SHGActionAttendObject *)object;
-(void)loadLastCellLineImage;
@end
