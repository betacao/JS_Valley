//
//  SHGMarketSecondCategoryViewController.h
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

@protocol SHGMarketSecondCategoryViewControllerDelegate <NSObject>

- (void)didUploadUserCategoryTags ;

@end
@interface SHGMarketSecondCategoryViewController : BaseViewController
{
    
}

@property (nonatomic , assign)id<SHGMarketSecondCategoryViewControllerDelegate>delegate;
@end
