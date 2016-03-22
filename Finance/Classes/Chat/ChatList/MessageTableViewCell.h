//
//  MessageTableViewCell.h
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObj.h"

typedef NS_ENUM(NSInteger, MessageType){
    MessageTypeSystem,
    MessageTypeOX
};

@interface MessageTableViewCell : UITableViewCell

@property (strong, nonatomic) MessageObj *object;

@end
