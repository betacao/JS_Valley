//
//  ProductListTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProductListTableViewCell.h"
@interface ProductListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblCommisionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCommision;
@property (weak, nonatomic) IBOutlet UILabel *lblRIght2;
@property (weak, nonatomic) IBOutlet UILabel *lblRight1;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft2;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft1;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imageIshot;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIView *verticaLine;


@end

@implementation ProductListTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    [self initView];
    [self addSdLayout];
    
}

- (void)initView
{
    self.lblName.font = [UIFont boldSystemFontOfSize:16.0f];
    self.lblName.textColor =[UIColor colorWithHexString:@"333333"];
    
    self.lblLeft1.font = FontFactor(15.0f);
    self.lblLeft1.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.lblLeft2.font = FontFactor(15.0f);
    self.lblLeft2.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.lblRight1.font = FontFactor(15.0f);
    self.lblRight1.textColor = [UIColor colorWithHexString:@"333333"];
  
    self.lblRIght2.font = FontFactor(15.0f);
    self.lblRIght2.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.lblCommisionNameLabel.font = FontFactor(13.0f);
    self.lblCommisionNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.lblCommisionNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lblCommision.font = FontFactor(13.0f);
    self.lblCommision.textColor = [UIColor colorWithHexString:@"d82626"];
    self.lblCommision.textAlignment = NSTextAlignmentCenter;
    
    self.verticaLine.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.horizontalLine.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    
}

- (void)addSdLayout
{
    self.lblName.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(20.0f))
    .autoHeightRatio(0.0f);
    [self.lblName setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"热门图标.png"];
    CGSize size = image.size;
    self.imageIshot.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.lblLeft1.sd_layout
    .leftEqualToView(self.lblName)
    .topSpaceToView(self.lblName, MarginFactor(15.0f))
    .widthIs(MarginFactor(170.0f))
    .autoHeightRatio(0.0f);
    
    self.lblLeft2.sd_layout
    .leftEqualToView(self.lblLeft1)
    .topSpaceToView(self.lblLeft1, MarginFactor(20.0f))
    .widthRatioToView(self.lblLeft1,1.0f)
    .autoHeightRatio(0.0f);
    
    self.verticaLine.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(91.0f))
    .topEqualToView(self.lblLeft1)
    .bottomEqualToView(self.lblLeft2)
    .widthIs(0.5f);
    
    self.lblRight1.sd_layout
    .leftSpaceToView(self.lblLeft1, MarginFactor(7.0f))
    .rightSpaceToView(self.verticaLine, MarginFactor(7.0f))
    .topEqualToView(self.lblLeft1)
    .heightRatioToView(self.lblLeft1, 1.0f);
    
    self.lblRIght2.sd_layout
    .leftSpaceToView(self.lblLeft2, MarginFactor(7.0f))
    .rightSpaceToView(self.verticaLine, MarginFactor(7.0f))
    .topEqualToView(self.lblLeft2)
    .heightRatioToView(self.lblLeft2, 1.0f);
    
    self.lblCommisionNameLabel.sd_layout
    .leftSpaceToView(self.verticaLine, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topEqualToView(self.lblRight1)
    .heightRatioToView(self.lblRight1, 1.0f);
    
    self.lblCommision.sd_layout
    .leftEqualToView(self.lblCommisionNameLabel)
    .rightEqualToView(self.lblCommisionNameLabel)
    .bottomEqualToView(self.lblRIght2)
    .heightRatioToView(self.lblRIght2, 1.0f);
    
    self.horizontalLine.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);
}

-(void)setObject:(ProdListObj *)object
{
    _object = object;
    self.imageIshot.hidden = ![object.isHot boolValue];
    self.lblCommisionNameLabel.text = @"返佣费率";
    [self.lblCommisionNameLabel sizeToFit];
    self.lblName.text = object.name;
    [self.lblName sizeToFit];
    self.lblLeft1.text = object.left1;
    self.lblLeft2.text = object.left2;
    self.lblRight1.text = object.right1;
    [self.lblRight1 sizeToFit];
    self.lblRIght2.text = object.right2;
    [self.lblRIght2 sizeToFit];
    
    if (!IsStrEmpty(object.commision)){
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHSTATE];
        if (![state boolValue]) {
            self.lblCommision.text = @"认证可见";
        } else{
            self.lblCommision.text = [NSString stringWithFormat:@"%@%@",object.commision,@"%"];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
