//
//  HZQDatePickerView.m
//  HZQDatePickerView
//
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import "SHGDatePickerView.h"

@interface SHGDatePickerView ()

@property (nonatomic, strong) NSString *selectDate;

@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backgVIew;

@end

@implementation SHGDatePickerView

+ (SHGDatePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SHGDatePickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib
{
    /** 确定 */
    self.sureBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -CGRectGetWidth(self.cannelBtn.frame) / 3.0f);
    /** 取消 */
    self.cannelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0f, -CGRectGetWidth(self.cannelBtn.frame) / 3.0f, 0.0f, 0.0f);
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];

}

- (IBAction)removeBtnClick:(id)sender {
    // 开始动画
//    [self animationbegin:sender];

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.alpha = 1.0f;
        [self removeFromSuperview];
    }];
}

- (IBAction)sureBtnClick:(id)sender {
    // 开始动画
//    [self animationbegin:sender];

    self.selectDate = [self timeFormat];
    
    //delegate
    [self.delegate getSelectDate:self.selectDate type:self.type];
    
    
    [self removeBtnClick:nil];
}

@end
