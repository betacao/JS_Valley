//
//  MyAppointmentTableViewCell.h
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myAppointmentModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *ptype;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *pname;
@property (nonatomic, strong) NSString *crate;
@property (nonatomic, strong) NSString *pstate;

@end

@interface MyAppointmentTableViewCell : UITableViewCell
@property (nonatomic, strong)myAppointmentModel *model;

@end

