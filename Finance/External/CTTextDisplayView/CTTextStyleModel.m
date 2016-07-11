//
//  CTTextRunModel.m
//  CTTextDisplayViewDemo
//
//  Created by LiYeBiao on 16/4/5.
//  Copyright © 2016年 Brown. All rights reserved.
//

#import "CTTextStyleModel.h"

@implementation CTTextStyleModel

- (id)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.highlightBackgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    self.atColor = [UIColor blueColor];
    self.subjectColor = [UIColor blueColor];
    self.keyColor = [UIColor blueColor];
    
    self.emailColor= [UIColor blueColor];

    self.font = kMainContentFont;
    self.faceSize = CGSizeMake(28,28);
    self.tagImgSize = CGSizeMake(14, 14);
    self.faceOffset = 8.0f;
    self.lineSpace = 6.0f;
    self.numberOfLines = 5;
    self.highlightBackgroundRadius = 2;
    self.highlightBackgroundAdjustHeight = 2;
    self.highlightBackgroundOffset = 3;
    self.autoHeight = NO;
    self.urlColor = Color(@"4277B2");
    self.phoneColor = Color(@"4277B2");
    self.textColor = kMainContentColor;
    self.maxLength = NSIntegerMax;
}


@end
