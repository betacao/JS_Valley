//
//  ImproveMatiralViewController.h
//  Finance
//
//  Created by Okay Hoo on 15/5/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SHGPersonCategoryViewLoadFinish)();

@interface ImproveMatiralViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSDictionary *rid;
@end

@interface SHGPersonCategoryView : UIView

- (void)updateViewWithArray:(NSArray *)dataArray finishBlock:(SHGPersonCategoryViewLoadFinish)block;
- (NSArray *)userSelectedTags;
@end