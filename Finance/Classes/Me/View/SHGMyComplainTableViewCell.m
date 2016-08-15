//
//  SHGMyComplainTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyComplainTableViewCell.h"

@interface SHGMyComplainTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *centerLineVIew;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *auditStateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *roundImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation SHGMyComplainTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = self.bgView.backgroundColor = Color(@"f7f7f7");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSdLayout];
    [self initView];

}

- (void)addSdLayout
{    
    self.topLineView.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, MarginFactor(43.0f))
    .widthIs(1 / SCALE)
    .heightIs(MarginFactor(24.0f));
    
    self.timeLabel.sd_layout
    .centerXEqualToView(self.topLineView)
    .topSpaceToView(self.topLineView, MarginFactor(10.0f))
    .heightIs(self.timeLabel.font.lineHeight);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"complain_Round"];
    CGSize size = image.size;
    self.roundImage.sd_layout
    .centerXEqualToView(self.timeLabel)
    .topSpaceToView(self.timeLabel, MarginFactor(10.0f))
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.bottomLineView.sd_layout
    .centerXEqualToView(self.topLineView)
    .topSpaceToView(self.roundImage, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .widthIs(1 / SCALE);

    
    self.bgView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(15.0f))
    .leftSpaceToView(self.timeLabel, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f));
    
    self.topImageVIew.sd_layout
    .topSpaceToView(self.bgView, 0.0f)
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .bottomSpaceToView(self.bgView, 0.0f);
    
    
    UIImage *stateImage = [UIImage imageNamed:@"complain_reject"];
    CGSize stateSize = stateImage.size;

    self.titleLabel.sd_layout
    .leftSpaceToView(self.bgView, MarginFactor(15.0f) + MarginFactor(10.0f))
    .rightSpaceToView(self.bgView, MarginFactor(15.0f) + stateSize.width)
    .topSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(30.0f));
    
    self.auditStateImageView.sd_layout
    .rightSpaceToView(self.bgView, MarginFactor(15.0f))
    .centerYEqualToView(self.titleLabel)
    .widthIs(stateSize.width)
    .heightIs(stateSize.height);
    
    self.centerLineVIew.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.bgView, MarginFactor(15.0f))
    .topSpaceToView(self.titleLabel, 0.0f)
    .heightIs(1/SCALE);
    
    self.detailLabel.sd_layout
    .leftSpaceToView(self.bgView, MarginFactor(15.0f) + MarginFactor(10.0f))
    .rightSpaceToView(self.bgView, MarginFactor(15.0f))
    .topSpaceToView(self.centerLineVIew, MarginFactor(13.0f))
    .autoHeightRatio(0.0f);
    
    [self.bgView setupAutoHeightWithBottomView:self.detailLabel bottomMargin:MarginFactor(13.0f)];
    
    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0.0f];
    
}

- (void)initView
{
    self.topLineView.backgroundColor = self.bottomLineView.backgroundColor = Color(@"dadada");
    self.centerLineVIew.backgroundColor = Color(@"e6e7e8");
    self.timeLabel.textColor = Color(@"8d8d8d");
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = FontFactor(12.0f);
    
    self.titleLabel.textColor = Color(@"434343");
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = FontFactor(13.0f);
    
    self.detailLabel.textColor = Color(@"434343");
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = FontFactor(13.0f);
    self.detailLabel.numberOfLines = 3;
    
    self.roundImage.image = [UIImage imageNamed:@"complain_Round"];
    
    UIImage *topImage = [[UIImage imageNamed:@"complain_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(30.0f, 10.0f, 8.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    self.topImageVIew.image = topImage;

}

- (void)setObject:(SHGMyComplianObject *)object
{
    _object = object;
    if ([self.type isEqualToString:@"mine"]) {
        self.titleLabel.hidden = NO;
        self.centerLineVIew.hidden = NO;
        self.auditStateImageView.hidden = NO;
    } else if([self.type isEqualToString:@"other"]){
        self.titleLabel.hidden = YES;
        self.centerLineVIew.hidden = YES;
        self.auditStateImageView.hidden = YES;
        self.detailLabel.sd_resetLayout
        .leftSpaceToView(self.bgView, MarginFactor(15.0f) + MarginFactor(10.0f))
        .rightSpaceToView(self.bgView, MarginFactor(15.0f))
        .topSpaceToView(self.bgView, MarginFactor(13.0f))
        .autoHeightRatio(0.0f);
    
    }
    self.timeLabel.text = object.createtime;
    self.titleLabel.text = object.title;
    self.detailLabel.text = object.content;
    if ([object.complainauditstate isEqualToString:@"0"]) {
        self.auditStateImageView.hidden = YES;
    } else if ([object.complainauditstate isEqualToString:@"1"]){
        self.auditStateImageView.hidden = NO;
        self.auditStateImageView.image = [UIImage imageNamed:@"complain_checked"];
    } else if ([object.complainauditstate isEqualToString:@"9"]){
        self.auditStateImageView.hidden = NO;
        self.auditStateImageView.image = [UIImage imageNamed:@"complain_reject"];
    }

    self.topLineView.hidden = self.firstTopLine;
    self.bottomLineView.hidden = self.lastBottomLine;
    self.roundImage.hidden = self.lastBottomLine;
}

@end
