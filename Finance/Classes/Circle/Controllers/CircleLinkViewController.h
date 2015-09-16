//
//  CircleLinkViewController.h
//  Finance
//
//  Created by HuMin on 15/5/11.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface CircleLinkViewController : BaseTableViewController<UIWebViewDelegate>
@property (nonatomic, strong) NSString *link;
@end
