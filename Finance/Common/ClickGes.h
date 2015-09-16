//
//  ClickGes.h
//  Finance
//
//  Created by HuMin on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DirectionUnknown = 0,
    DirectionLeft,
    DirectionRight
} Direction;

@interface ClickGes : UILongPressGestureRecognizer

@property (strong,nonatomic) NSArray *action;

@property (assign) int tickleCount;
@property (assign) CGPoint curTickleStart;
@property (assign) Direction lastDirection;

@end
