//
//  ReplyTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ReplyTableViewCell.h"
@interface ReplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;

@property (assign, nonatomic) SHGCommentType commentType;
@end

@implementation ReplyTableViewCell

- (void)awakeFromNib
{
    
}

- (void)loadUIWithObj:(commentOBj *)comobj commentType:(SHGCommentType)type
{
    self.commentType = type;
    CGRect frame = CGRectZero;
    switch (type) {
        case SHGCommentTypeFirst:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,kCommentTopMargin, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);

            break;
        case SHGCommentTypeNormal:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,0.0f, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);
            break;
        default:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,0.0f, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);
            break;
    }
    
    UILabel *replyLabel = [[UILabel alloc] initWithFrame:frame];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = FontFactor(14.0f);
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
    if (IsStrEmpty(comobj.rnickname)){
        text = [NSString stringWithFormat:@"%@:x%@",comobj.cnickname,comobj.cdetail];

        CGSize cSize = [[NSString stringWithFormat:@"%@:",comobj.cnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [cnickButton setFrame:CGRectMake(0, 0, cSize.width, cSize.height)];
        [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.cnickname] forState:UIControlStateNormal];
        [cnickButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [cnickButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:cnickButton];
        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length + 1 + 1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(comobj.cnickname.length + 1 + 1,str.length - comobj.cnickname.length - 1 - 1)];
    } else{
        text = [NSString stringWithFormat:@"%@回复%@:x%@",comobj.cnickname,comobj.rnickname,comobj.cdetail];
        CGSize cSize = [comobj.cnickname sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [cnickButton setFrame:CGRectMake(0, 0, cSize.width, cSize.height)];
        [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cnickButton setTitle:comobj.cnickname forState:UIControlStateNormal];
        [cnickButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [cnickButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:cnickButton];

        NSString *leftText = [NSString stringWithFormat:@"回复"];
        
        CGSize leftSize = [leftText sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        CGSize rSize = [[NSString stringWithFormat:@"%@:",comobj.rnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];

        [rnickButton setFrame:CGRectMake(leftSize.width+cSize.width, 0, rSize.width, rSize.height)];
        [rnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.rnickname] forState:UIControlStateNormal];
        [rnickButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [rnickButton.titleLabel setFont:replyLabel.font];
        [rnickButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [replyLabel addSubview:rnickButton];


        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length)];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(comobj.cnickname.length + 2,1 + comobj.rnickname.length +1)];

        NSRange range = NSMakeRange(comobj.cnickname.length + 2,1 + comobj.rnickname.length +1);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(range.location + range.length,str.length - range.length - range.location)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(comobj.cnickname.length, 2)];
    }
    [cnickButton addTarget:self action:@selector(cnickClick:) forControlEvents:UIControlEventTouchUpInside];
    [rnickButton addTarget:self action:@selector(rnickClick:) forControlEvents:UIControlEventTouchUpInside];
    [str addAttribute:NSFontAttributeName value:replyLabel.font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];

    replyLabel.attributedText = str;

    CGRect replyRect = replyLabel.frame;
    CGSize size = [replyLabel sizeThatFits:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, CGFLOAT_MAX)];
    NSLog(@"%f",size.height);
    replyRect.size = size;
    replyLabel.frame = replyRect;
    [self.bgView addSubview:replyLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bgFrame = self.bgView.frame;
    bgFrame.origin.x = MarginFactor(12.0f);
    bgFrame.size.width = SCREENWIDTH - 2 * MarginFactor(12.0f);
    
    self.bgView.frame = bgFrame;

}

-(void)makeFirstCell
{
    self.bgView.backgroundColor = [UIColor clearColor];
    self.imageBgView.image = [UIImage imageNamed:@"comment_backimage"];
    UIImage *image = self.imageBgView.image;;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.imageBgView.image = image;
   
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
