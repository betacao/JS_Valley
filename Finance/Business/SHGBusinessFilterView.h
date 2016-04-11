//
//  SHGBusinessFilterView.h
//  Finance
//
//  Created by changxicao on 16/4/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGBusinessFilterView : UIView

@property (assign, nonatomic) BOOL expand;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *firstType;//一级分类的类型
@end
