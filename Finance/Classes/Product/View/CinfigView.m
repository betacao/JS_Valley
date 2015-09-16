//
//  CinfigView.m
//  Finance
//
//  Created by HuMin on 15/5/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CinfigView.h"
@interface CinfigView()
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;

@end;

@implementation CinfigView

-(void)configViewWithObj:(ConfigObj *)obj
{
    _lbl1.text = obj.left;
    _lbl2.text = obj.three;
    _lbl3.text = obj.six;

    _lbl4.text = obj.nine;

    _lbl5.text = obj.twelve;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
