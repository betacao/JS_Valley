/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "ChatListCell.h"
#define k_rowHeight MarginFactor(58.0f)
@interface ChatListCell ()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *unreadLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headerImageView;

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self loadView];
    }
    return self;
}

- (void)loadView
{
    self.headerImageView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.unreadLabel.sd_layout
    .centerXIs(self.headerImageView.frame.size.width + MarginFactor(12.0f))
    .centerYIs(self.headerImageView.frame.origin.y + MarginFactor(12.0f));
//    .widthIs(MarginFactor(16.0f))
//    .heightIs(MarginFactor(16.0f));
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
    .centerYEqualToView(self.headerImageView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    UIImage *image = [UIImage imageNamed:@"accessoryView"];
    CGSize size = image.size;
    self.rightImage.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.detailLabel.sd_layout
    .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
    .bottomEqualToView(self.headerImageView)
    .heightIs(self.detailLabel.font.lineHeight);;
    [self.detailLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    
    self.lineView.sd_layout
    .leftEqualToView(self.headerImageView)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.5f)
    .heightIs(0.5f);
    

}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_headerImageView];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
        _nameLabel.font = FontFactor(15.0f);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)unreadLabel
{
    if (!_unreadLabel) {
        _unreadLabel = [[UILabel alloc] init];
        _unreadLabel.bounds = CGRectMake(0.0f, 0.0f, MarginFactor(14.0f), MarginFactor(14.0f));
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.layer.cornerRadius = CGRectGetWidth(_unreadLabel.frame) / 2.0f;
        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.font = FontFactor(12.0f);
        [self.contentView addSubview:_unreadLabel];
    }
    return _unreadLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FontFactor(12.0f);
        _timeLabel.textColor = [UIColor colorWithHexString:@"d2d1d1"];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = FontFactor(13.0f);
        _detailLabel.textColor = [UIColor colorWithHexString:@"919291"];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UIImageView *)rightImage
{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] init];
        _rightImage.image = [UIImage imageNamed:@"rightArrowImage"];
        [self.contentView addSubview:_rightImage];
    }
    return _rightImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![self.unreadLabel isHidden]) {
        self.unreadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![self.unreadLabel isHidden]) {
        self.unreadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setModel:(ChatModel *)model
{
    _model = model;

    self.nameLabel.frame = CGRectZero;
    //self.detailLabel.frame = CGRectZero;
    self.timeLabel.frame = CGRectZero;

    self.nameLabel.text = model.name;
    if (model.detailMsg.length > 25) {
        model.detailMsg = [model.detailMsg substringToIndex:20];
        model.detailMsg = [NSString stringWithFormat:@"%@...",model.detailMsg];
    }
    self.detailLabel.text = model.detailMsg;
    self.timeLabel.text = model.time;

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,model.imageURL]] placeholderImage:model.placeholderImage];

    if([model.name isEqualToString:@"群申请与通知"] || [model.name isEqualToString:@"通知"]){
        self.nameLabel.sd_resetLayout
        .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
        .centerYEqualToView(self.headerImageView)
        .autoHeightRatio(0.0f);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
        
    } else{
        self.nameLabel.sd_resetLayout
        .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
        .topEqualToView(self.headerImageView)
        .autoHeightRatio(0.0f);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    }

    self.timeLabel.sd_resetLayout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .bottomEqualToView(self.nameLabel)
    .autoHeightRatio(0.0f);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    if (model.unreadCount > 0){
        if (model.unreadCount < 9){
            self.unreadLabel.font = FontFactor(13.0f);
        } else if(model.unreadCount > 9 && model.unreadCount < 99){
            self.unreadLabel.font = FontFactor(12.0f);
        } else{
            self.unreadLabel.font = FontFactor(10.0f);
        }
        [self.unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:self.unreadLabel];
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)model.unreadCount];
    } else{
        [self.unreadLabel setHidden:YES];
    }
}
@end


@interface ChatModel ()

@end

@implementation ChatModel



@end