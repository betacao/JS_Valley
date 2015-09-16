//
//  GameViewController.h
//  Finance
//
//  Created by lizeng on 15/6/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@interface GameViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *titleName;
+ (BOOL)handleOpenURL:(NSURL *)url wxDelegate:(id)wxDelegate;
@end
