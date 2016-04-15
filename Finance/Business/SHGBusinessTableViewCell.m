//
//  SHGBusinessTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessTableViewCell.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessMineViewController.h"

@interface SHGBusinessTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *browseImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *spliteView;

@end

@implementation SHGBusinessTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.titleLabel.textColor = Color(@"161616");
    self.titleLabel.font = FontFactor(15.0f);

    self.firstLabel.textColor = Color(@"898989");
    self.firstLabel.font = FontFactor(13.0f);

    self.secondLabel.textColor = Color(@"898989");
    self.secondLabel.font = FontFactor(13.0f);

    self.thirdLabel.textColor = Color(@"898989");
    self.thirdLabel.font = FontFactor(13.0f);

    self.fourthLabel.textColor = Color(@"898989");
    self.fourthLabel.font = FontFactor(13.0f);

    self.browseLabel.textColor = Color(@"d3d3d3");
    self.browseLabel.font = FontFactor(12.0f);

    self.browseImageView.image = [UIImage imageNamed:@"business_Browse"];

    self.deleteButton.hidden = YES;
    [self.deleteButton setImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];
    [self.deleteButton setEnlargeEdge:20.0f];

    self.lineView.backgroundColor = Color(@"F1F1F0");
    self.spliteView.backgroundColor = Color(@"EFEEEF");
}

- (void)addAutoLayout
{
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(18.0f))
    .heightIs(self.titleLabel.font.lineHeight);

    self.firstLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, MarginFactor(14.0f))
    .heightIs(self.firstLabel.font.lineHeight);
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.thirdLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.firstLabel, MarginFactor(11.0f))
    .heightIs(self.thirdLabel.font.lineHeight);
    [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.browseLabel.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.thirdLabel)
    .heightIs(self.browseLabel.font.lineHeight);
    [self.browseLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.browseImageView.sd_layout
    .rightSpaceToView(self.browseLabel, MarginFactor(5.0f))
    .centerYEqualToView(self.thirdLabel)
    .widthIs(self.browseImageView.image.size.width)
    .heightIs(self.browseImageView.image.size.height);

    self.secondLabel.sd_layout
    .leftSpaceToView(self.contentView, SCREENWIDTH / 2.0f)
    .topEqualToView(self.firstLabel)
    .heightIs(self.secondLabel.font.lineHeight);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.fourthLabel.sd_layout
    .leftEqualToView(self.secondLabel)
    .topEqualToView(self.thirdLabel)
    .heightIs(self.fourthLabel.font.lineHeight);
    [self.fourthLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.deleteButton.sd_layout
    .centerYEqualToView(self.firstLabel)
    .rightEqualToView(self.browseLabel)
    .widthIs(self.deleteButton.currentImage.size.width)
    .heightIs(self.deleteButton.currentImage.size.height);

    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.thirdLabel, MarginFactor(13.0f))
    .heightIs(0.5f);

    self.spliteView.sd_layout
    .leftEqualToView(self.lineView)
    .rightEqualToView(self.lineView)
    .topSpaceToView(self.lineView, 0.0f)
    .heightIs(MarginFactor(10.0f));

    [self setupAutoHeightWithBottomView:self.spliteView bottomMargin:0.0f];
}

- (void)setObject:(SHGBusinessObject *)object
{
    _object = object;

    self.titleLabel.text = object.title;
    self.firstLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.businessShow];

    self.secondLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.investAmount];
    self.thirdLabel.text = [object.area isEqualToString:@""] ? @"全国" : object.area;
    self.fourthLabel.text = object.createTime;
    self.browseLabel.text = object.browseNum;

}

- (void)setStyle:(SHGBusinessTableViewCellStyle)style
{
    _style = style;
    if (style == SHGBusinessTableViewCellStyleMine) {
        self.deleteButton.hidden = NO;
    } else{
        self.deleteButton.hidden = YES;
    }
}

- (IBAction)deleteBusiness:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alertView.rightBlock = ^{
        [SHGBusinessManager deleteBusiness:weakSelf.object success:^(BOOL success) {
            if (success) {
                for (SHGBusinessMineViewController *controller in [SHGBusinessListViewController sharedController].navigationController.viewControllers) {
                    if ([controller isKindOfClass:[SHGBusinessMineViewController class]]) {
                        [controller deleteBusinessWithBusinessID:weakSelf.object.businessID];
                    }
                }
                [[SHGBusinessListViewController sharedController] deleteBusinessWithBusinessID:weakSelf.object.businessID];
            }
        }];
    };
    [alertView show];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
