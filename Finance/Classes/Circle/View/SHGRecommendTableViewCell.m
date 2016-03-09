//
//  SHGRecommendTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendTableViewCell.h"
#import "RecmdFriendObj.h"

@interface SHGRecommendTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (strong, nonatomic) NSMutableArray *viewArray;
@end

@implementation SHGRecommendTableViewCell

- (void)awakeFromNib
{
    self.viewArray = [NSMutableArray array];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    UIImage *image = [UIImage imageNamed:@"recomendFriend"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 145.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.topImageView.image = image;
    self.splitView.backgroundColor = kMainSplitLineColor;
}

- (void)addAutoLayout
{
    UIImage *image = [UIImage imageNamed:@"recomendFriend"];
    CGSize size = image.size;
    self.topImageView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(size.height);

}

- (void)setObjectArray:(NSArray *)objectArray
{
    _objectArray = objectArray;
    for (RecmdFriendObj *object in objectArray) {
        NSInteger index = [objectArray indexOfObject:object];
        UIView *contentView = nil;
        SHGUserHeaderView *header = nil;
        UILabel *nameLabel = nil;
        UILabel *companyLabel = nil;
        UILabel *departmentLabel = nil;
        UILabel *detailLabel = nil;
        UIButton *button = nil;
        UIView *lineView = nil;
        if (self.viewArray.count <= index) {
            contentView = [[UIView alloc] init];
            [self.contentView addSubview:contentView];

            header = [[SHGUserHeaderView alloc] init];
            header.tag = 101;

            nameLabel = [[UILabel alloc] init];
            nameLabel.tag = 102;

            companyLabel = [[UILabel alloc] init];
            companyLabel.tag = 103;

            departmentLabel = [[UILabel alloc] init];
            departmentLabel.tag = 104;

            detailLabel = [[UILabel alloc] init];
            detailLabel.tag = 105;

            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 106;

            [button addTarget:self action:@selector(didClickFocusButton:) forControlEvents:UIControlEventTouchUpInside];
            lineView = [[UIView alloc] init];
            lineView.tag = 107;

            [contentView addSubview:header];
            [contentView addSubview:nameLabel];
            [contentView addSubview:companyLabel];
            [contentView addSubview:departmentLabel];
            [contentView addSubview:detailLabel];
            [contentView addSubview:button];
            [contentView addSubview:lineView];

            [self addSubviewsLayout:contentView header:header nameLabel:nameLabel companyLabel:companyLabel departmentLabel:departmentLabel detailLabel:detailLabel button:button lineView:lineView];

            [self.viewArray addObject:contentView];
        } else{
            contentView = [self.viewArray objectAtIndex:index];
            header = [contentView viewWithTag:101];
            nameLabel = [contentView viewWithTag:102];
            companyLabel = [contentView viewWithTag:103];
            departmentLabel = [contentView viewWithTag:104];
            detailLabel = [contentView viewWithTag:105];
            button = [contentView viewWithTag:106];
            lineView = [contentView viewWithTag:107];
        }

        [header updateHeaderView:object.headimg placeholderImage:[UIImage imageNamed:@"default_head"]];
        nameLabel.text = object.username;
        NSString *company = object.company;
        if (company.length > 6) {
            company = [company substringToIndex:6];
            company = [NSString stringWithFormat:@"%@…",company];
        }
        companyLabel.text = company;

        NSString *department = object.title;
        if (department.length > 4) {
            department= [department substringToIndex:4];
            department = [NSString stringWithFormat:@"%@…",department];
        }
        departmentLabel.text = department;

        NSString *flag = object.flag;
        NSString *detailString = @"";
        if([flag isEqualToString: @"city"]){
            detailString = [@"你们都在：" stringByAppendingString:object.area];
        } else if ([flag isEqualToString:@"company"]){
            detailString = [@"你们都在：" stringByAppendingFormat:@"%@",object.company];
        } else{
            detailString = [[NSString stringWithFormat:@"%@",object.recomfri] stringByAppendingString:@"等人也关注了他"];
        }
        detailLabel.text = detailString;

        if(!object.isFocus){
            [button setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
        } else{
            [button setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal];
        }
    }

    self.splitView.sd_layout
    .topSpaceToView([self.viewArray lastObject], -0.5f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(kMainCellLineHeight);

    [self setupAutoHeightWithBottomView:self.splitView bottomMargin:0.0f];
}

- (void)addSubviewsLayout:(UIView *)contentView header:(SHGUserHeaderView *)header nameLabel:(UILabel *)nameLabel companyLabel:(UILabel *)companyLabel departmentLabel:(UILabel *)departmentLabel detailLabel:(UILabel *)detailLabel button:(UIButton *)button lineView:(UIView *)lineView
{
    header.sd_layout
    .topSpaceToView(contentView, MarginFactor(12.0f))
    .leftSpaceToView(contentView, kMainItemLeftMargin)
    .widthIs(kMainHeaderViewWidth)
    .heightIs(kMainHeaderViewHeight);

    nameLabel.sd_layout
    .topEqualToView(header)
    .leftSpaceToView(header, kMainNameToHeaderViewLeftMargin)
    .autoHeightRatio(0.0f);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    detailLabel.sd_layout
    .bottomEqualToView(header)
    .leftEqualToView(nameLabel)
    .autoHeightRatio(0.0f);
    [detailLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    companyLabel.sd_layout
    .bottomEqualToView(nameLabel)
    .leftSpaceToView(nameLabel, kMainCompanyToNameLeftMargin)
    .autoHeightRatio(0.0f);
    [companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    departmentLabel.sd_layout
    .bottomEqualToView(nameLabel)
    .leftSpaceToView(companyLabel, 0.0f)
    .autoHeightRatio(0.0f);
    [departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    UIImage *image = [UIImage imageNamed:@"newAddAttention"];
    button.sd_layout
    .topEqualToView(header)
    .rightSpaceToView(contentView, kMainItemLeftMargin)
    .widthIs(image.size.width)
    .heightIs(image.size.height);


    lineView.sd_layout
    .topSpaceToView(header, MarginFactor(12.0f))
    .rightSpaceToView(contentView, 0.0f)
    .leftEqualToView(header)
    .heightIs(0.5f);

    if ([self.viewArray lastObject]) {
        contentView.sd_layout
        .topSpaceToView([self.viewArray lastObject], 0.0f)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f);
        [contentView setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
    } else{
        contentView.sd_layout
        .topSpaceToView(self.topImageView, 0.0f)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f);
        [contentView setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
    }

    nameLabel.font = kMainNameFont;
    nameLabel.textColor = kMainNameColor;

    companyLabel.font = kMainCompanyFont;
    companyLabel.textColor = kMainCompanyColor;

    departmentLabel.font = kMainCompanyFont;
    departmentLabel.textColor = kMainCompanyColor;

    detailLabel.font = kMainTimeFont;
    detailLabel.textColor = kMainTimeColor;

    lineView.backgroundColor = kMainLineViewColor;
}

- (void)didClickFocusButton:(UIButton *)sender
{
    NSInteger index = [self.viewArray indexOfObject:sender.superview];
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionClicked:)]){
        [self.delegate attentionClicked:[self.objectArray objectAtIndex:index]];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
