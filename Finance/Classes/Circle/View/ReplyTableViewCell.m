//
//  ReplyTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (void)awakeFromNib {
   // self.contentView.backgroundColor = BACK_COLOR;
    // Initialization code
}


-(void)loadUIWithObj:(commentOBj  *)comobj
{
    UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,5, 240.0f, 17)];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = [UIFont systemFontOfSize:14.0f];
    replyLabel.userInteractionEnabled = YES;
    replyLabel.textAlignment = NSTextAlignmentLeft;
    NSString *text = @"";

    NSMutableAttributedString *str;
    UIButton *cnickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *rnickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cnickButton.backgroundColor = [UIColor clearColor];
    rnickButton.backgroundColor = [UIColor clearColor];
    [cnickButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
    [rnickButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
    cnickButton.tag = self.index;
    rnickButton.tag = self.index;
    if (IsStrEmpty(comobj.rnickname))
    {
        text = [NSString stringWithFormat:@"%@:x%@",comobj.cnickname,comobj.cdetail];

        CGSize cSize = [[NSString stringWithFormat:@"%@:",comobj.cnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [cnickButton setFrame:CGRectMake(-3, 0, cSize.width, cSize.height)];
        [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.cnickname] forState:UIControlStateNormal];
        [cnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
        [cnickButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:cnickButton];
        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length+1+1 )];

    }
    else
    {
        text = [NSString stringWithFormat:@"%@回复%@:x%@",comobj.cnickname,comobj.rnickname,comobj.cdetail];
        CGSize cSize = [comobj.cnickname sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [cnickButton setBackgroundColor:[UIColor whiteColor]];
        [cnickButton setFrame:CGRectMake(-3, 0, cSize.width, cSize.height)];
        [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cnickButton setTitle:comobj.cnickname forState:UIControlStateNormal];
        [cnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
        [cnickButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:cnickButton];
        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length)];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(comobj.cnickname.length + 2,1 + comobj.rnickname.length +1)];

        NSString *leftText = [NSString stringWithFormat:@"回复"];
        CGSize leftSize = [leftText sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        CGSize rSize = [[NSString stringWithFormat:@"%@:",comobj.rnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];

        [rnickButton setFrame:CGRectMake(leftSize.width+cSize.width, 0, rSize.width, rSize.height)];
        [rnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.rnickname] forState:UIControlStateNormal];
        [rnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
        [rnickButton.titleLabel setFont:replyLabel.font];
        [rnickButton.titleLabel setTextAlignment:NSTextAlignmentLeft];

        [replyLabel addSubview:rnickButton];
    }
    [cnickButton addTarget:self action:@selector(cnickClick:) forControlEvents:UIControlEventTouchUpInside];
    [rnickButton addTarget:self action:@selector(rnickClick:) forControlEvents:UIControlEventTouchUpInside];
    [str addAttribute:NSFontAttributeName value:replyLabel.font range:NSMakeRange(0, text.length)];
    replyLabel.attributedText = str;

    CGRect replyRect = replyLabel.frame;
    CGSize replySize = [text sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, CGFLOAT_MAX) lineBreakMode:replyLabel.lineBreakMode];
    NSLog(@"%f",SCREENWIDTH);
    replyRect.size = replySize;
    replyLabel.frame = replyRect;
    [self.contentView addSubview:replyLabel];

}
-(void)cnickClick:(UIButton *)sender
{
    [self.delegate cnickClick:self.index];
}
-(void)rnickClick:(UIButton *)sender
{
    [self.delegate rnickClick:self.index];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
