//
//  DisplayView.h
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/3/31.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTTextStyleModel.h"

@class CTTextDisplayView;

@protocol CTTextDisplayViewDelegate <NSObject>

@optional
- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj;
@end




@interface CTTextDisplayView : UIView

@property (nonatomic,assign) id<CTTextDisplayViewDelegate> delegate;

@property (nonatomic,copy) NSString * text;

@property (nonatomic,strong) CTTextStyleModel * styleModel;

+ (CGFloat)getRowHeightWithText:(NSString *)text rectSize:(CGSize)rectSize styleModel:(CTTextStyleModel *)styleModel;


@end



