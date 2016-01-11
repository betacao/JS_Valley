//
//  DiscoveryTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/5/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)loadDataWithImage:(NSString *)imageName title:(NSString *)title rightItem:(NSString *)itemName rightItemColor:(UIColor *)color;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;

@end
