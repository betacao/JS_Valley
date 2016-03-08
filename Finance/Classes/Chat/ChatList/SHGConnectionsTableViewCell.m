//
//  SHGConnectionsTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGConnectionsTableViewCell.h"
#import "headerView.h"

@interface SHGConnectionsTableViewCell()
@property (strong, nonatomic) NSString *uid;
@property (weak, nonatomic) IBOutlet headerView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *invateButton;
@property (weak, nonatomic) IBOutlet UIView *lineLabel;

@end

@implementation SHGConnectionsTableViewCell

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.nameLabel.font = FontFactor(16.0f);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"161616"];


    self.companyLabel.font = FontFactor(14.0f);
    self.companyLabel.textColor = [UIColor colorWithHexString:@"898989"];

    self.stateLabel.font = FontFactor(13.0f);
    self.stateLabel.textColor = [UIColor colorWithHexString:@"4277b2"];

    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
}

- (void)addAutoLayout
{
    self.headerView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(14.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(60.0f))
    .heightEqualToWidth();

    self.nameLabel.sd_layout
    .topEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];


    self.companyLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.stateLabel.sd_layout
    .topEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    UIImage *image = [UIImage imageNamed:@"discovery_invate"];
    CGSize size = image.size;
    self.invateButton.sd_layout
    .rightEqualToView(self.stateLabel)
    .bottomEqualToView(self.companyLabel)
    .widthIs(size.width)
    .heightIs(size.height);

    self.lineLabel.sd_layout
    .leftEqualToView(self.headerView)
    .topSpaceToView(self.headerView, MarginFactor(14.0f))
    .heightIs(0.5f)
    .rightSpaceToView(self.contentView, 0.0f);

    [self setupAutoHeightWithBottomView:self.lineLabel bottomMargin:0.0f];

}

- (void)setObject:(id)object
{
    _object = object;
    [self clearCell];
    NSString *name = @"";
    NSString *company = @"";
    NSString *relaStr = @"";

    if ([object isKindOfClass:[BasePeopleObject class]]) {
        BasePeopleObject *obj = (BasePeopleObject *)object;
        self.uid = obj.uid;
        if (IsStrEmpty(obj.name)){
            name = obj.uid;
        } else{
            name = obj.name;
        }
        company = obj.company;

        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [self.headerView updateStatus:[obj.userstatus isEqualToString:@"true"] ? YES : NO];

        if (self.type == SHGContactTypeFirst){
            if([obj.rela integerValue] == 0){
                relaStr = @"通讯录联系人  大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relaStr = @"";
                }
            } else if ([obj.rela integerValue] == 1){
                relaStr = @"大牛圈用户";
            } else if ([obj.rela integerValue] == 2){
                self.stateLabel.textColor = [UIColor colorWithHexString:@"949494"];
                relaStr = @"通讯录联系人  未加入大牛圈";
                self.invateButton.hidden = NO;
            }
        } else{
            if ([obj.commonfriendnum integerValue ] > 1){
                relaStr = [NSString stringWithFormat:@"%@等%@个共同好友  大牛圈用户",obj.commonfriend,obj.commonfriendnum];
            } else{
                relaStr = [NSString stringWithFormat:@"%@共同好友  大牛圈用户",obj.commonfriend];
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


        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [self.headerView updateStatus:[obj.userstatus isEqualToString:@"true"] ? YES : NO];

        if (self.type == SHGContactTypeFirst){
            if([obj.rela integerValue] == 0){
                relaStr = @"通讯录联系人  大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relaStr = @"";
                }
            } else if ([obj.rela integerValue] == 1){
                relaStr = @"大牛圈用户";
            } else if ([obj.rela integerValue] == 2){
                self.stateLabel.textColor = [UIColor colorWithHexString:@"949494"];
                relaStr = @"通讯录联系人  未加入大牛圈";
                self.invateButton.hidden = NO;
            }
        } else{
            if ([obj.commonfriendnum integerValue ] > 1){
                relaStr = [NSString stringWithFormat:@"%@等%@个共同好友  大牛圈用户",obj.commonfriend,obj.commonfriendnum];
            } else{
                relaStr = [NSString stringWithFormat:@"%@共同好友  大牛圈用户",obj.commonfriend];
                
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

    self.stateLabel.text = relaStr;
    

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
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_ACTION_INVITE_FRIEND object:self.uid];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
