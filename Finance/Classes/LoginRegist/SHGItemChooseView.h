//
//  SHGIndustryChoiceView.h
//  Finance
//
//  Created by changxicao on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHGItemChooseDelegate <NSObject>

- (void)didSelectItem:(NSString *)item;

@end

@interface SHGItemChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineNumber:(NSInteger)number;

@property (assign, nonatomic) id<SHGItemChooseDelegate> delegate;

@property (strong, nonatomic) NSArray *dataArray;

@end
