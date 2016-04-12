//
//  SHGBusinessCategoryContentView.h
//  Finance
//
//  Created by changxicao on 16/4/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHGBusinessButtonShowMode){

    SHGBusinessButtonShowModeMultipleChoice = 0,//完全的多选
    SHGBusinessButtonShowModeSingleChoice = 1,//完全的单选
    SHGBusinessButtonShowModeExclusiveChoice = 2,//排他性选择

};

@interface SHGBusinessButtonContentView : UIView
- (instancetype)initWithMode:(SHGBusinessButtonShowMode)mode;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (assign, nonatomic) NSInteger exclusiveIndex;

- (void)didClickButton:(UIButton *)button;
- (NSMutableArray *)selectedArray;
@end
