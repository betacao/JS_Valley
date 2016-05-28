//
//  SHGRecommendTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendTableViewCell.h"
#import "RecmdFriendObj.h"

#import "SHGPersonalViewController.h"
@interface SHGRecommendTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) UIView *firstContentView;
@property (strong, nonatomic) UIView *secondContentView;
@property (strong, nonatomic) UIView *thirdContentView;
@property (strong, nonatomic) UIView *fourthContentView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *viewArray;
@end

@implementation SHGRecommendTableViewCell

- (UIView *)firstContentView
{
    if (!_firstContentView) {
        _firstContentView = [[UIView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentViewAction:)];
        [_firstContentView addGestureRecognizer:tap];
    }
    return _firstContentView;
}

- (UIView *)secondContentView
{
    if (!_secondContentView) {
        _secondContentView = [[UIView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentViewAction:)];
        [_secondContentView addGestureRecognizer:tap];
    }
    return _secondContentView;
}

- (UIView *)thirdContentView
{
    if (!_thirdContentView) {
        _thirdContentView = [[UIView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentViewAction:)];
        [_thirdContentView addGestureRecognizer:tap];
    }
    return _thirdContentView;
}

- (UIView *)fourthContentView
{
    if (!_fourthContentView) {
        _fourthContentView = [[UIView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentViewAction:)];
        [_fourthContentView addGestureRecognizer:tap];
    }
    return _fourthContentView;
}


