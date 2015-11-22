//
//  SHGActionSignViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGActionObject.h"

typedef void (^SHGActionSignViewControllerLoadFinishBlock)(CGFloat height);
@interface SHGActionSignViewController : BaseViewController

@property (strong, nonatomic) SHGActionObject *object;
@property (copy, nonatomic) SHGActionSignViewControllerLoadFinishBlock finishBlock;
@property (weak, nonatomic) UIViewController *superController;
- (CGFloat) heightForView;
- (void)refreshUI;
@end
