//
//  DDTapGestureRecognizer.h
//  DingDCommunity
//
//  Created by HuMin on 15/1/29.
//  Copyright (c) 2015年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, assign) NSInteger tag;

@end
