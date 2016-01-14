//
//  ChatListTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/6/6.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "BasePeopleObject.h"
@interface ChatListTableViewCell()
{
    NSString *uid;
}
- (IBAction)actionInvite:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRelate;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet headerView *imageHeader;
@property (weak, nonatomic) IBOutlet UIButton *btninvite;
@property (weak, nonatomic) IBOutlet UIImageView *onceImg;
//特殊的名称放在中间
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;

@end

@implementation ChatListTableViewCell

- (IBAction)actionInvitation:(id)sender
{
    
}

-(void)loadDataWithObject:(SHGPeopleObject *)obj
{
    self.lblName.text = obj.name;
    if ([obj.name isEqualToString:@"大牛助手"]) {
        self.specialNameLabel.hidden = NO;
        self.lblName.hidden = YES;
        self.lblCompany.hidden = YES;
    } else{
        self.specialNameLabel.hidden = YES;
        self.lblName.hidden = NO;
        self.lblCompany.hidden = NO;
    }
    if (IsStrEmpty(obj.name)){
        self.lblName.text = obj.nickname;
    }
    NSString *company = obj.company;
    if(!company || company.length == 0){
        company = @"暂未提供公司信息";
    }
    self.lblCompany.text = company;
    uid = obj.uid;

    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [self.imageHeader updateStatus:[obj.userstatus isEqualToString:@"true"]?YES:NO];

    //    self.onceImg.hidden = NO;
    NSString *relaStr;
    self.btninvite.hidden = YES;
    if (self.type == contactTypeFriend){
        self.onceImg.image = [UIImage imageNamed:@"1度"];
        switch ([obj.rela integerValue]){
            case 0:{
                relaStr = @"通讯录联系人  大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relaStr = @"";
                }
            }
                break;
            case 1:{
                relaStr = @"大牛圈用户";
            }
                break;
            case 2:{
                relaStr = @"通讯录联系人  未加入大牛圈";
                self.btninvite.hidden = NO;
            }
                break;
            default:
                break;
        }

    } else{
        self.onceImg.image = [UIImage imageNamed:@"2度"];
        if ([obj.commonfriendnum integerValue ] > 1){
            relaStr = [NSString stringWithFormat:@"%@等%@个共同好友  大牛圈用户",obj.commonfriend,obj.commonfriendnum];
        } else{
            relaStr = [NSString stringWithFormat:@"%@共同好友  大牛圈用户",obj.commonfriend];

        }
    }
    self.lblRelate.text = relaStr;
}


- (void)loadDataWithobj:(BasePeopleObject *)obj
{
    self.lblName.text = obj.name;
    if ([obj.name isEqualToString:@"大牛助手"]) {
        self.specialNameLabel.hidden = NO;
        self.lblName.hidden = YES;
        self.lblCompany.hidden = YES;
    } else{
        self.specialNameLabel.hidden = YES;
        self.lblName.hidden = NO;
        self.lblCompany.hidden = NO;
    }
    if (IsStrEmpty(obj.name)){
        self.lblName.text = obj.uid;
    }
    NSString *company = obj.company;
    if(!company || company.length == 0){
        company = @"暂未提供公司信息";
    }
    self.lblCompany.text = company;
    uid = obj.uid;
    
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [self.imageHeader updateStatus:[obj.userstatus isEqualToString:@"true"]?YES:NO];
    
//    self.onceImg.hidden = NO;
    NSString *relaStr;
    self.btninvite.hidden = YES;
    if (self.type == contactTypeFriend){
        self.onceImg.image = [UIImage imageNamed:@"1度"];
        switch ([obj.rela integerValue]){
            case 0:{
                relaStr = @"通讯录联系人  大牛圈用户";
                if (IsStrEmpty(obj.rela)){
                    relaStr = @"";
                }
            }
                break;
            case 1:{
                relaStr = @"大牛圈用户";
            }
                break;
            case 2:{
                relaStr = @"通讯录联系人  未加入大牛圈";
                self.btninvite.hidden = NO;
            }
                break;
            default:
                break;
        }

    } else{
        self.onceImg.image = [UIImage imageNamed:@"2度"];
        if ([obj.commonfriendnum integerValue ] > 1){
            relaStr = [NSString stringWithFormat:@"%@等%@个共同好友  大牛圈用户",obj.commonfriend,obj.commonfriendnum];
        } else{
            relaStr = [NSString stringWithFormat:@"%@共同好友  大牛圈用户",obj.commonfriend];

        }
    }
    self.lblRelate.text = relaStr;
}


- (void)awakeFromNib
{
    self.btninvite.layer.masksToBounds = YES;
    UIColor *borderColor = RGBA(180.0f, 180.0f, 180.0f, 0.2f);
    self.btninvite.layer.borderColor = [borderColor CGColor];
    self.btninvite.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)actionInvite:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_ACTION_INVITE_FRIEND object:uid];
}
@end
