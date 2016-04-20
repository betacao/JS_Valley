//
//  SHGConnectionsTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGConnectionsTableViewCell.h"

@interface SHGConnectionsTableViewCell()
@property (strong, nonatomic) NSString *uid;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UIButton *invateButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation SHGConnectionsTableViewCell

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.headerView.userInteractionEnabled = NO;
    
    self.nameLabel.font = FontFactor(16.0f);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];

    self.companyLabel.font = FontFactor(14.0f);
    self.companyLabel.textColor = [UIColor colorWithHexString:@"898989"];

    self.relationLabel.font = FontFactor(14.0f);
    self.relationLabel.textColor = [UIColor colorWithHexString:@"898989"];

    self.stateLabel.font = FontFactor(13.0f);
    self.stateLabel.textColor = [UIColor colorWithHexString:@"4277b2"];

    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    [self.invateButton setEnlargeEdge:20.0f];
}

- (void)addAutoLayout
{

    self.headerView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(15.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(60.0f))
    .heightEqualToWidth();

    self.nameLabel.sd_layout
    .topSpaceToView(self.headerView, MarginFactor(2.0f))
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.stateLabel.sd_layout
    .topEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.companyLabel.sd_layout
    .centerYEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.relationLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.relationLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    UIImage *image = [UIImage imageNamed:@"discovery_invate"];
    CGSize size = image.size;
    self.invateButton.sd_layout
    .rightEqualToView(self.stateLabel)
    .bottomEqualToView(self.headerView)
    .widthIs(size.width)
    .heightIs(size.height);

    self.lineView.sd_layout
    .leftEqualToView(self.headerView)
    .topSpaceToView(self.headerView, MarginFactor(14.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);

    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0.0f];

}

- (void)setObject:(id)object
{
    _object = object;
    [self clearCell];
    NSString *name = @"";
    NSString *company = @"";
    NSString *relation = @"";
    NSString *state = @"";
    if ([object isKindOfClass:[BasePeopleObject class]]) {
        BasePeopleObject *obj = (BasePeopleObject *)object;
        self.uid = obj.uid;
        if (IsStrEmpty(obj.name)){
            name = obj.uid;
        } else{
            name = obj.name;
        }
        company = obj.company;

        BOOL status = [obj.userstatus isEqualToString:@"true"] ? YES : NO;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:obj.uid];

        if (self.type == SHGContactTypeFirst){
            if([obj.rela integerValue] == 0){
                relation = @"通讯录联系人";
                state = @"大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relation = @"";
                    state = @"";
                }
            } else if ([obj.rela integerValue] == 1){
                relation = @"相互关注";
                state = @"大牛圈用户";
            } else if ([obj.rela integerValue] == 2){
                relation = @"通讯录联系人";
                state = @"未加入大牛圈";
                self.stateLabel.textColor = [UIColor colorWithHexString:@"949494"];
                self.invateButton.hidden = NO;
            }
        } else{
            if ([obj.commonfriendnum integerValue ] > 1){
                relation = [NSString stringWithFormat:@"%@等%@个共同好友",obj.commonfriend,obj.commonfriendnum];
                state = @"大牛圈用户";
            } else{
                relation = [NSString stringWithFormat:@"%@共同好友",obj.commonfriend];
                state = @"大牛圈用户";
            }
        }
    }
    else if ([object isKindOfClass:[SHGPeopleObject class]]){
        SHGPeopleObject *obj = (SHGPeopleObject *)object;
        self.uid = obj.uid;
        if (IsStrEmpty(obj.name)){
            name = obj.nickname;
        } else{
            name = obj.name;
        }
        company = obj.company;


        BOOL status = [obj.userstatus isEqualToString:@"true"] ? YES : NO;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:obj.uid];

        if (self.type == SHGContactTypeFirst){
            if([obj.rela integerValue] == 0){
                relation = @"通讯录联系人";
                state = @"大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relation = @"";
                    state = @"";
                }
            } else if ([obj.rela integerValue] == 1){
                relation = @"相互关注";
                state = @"大牛圈用户";
            } else if ([obj.rela integerValue] == 2){
                relation = @"通讯录联系人";
                state = @"未加入大牛圈";
                self.stateLabel.textColor = [UIColor colorWithHexString:@"949494"];
                self.invateButton.hidden = NO;
            }
        } else{
            if ([obj.commonfriendnum integerValue ] > 1){
                relation = [NSString stringWithFormat:@"%@等%@个共同好友",obj.commonfriend,obj.commonfriendnum];
                state = @"大牛圈用户";
            } else{
                relation = [NSString stringWithFormat:@"%@共同好友",obj.commonfriend];
                state = @"大牛圈用户";
            }
        }
    }

    if ([name isEqualToString:@"大牛助手"]) {
        self.companyLabel.hidden = YES;

        self.nameLabel.sd_resetLayout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.headerView, MarginFactor(10.0f))
        .autoHeightRatio(0.0f);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    } else{
        self.nameLabel.sd_resetLayout
        .topEqualToView(self.headerView)
        .leftSpaceToView(self.headerView, MarginFactor(10.0f))
        .autoHeightRatio(0.0f);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    }
    self.nameLabel.text = name;

    if(!company || company.length == 0){
        company = @"暂未提供公司信息";
    }
    self.companyLabel.text = company;

    self.relationLabel.text = relation;

    self.stateLabel.text = state;
    

}

- (void)clearCell
{
    self.companyLabel.hidden = NO;
    self.nameLabel.frame = CGRectZero;
    self.companyLabel.frame = CGRectZero;
    self.stateLabel.frame = CGRectZero;
    self.stateLabel.textColor = [UIColor colorWithHexString:@"4277b2"];
    self.invateButton.hidden = YES;
}

- (IBAction)actionInvite:(id)sender
{
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈--金融业务互助平台！这里有业务互助、人脉嫁接！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];

    [[AppDelegate currentAppdelegate] sendSmsWithText:content rid:self.uid];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
