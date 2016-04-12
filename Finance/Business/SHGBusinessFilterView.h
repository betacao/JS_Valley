//
//  SHGBusinessFilterView.h
//  Finance
//
//  Created by changxicao on 16/4/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHGBusinessSelectCategoryViewController.h"

@interface SHGBusinessFilterView : UIView

@property (assign, nonatomic) BOOL expand;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) SHGBusinessSelectCategoryBlock selectedBlock;
@end
