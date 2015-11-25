//
//  SHGActionSignViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGActionObject.h"

@protocol SHGActionSignControllerDelegate <NSObject>

- (void)didChangePraiseState:(SHGActionObject *)object isPraise:(BOOL)isPraise;

@end
typedef void (^SHGActionSignViewControllerLoadFinishBlock)(CGFloat height);
@interface SHGActionSignViewController : BaseViewController

@property (strong, nonatomic) SHGActionObject *object;
@property (copy, nonatomic) SHGActionSignViewControllerLoadFinishBlock finishBlock;
@property (weak, nonatomic) UIViewController *superController;
@property (assign, nonatomic) id<SHGActionSignControllerDelegate> delegate;
- (CGFloat) heightForView;
- (void)refreshUI;
- (void)reloadData;
@end
