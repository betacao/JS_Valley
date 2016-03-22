//
//  MessageTableViewCell.m
//  Finance
//
//  Created by haibo li on 15/5/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MessageTableViewCell

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
    self.bgImageView.image = [[UIImage imageNamed:@"message_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f) resizingMode:UIImageResizingModeStretch];
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.time.textColor = Color(@"c3c3c3");
    self.time.font = FontFactor(14.0f);

    self.title.textColor = Color(@"161616");
    self.title.font = FontFactor(16.0f);

    self.content.textColor = Color(@"3c3c3c");
    self.content.font = FontFactor(15.0f);

    self.lineView.backgroundColor = Color(@"dedede");
}

- (void)addAutoLayout
{
    self.time.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(28.0f))
    .centerXEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.time setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.headerView.sd_layout
    .topSpaceToView(self.time, MarginFactor(12.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));

    self.title.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(9.0f))
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.title setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .topSpaceToView(self.title, MarginFactor(9.0f))
    .leftEqualToView(self.title)
    .widthIs(MarginFactor(240.0f))
    .heightIs(1.0f);

    self.content.sd_layout
    .topSpaceToView(self.lineView, MarginFactor(9.0f))
    .leftSpaceToView(self.bgView, MarginFactor(15.0f))
    .autoHeightRatio(0.0f);
    [self.content setSingleLineAutoResizeWithMaxWidth:MarginFactor(234.0f)];

    self.bgImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.bgView.sd_layout
    .topEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(8.0f))
    .widthIs(MarginFactor(264.0f));

    [self.bgView setupAutoHeightWithBottomView:self.content bottomMargin:MarginFactor(9.0f)];

    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:0.0f];
}

- (void)setObject:(MessageObj *)object
{
    [self clearCell];
    _object = object;
    [self.headerView updateHeaderView:nil placeholderImage:[UIImage imageNamed:@"logo"] status:NO userID:nil];
    self.title.text = object.title;
    NSDate *date = [self dateFromString:object.time];
    self.time.text = [self stringFromDate:date];

    self.content.text = object.content;
}

- (void)clearCell
{
    self.time.frame = CGRectZero;
    self.time.text = @"";

    self.title.frame = CGRectZero;
    self.title.text = @"";

    self.time.frame = CGRectZero;
    self.time.text = @"";
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
