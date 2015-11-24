//
//  SHGActionSendViewController.h
//  Finance
//
//  Created by changxicao on 15/11/16.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGActionObject.h"

@protocol SHGActionSendDelegate <NSObject>

- (void)didCreateNewAction;

@end

@interface SHGActionSendViewController : BaseViewController

@property (strong, nonatomic) SHGActionObject *object;
@property (assign, nonatomic) id<SHGActionSendDelegate> delegate;

@end
