//
//  SettingQuestionDetailViewController.h
//  DingDCommunity
//
//  Created by haibo li on 14-6-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "BaseViewController.h"
//#import "ChatViewController.h"
@interface SettingQuestionDetailViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextView *txContext;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,weak) NSString *name;

@end
