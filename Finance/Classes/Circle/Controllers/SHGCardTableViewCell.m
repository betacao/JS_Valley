//
//  SHGCardTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGCardTableViewCell.h"
#define kTagViewWidth 45.0f * XFACTOR
#define kTagViewHeight 16.0f * XFACTOR
@interface SHGCardTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *tagViews;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (strong, nonatomic) SHGCollectCardClass *obj;
@end
@implementation SHGCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)loadCardDatasWithObj:(SHGCollectCardClass *)obj
{
    [self clearCell];
    self.obj = obj;
    self.userNameLabel.text = obj.name;
    self.companyLabel.text = obj.companyname;
    self.positionLabel.text = obj.position;
    self.departmentLabel.text = obj.titles;
    self.positionLabel.text = obj.position;
    //判断好友是一度好友还是二度好友
    if ([obj.friendShip isEqualToString:@"一度"]) {
        self.friendImage.image = [UIImage imageNamed:@"first_friend.png"];
    }
    if ([obj.friendShip isEqualToString:@"二度"])
    {
         self.friendImage.image = [UIImage imageNamed:@"second_friend.png"];
    }
    if ([obj.friendShip isEqualToString:@""]) {
         self.friendImage.image = nil;
    }
   
    if (![obj.tags isEqualToString:@""]) {
        NSArray *arry = [obj.tags componentsSeparatedByString:@","];
        [self.tagViews removeAllSubviews];
        [self.tagViews addSubview:[self viewForTags:arry]];
    }
    [self initView];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.headerImageUrl]] placeholderImage:[UIImage imageNamed:@"default_head"]];
  
}

-(void)clearCell
{
    self.userNameLabel.text = @"";
    self.companyLabel.text = @"";
    self.positionLabel.text = @"";
    self.departmentLabel.text = @"";
    self.positionLabel.text = @"";
    self.friendImage.image = nil;
    //self.tagViews = nil;
    //[self.headerImageView sd_setImageWithURL:[NSURL URLWithString:ni placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.headerImageView.image = [UIImage imageNamed:@"default_head"];
}

- (UIView *)viewForTags:(NSArray *)array
{
    
        UIView *view = [[UIView alloc] init];
        for (NSString *model in array){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:model forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithHexString:@"f7514b"]];
            button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            CGRect frame = CGRectMake(0.0f, (CGRectGetHeight(self.tagViews.frame) - kTagViewHeight) / 2.0f, kTagViewWidth, kTagViewHeight);
            frame.origin.x = CGRectGetMaxX(view.frame) + kObjectMargin / 2.0f;
            button.frame = frame;
            frame = view.frame;
            frame.size.width = CGRectGetMaxX(button.frame);
            frame.size.height = CGRectGetMaxY(button.frame);
            view.frame = frame;
            [view addSubview:button];
        }
        return view;
  
   }

- (void)initView
{
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = CGRectGetHeight(self.headerImageView.frame) / 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
