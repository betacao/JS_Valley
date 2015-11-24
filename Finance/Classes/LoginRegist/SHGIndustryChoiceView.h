//
//  SHGIndustryChoiceView.h
//  Finance
//
//  Created by changxicao on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHGIndustryChoiceDelegate <NSObject>

- (void)didSelectIndustry:(NSString *)industry;

@end

@interface SHGIndustryChoiceView : UIView

@property (assign, nonatomic) id<SHGIndustryChoiceDelegate> delegate;

@end