- (void)awakeFromNib
{
    self.viewArray = @[self.firstContentView, self.secondContentView, self.thirdContentView, self.fourthContentView];
    [self.contentView sd_addSubviews:self.viewArray];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    UIImage *image = [UIImage imageNamed:@"recomendFriend"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 145.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.topImageView.image = image;
    self.splitView.backgroundColor = kMainSplitLineColor;

    [self.viewArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SHGUserHeaderView *headerView = [[SHGUserHeaderView alloc] init];
        headerView.tag = 101;

        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = 102;

        UILabel *companyLabel = [[UILabel alloc] init];
        companyLabel.tag = 103;

        UILabel *departmentLabel = [[UILabel alloc] init];
        departmentLabel.tag = 104;

        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.tag = 105;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 106;
        [button addTarget:self action:@selector(didClickFocusButton:) forControlEvents:UIControlEventTouchUpInside];

        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 107;

        nameLabel.font = kMainNameFont;
        nameLabel.textColor = kMainNameColor;

        companyLabel.font = kMainCompanyFont;
        companyLabel.textColor = kMainCompanyColor;

        departmentLabel.font = kMainCompanyFont;
        departmentLabel.textColor = kMainCompanyColor;

        detailLabel.font = kMainTimeFont;
        detailLabel.textColor = kMainTimeColor;
        
        lineView.backgroundColor = kMainLineViewColor;

        [obj addSubview:headerView];
        [obj addSubview:nameLabel];
        [obj addSubview:companyLabel];
        [obj addSubview:departmentLabel];
        [obj addSubview:detailLabel];
        [obj addSubview:button];
        [obj addSubview:lineView];
    }];
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

    [self.viewArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {

        UIView *header = [view viewWithTag:101];
        UILabel *nameLabel = [view viewWithTag:102];
        UILabel *companyLabel = [view viewWithTag:103];
        UILabel *departmentLabel = [view viewWithTag:104];
        UILabel *detailLabel = [view viewWithTag:105];
        UIView *button = [view viewWithTag:106];
        UIView *lineView = [view viewWithTag:107];

        header.sd_layout
        .topSpaceToView(view, MarginFactor(12.0f))
        .leftSpaceToView(view, kMainItemLeftMargin)
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
        .rightSpaceToView(view, kMainItemLeftMargin)
        .widthIs(image.size.width)
        .heightIs(image.size.height);
        
        lineView.sd_layout
        .topSpaceToView(header, MarginFactor(12.0f))
        .rightSpaceToView(view, 0.0f)
        .leftEqualToView(header)
        .heightIs(0.5f);

        if ([view isEqual:self.firstContentView]) {
            view.sd_layout
            .topSpaceToView(self.topImageView, 0.0f)
            .leftSpaceToView(self.contentView, 0.0f)
            .rightSpaceToView(self.contentView, 0.0f);
            [view setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
        } else if ([view isEqual:self.secondContentView]) {
            view.sd_layout
            .topSpaceToView(self.firstContentView, 0.0f)
            .leftSpaceToView(self.contentView, 0.0f)
            .rightSpaceToView(self.contentView, 0.0f);
            [view setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
        } else if ([view isEqual:self.thirdContentView]) {
            view.sd_layout
            .topSpaceToView(self.secondContentView, 0.0f)
            .leftSpaceToView(self.contentView, 0.0f)
            .rightSpaceToView(self.contentView, 0.0f);
            [view setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
        } else if ([view isEqual:self.fourthContentView]) {
            view.sd_layout
            .topSpaceToView(self.thirdContentView, 0.0f)
            .leftSpaceToView(self.contentView, 0.0f)
            .rightSpaceToView(self.contentView, 0.0f);
            [view setupAutoHeightWithBottomView:lineView bottomMargin:0.0f];
        }

    }];

}

- (void)setObjectArray:(NSArray *)objectArray
{
    _objectArray = objectArray;
    [self clearCell];
    for (RecmdFriendObj *object in objectArray) {
        NSInteger index = [objectArray indexOfObject:object];
        UIView *view = [self.viewArray objectAtIndex:index];
        view.alpha = 1.0f;
        SHGUserHeaderView *header = [view viewWithTag:101];
        UILabel *nameLabel = [view viewWithTag:102];
        UILabel *companyLabel = [view viewWithTag:103];
        UILabel *departmentLabel = [view viewWithTag:104];
        UILabel *detailLabel = [view viewWithTag:105];
        UIButton *button = [view viewWithTag:106];

        [header updateHeaderView:[rBaseAddressForImage stringByAppendingString: object.headimg] placeholderImage:[UIImage imageNamed:@"default_head"] status:NO userID:object.uid];


        NSString *name = object.username;
        if (object.username.length > 4){
            name = [object.username substringToIndex:4];
            name = [NSString stringWithFormat:@"%@...",name];
        }
        nameLabel.text = name;

        NSString *company = object.company;
        if (company.length > 6) {
            company = [company substringToIndex:6];
            company = [NSString stringWithFormat:@"%@...",company];
        }
        companyLabel.text = company;

        NSString *department = object.title;
        if (department.length > 4) {
            department= [department substringToIndex:4];
            department = [NSString stringWithFormat:@"%@...",department];
        }
        departmentLabel.text = department;

        NSString *flag = object.flag;
        NSString *detailString = @"";
        if([flag isEqualToString: @"city"]){
            detailString = [@"你们都在：" stringByAppendingString:object.area];
        } else if ([flag isEqualToString:@"company"]){
            detailString = [@"你们都在：" stringByAppendingFormat:@"%@",object.company];
        } else if ([flag isEqualToString:@"attention"]){
            detailString = [[NSString stringWithFormat:@"%@",object.recomfri] stringByAppendingFormat:@"等%@人也关注了他",object.commonCount];
        } else if ([flag isEqualToString:@"top"]){
            detailString = @"您行业里最受欢迎的人";
        } else if ([flag isEqualToString:@"vocationcity"]){
            detailString = [NSString stringWithFormat:@"您同地区的%@从业者",object.vocation];
        } else if ([flag isEqualToString:@"gradecity"]){
            detailString = [NSString stringWithFormat:@"您同地区的%@从业者",object.vocation];
        }
        detailLabel.text = [detailString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        if(!object.isFocus){
            [button setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
        } else{
            [button setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal];
        }
    }

    self.splitView.sd_resetLayout
    .topSpaceToView([self.viewArray objectAtIndex:objectArray.count - 1], -0.5f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(kMainCellLineHeight);

    [self setupAutoHeightWithBottomView:self.splitView bottomMargin:0.0f];
}

- (void)tapContentViewAction:(UITapGestureRecognizer *)sender
{
    RecmdFriendObj *object = [self.objectArray objectAtIndex:[self.viewArray indexOfObject:sender.view]];
    self.index = [self.viewArray indexOfObject:sender.view];
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] init];
    controller.userId = object.uid;
    controller.block = ^(NSString *state){
        self.attentionState = state;
    };
    [self.controller.navigationController pushViewController:controller animated:YES];
    
}

- (void)setAttentionState:(NSString *)attentionState
{
    _attentionState = attentionState;
    UIView *view = [self.viewArray objectAtIndex:self.index];
    UIButton *button = [view viewWithTag:106];
    RecmdFriendObj * obj = [self.objectArray objectAtIndex:self.index];
    obj.isFocus = [attentionState boolValue];
    if (obj.isFocus) {
        [button setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
        
    } else{
        [button setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal];
    }

}

- (void)clearCell
{
    [self.viewArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = 0.0f;
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                ((UILabel *)obj).text = @"";
                obj.frame = CGRectZero;
            }
        }];
    }];
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
