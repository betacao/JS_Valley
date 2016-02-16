//
//  BaseViewController.h
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblCodeStr;
@property (nonatomic, strong) NSString *leftItemImageName;
@property (nonatomic, strong) NSString *leftItemtitleName;

@property (nonatomic, strong) NSString *rightItemImageName;
@property (nonatomic, strong) NSString *rightItemtitleName;

@property (nonatomic, assign) NSInteger upDistance;

- (void)rightItemClick:(id)sender;
@end
