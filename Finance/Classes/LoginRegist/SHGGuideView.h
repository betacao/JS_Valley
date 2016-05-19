//
//  SHGGuideView.h
//  Finance
//
//  Created by changxicao on 16/5/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHGGuideViewBlock)();

@interface SHGGuideView : UIView

@property (copy, nonatomic) SHGGuideViewBlock block;

@end