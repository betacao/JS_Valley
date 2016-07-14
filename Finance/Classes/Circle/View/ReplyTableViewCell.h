//
//  ReplyTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/5/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListObj.h"
#import "CircleDetailViewController.h"

typedef NS_ENUM(NSInteger, SHGCommentType)
{
    SHGCommentTypeFirst = 0,
    SHGCommentTypeNormal,
    SHGCommentTypeLast,
    SHGCommentTypeOnly
};

@interface ReplyTableViewCell : UITableViewCell

@property (weak, nonatomic) CircleDetailViewController *controller;
@property (strong, nonatomic) NSArray *dataArray;

@end
