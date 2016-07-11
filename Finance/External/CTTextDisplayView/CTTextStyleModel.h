//
//  CTTextRunModel.h
//  CTTextDisplayViewDemo
//
//  Created by LiYeBiao on 16/4/5.
//  Copyright © 2016年 Brown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTTextStyleModel : NSObject

@property (nonatomic,strong) UIColor * textColor;     //文本颜色

@property (nonatomic,strong) UIFont * font;
@property (nonatomic,assign) CGFloat fontSpace;       //字间隔
@property (nonatomic,assign) CGSize faceSize;         //表情尺寸(长宽相等)
@property (nonatomic,assign) CGFloat faceOffset;      //表情偏移

@property (nonatomic,assign) CGSize tagImgSize;       //标签图片尺寸

@property (nonatomic,assign) CGFloat lineSpace;       //行间隔
@property (nonatomic,assign) NSInteger numberOfLines;   //默认为-1(<0为不限制行数)

@property (nonatomic,assign) BOOL urlUnderLine;       //url下划线
@property (nonatomic,assign) BOOL emailUnderLine;     //email下划线
@property (nonatomic,assign) BOOL phoneUnderLine;     //phone下划线

@property (nonatomic,assign) CGFloat highlightBackgroundRadius;   //高亮圆角
@property (nonatomic,strong) UIColor * highlightBackgroundColor;  //高亮背景颜色
@property (nonatomic,assign) CGFloat highlightBackgroundOffset;   //高亮背景偏移
@property (nonatomic,assign) CGFloat highlightBackgroundAdjustHeight;   //高亮背景高度调整

@property (nonatomic, assign) NSInteger maxLength;

@property (nonatomic,assign,getter=isAutoHeight) BOOL autoHeight;  //是否自动计算并调整高度()，如果打开，效率将降低一丢丢儿

@property (nonatomic,strong) UIColor * atColor;           //@
@property (nonatomic,strong) UIColor * subjectColor;      //#
@property (nonatomic,strong) UIColor * keyColor;          //$
@property (nonatomic,strong) UIColor * urlColor;          //U

@property (nonatomic,strong) UIColor * emailColor;        //E
@property (nonatomic,strong) UIColor * phoneColor;        //P

@end
