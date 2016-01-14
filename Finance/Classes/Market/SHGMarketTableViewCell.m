//
//  SHGMarketTableViewCell.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketTableViewCell.h"

@interface SHGMarketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *xuXian;
@property (strong ,nonatomic) SHGMarketObject *object;
@property (strong ,nonatomic) SHGMarketFirstCategoryObject *obj;
@end

@implementation SHGMarketTableViewCell

- (void)awakeFromNib
{
    
}

- (void)loadDataWithObject:(SHGMarketObject *)object type:(SHGMarketTableViewCellType)type
{
    [self clearCell];
    self.object = object;
    self.typeLabel.hidden = NO;
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.xuXian.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.titleView.text = object.marketName;

    if ([UID isEqualToString:object.createBy] && type == SHGMarketTableViewCellTypeMine) {
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        CGRect frame = self.leftView.frame;
        frame.origin.x = CGRectGetMinX(self.rightView.frame) - CGRectGetWidth(frame);
        self.leftView.frame = frame;
    } else{
        self.leftView.hidden = NO;
        CGRect frame = self.leftView.frame;
        frame.origin.x = CGRectGetMinX(self.rightView.frame);
        self.leftView.frame = frame;
    }
    self.typeLabel.text = [@"类型：" stringByAppendingString:object.catalog];
    if (object.price.length == 0) {
        self.amountLabel.text = @"金额：暂未说明";
    } else{
        if (object.price.length > 13) {
            NSString * str = [object.price substringToIndex:13];
            self.amountLabel.text = [@"金额：" stringByAppendingString: str];;
        } else{
            self.amountLabel.text = [@"金额：" stringByAppendingString: object.price];
        }
    }
    
    CGSize capitalSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.amountLabel.frame));
    NSDictionary * capitalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,nil];
    CGSize  capitalActualsize =[self.amountLabel.text boundingRectWithSize:capitalSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:capitalDic context:nil].size;
    if (capitalActualsize.width > 120.f) {
        capitalActualsize.width = 120.f;
    }
    self.amountLabel.frame =CGRectMake(SCREENWIDTH-capitalActualsize.width-15,self.amountLabel.origin.y, capitalActualsize.width, CGRectGetHeight(self.amountLabel.frame));
    self.contactLabel.text = [@"地区：" stringByAppendingString: object.position];
    self.relationLabel.text = object.createTime;
    [self.praiseButton setTitle:object.praiseNum forState:UIControlStateNormal];

    if ([object.isPraise isEqualToString:@"Y"]) {
        [self.praiseButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    } else{
        [self.praiseButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    }

    [self.commentButton setTitle:object.commentNum forState:UIControlStateNormal];

    
}
- (void)loadNewUi
{
    self.typeLabel.hidden = YES;
    self.amountLabel.frame = self.typeLabel.frame;
}

- (void)clearCell
{
    self.titleView.text = @"";
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    self.typeLabel.text = @"";
    self.amountLabel.text = @"";
    self.contactLabel.text = @"";
    self.relationLabel.text = @"";
    [self.praiseButton setTitle:@"0" forState:UIControlStateNormal];
    [self.praiseButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.commentButton setTitle:@"0" forState:UIControlStateNormal];
}

//点赞
- (IBAction)clickPraiseButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPrasiseButton:)]) {
        [self.delegate clickPrasiseButton:self.object];
    }
}

//评论数
- (IBAction)clickCommentButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCommentButton:)]) {
        [self.delegate clickCommentButton:self.object];
    }
}

//修改
- (IBAction)clickEditButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditButton:)]) {
        [self.delegate clickEditButton:self.object];
    }
}

//删除
- (IBAction)clickDeleteButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDeleteButton:)]) {
        [self.delegate clickDeleteButton:self.object];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
