//
//  SHGRecommendCollectionViewCell.m
//  Finance
//
//  Created by changxicao on 16/5/27.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendCollectionViewCell.h"
#import "SHGDiscoveryObject.h"
#import "SHGUserHeaderView.h"

@interface SHGRecommendCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SHGRecommendCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.borderView.layer.borderColor = Color(@"e6e7e8").CGColor;
    self.borderView.layer.borderWidth = 1 / SCALE;

    self.firstLabel.font = FontFactor(12.0f);
    self.firstLabel.textColor = Color(@"626262");

    self.secondLabel.font = FontFactor(15.0f);
    self.secondLabel.textColor = Color(@"1d5798");

    self.thirdLabel.font = FontFactor(12.0f);
    self.thirdLabel.textColor = Color(@"626262");

    self.fourthLabel.font = FontFactor(10.0f);
    self.fourthLabel.textColor = Color(@"a5a5a5");

    [self.button setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAutoLayout
{
    self.borderView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.headerView.sd_layout
    .leftSpaceToView(self.borderView, MarginFactor(7.0f))
    .topSpaceToView(self.borderView, MarginFactor(9.0f))
    .widthIs(MarginFactor(45.0f))
    .heightEqualToWidth(1.0f);

    self.firstLabel.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(7.0f))
    .rightSpaceToView(self.borderView, MarginFactor(14.0f))
    .centerYEqualToView(self.headerView)
    .autoHeightRatio(0.0f);

    self.secondLabel.sd_layout
    .leftEqualToView(self.headerView)
    .rightSpaceToView(self.button, 0.0f)
    .topSpaceToView(self.headerView, MarginFactor(7.0f))
    .heightIs(floorf(self.secondLabel.font.lineHeight));

    self.thirdLabel.sd_layout
    .leftEqualToView(self.headerView)
    .rightEqualToView(self.secondLabel)
    .topSpaceToView(self.secondLabel, MarginFactor(5.0f))
    .heightIs(floorf(self.thirdLabel.font.lineHeight));

    self.fourthLabel.sd_layout
    .leftEqualToView(self.headerView)
    .rightEqualToView(self.secondLabel)
    .topSpaceToView(self.thirdLabel, MarginFactor(7.0f))
    .heightIs(floorf(self.fourthLabel.font.lineHeight));

    self.button.sd_layout
    .bottomEqualToView(self.thirdLabel)
    .rightEqualToView(self.firstLabel)
    .widthIs(self.button.currentImage.size.width)
    .heightIs(self.button.currentImage.size.height);
}

- (void)setObject:(id)object
{
    _object = object;
    if ([object isKindOfClass:[SHGDiscoveryRecommendObject class]]) {
        SHGDiscoveryRecommendObject *recommendObject = (SHGDiscoveryRecommendObject *)object;
        self.firstLabel.text = recommendObject.companyName;
        self.secondLabel.text = recommendObject.realName;
        self.thirdLabel.text = recommendObject.title;
        self.fourthLabel.text = recommendObject.position;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,recommendObject.picName] placeholderImage:[UIImage imageNamed:@"default_head"] status:recommendObject.userStatus userID:recommendObject.userID];
        if (recommendObject.isAttention) {
            [self.button setImage:[UIImage imageNamed:@"me_followed"] forState:UIControlStateNormal];
        } else {
            [self.button setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
        }
    }
}

- (void)buttonClick:(UIButton *)button
{
    [SHGGlobleOperation addAttation:self.object];
}

@end
