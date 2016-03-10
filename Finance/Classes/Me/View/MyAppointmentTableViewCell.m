//
//  MyAppointmentTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyAppointmentTableViewCell.h"
@interface MyAppointmentTableViewCell ()
//股票配资
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *product1Time;
@property (weak, nonatomic) IBOutlet UILabel *product1TimeLeft;
@property (weak, nonatomic) IBOutlet UILabel *product1Name;
@property (weak, nonatomic) IBOutlet UILabel *product1NameLeft;
@property (weak, nonatomic) IBOutlet UILabel *product1Rate;
@property (weak, nonatomic) IBOutlet UILabel *product1RateLeft;
@property (weak, nonatomic) IBOutlet UILabel *product1Status;
@property (weak, nonatomic) IBOutlet UILabel *product1StatusLeft;
@property (weak, nonatomic) IBOutlet UIView *viewLine1;
@property (weak, nonatomic) IBOutlet UILabel *product1Type;
@property (weak, nonatomic) IBOutlet UILabel *product1TypeLeft;


@end

@implementation MyAppointmentTableViewCell

- (void)awakeFromNib
{
    [self initView];
    [self addSdLayout];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.product1TimeLeft.font = FontFactor(15.0f);
    self.product1TimeLeft.textColor = [UIColor colorWithHexString:@"898989"];
    self.product1TypeLeft.font = FontFactor(15.0f);
    self.product1TypeLeft.textColor = [UIColor colorWithHexString:@"898989"];
    self.product1RateLeft.font = FontFactor(15.0f);
    self.product1RateLeft.textColor = [UIColor colorWithHexString:@"898989"];
    self.product1NameLeft.font = FontFactor(15.0f);
    self.product1NameLeft.textColor = [UIColor colorWithHexString:@"898989"];
    
    self.product1StatusLeft.font = FontFactor(15.0f);
    self.product1StatusLeft.textColor = [UIColor colorWithHexString:@"898989"];
    
    self.product1Time.font = FontFactor(15.0f);
    self.product1Time.textColor = [UIColor colorWithHexString:@"161616"];
    self.product1Type.font = FontFactor(15.0f);
    self.product1Type.textColor = [UIColor colorWithHexString:@"161616"];
    self.product1Rate.font = FontFactor(15.0f);
    self.product1Rate.textColor = [UIColor colorWithHexString:@"161616"];
    self.product1Name.font = FontFactor(15.0f);
    self.product1Name.textColor = [UIColor colorWithHexString:@"161616"];

}

- (void)addSdLayout
{
    //left
    self.product1TimeLeft.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(24.0f))
    .topSpaceToView(self.contentView, MarginFactor(40.0f))
    .autoHeightRatio(0.0f);
    [self.product1TimeLeft setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.viewLine1.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.product1TimeLeft, MarginFactor(15.0f))
    .heightIs(0.5f);
    
    self.product1TypeLeft.sd_layout
    .leftEqualToView(self.product1TimeLeft)
    .topSpaceToView(self.viewLine1, MarginFactor(15.0f))
    .autoHeightRatio(0.0f);
    [self.product1TypeLeft setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.product1NameLeft.sd_layout
    .leftEqualToView(self.product1TimeLeft)
    .topSpaceToView(self.product1TypeLeft, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.product1NameLeft setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.product1RateLeft.sd_layout
    .leftEqualToView(self.product1TimeLeft)
    .topSpaceToView(self.product1NameLeft, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.product1RateLeft setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.product1StatusLeft.sd_layout
    .leftEqualToView(self.product1TimeLeft)
    .topSpaceToView(self.product1RateLeft, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.product1StatusLeft setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    //right
    self.product1Time.sd_layout
    .leftSpaceToView(self.product1TimeLeft, MarginFactor(35.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .topEqualToView(self.product1TimeLeft)
    .heightRatioToView(self.product1TimeLeft, 1.0f);
    
    self.product1Type.sd_layout
    .leftEqualToView(self.product1Time)
    .rightEqualToView(self.product1Time)
    .topEqualToView(self.product1TypeLeft)
    .heightRatioToView(self.product1TypeLeft, 1.0f);
    
    self.product1Name.sd_layout
    .leftEqualToView(self.product1Time)
    .rightEqualToView(self.product1Time)
    .topEqualToView(self.product1NameLeft)
    .heightRatioToView(self.product1NameLeft, 1.0f);
    
    self.product1Rate.sd_layout
    .leftEqualToView(self.product1Time)
    .rightEqualToView(self.product1Time)
    .topEqualToView(self.product1RateLeft)
    .heightRatioToView(self.product1RateLeft, 1.0f);

    self.product1Status.sd_layout
    .leftEqualToView(self.product1Time)
    .rightEqualToView(self.product1Time)
    .topEqualToView(self.product1StatusLeft)
    .heightRatioToView(self.product1StatusLeft, 1.0f);
    
    self.backImageView.backgroundColor = [UIColor whiteColor];
    self.backImageView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(20.0f))
    .bottomSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f));
    
    
    [self setupAutoHeightWithBottomView:self.product1Status bottomMargin:MarginFactor(15.0f)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModel:(myAppointmentModel *)model
{
    _model = model;
    self.product1TimeLeft.text = @"预约时间";
    self.product1TypeLeft.text = @"产品类型";
    self.product1NameLeft.text = @"产品名称";
    self.product1RateLeft.text = @"返佣费率";
    self.product1StatusLeft.text = @"状态";
    self.product1Type.text = model.ptype;
    self.product1Time.text = model.time;
    self.product1Name.text = model.pname;
    self.product1Rate.text = [NSString stringWithFormat:@"%@％", model.crate];
    NSString *status = model.pstate;
    if ([status isEqualToString:@"0"]) {
        self.product1Status.text = @"未支付";
        self.product1Status.textColor = [UIColor colorWithHexString:@"d43c33"];
    }else if ([status isEqualToString:@"1"]){
        self.product1Status.text = @"已支付";
        self.product1Status.textColor = [UIColor colorWithHexString:@"4277b2"];
    }else{
        self.product1Status.text = @"";
    }

}

@end

@implementation myAppointmentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"ptype":@"ptype",@"time":@"time",@"pname":@"pname",@"crate":@"crate",@"pstate":@"pstate", };
}


@end