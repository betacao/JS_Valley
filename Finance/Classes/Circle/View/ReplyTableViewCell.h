//
//  ReplyTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/5/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListObj.h"
@protocol ReplyDelegate<NSObject>

-(void)cnickClick:(NSInteger)index;
-(void)rnickClick:(NSInteger)index;

@end
@interface ReplyTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger index;

@property (nonatomic,weak)id<ReplyDelegate> delegate;
-(void)loadUIWithObj:(commentOBj  *)comobj;

@end
