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

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat spaceToRight = 15.0f;
        CGFloat spaceToTop = 16.0f;
        CGFloat rightImageWidth = 7.0f;
        CGFloat rightImageHeight = 13.0f;
        CGFloat lineToTop = 44.0f;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-100, 7, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 20, SCREENWIDTH-80, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize: 16.0f];
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(spaceToRight, lineToTop, SCREENWIDTH-spaceToRight, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [self.contentView addSubview:_lineView];
        
        _rightImage = [[UIImageView  alloc]init];
        _rightImage.frame = CGRectMake(SCREENWIDTH - spaceToRight - rightImageWidth, spaceToTop, rightImageWidth, rightImageHeight);
        _rightImage.image = [UIImage imageNamed:@"accessoryView"];
        [self.contentView addSubview:_rightImage];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGRect frame = self.imageView.frame;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,_imageURL]] placeholderImage:_placeholderImage];
    self.imageView.frame = CGRectMake(15, 8, 28, 28);
    
    self.textLabel.text = _name;
    if([_name isEqualToString:@"群申请与通知"] || [_name isEqualToString:@"通知"])
    {
        self.textLabel.frame = CGRectMake(58, 12, 175, 20);
    }else
    {
        self.textLabel.frame = CGRectMake(58, 5, 175, 20);
    }
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0)
    {
        if (_unreadCount < 9)
        {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99)
        {
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else
        {
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.textLabel.text = name;
    self.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.textLabel.font = [UIFont systemFontOfSize:13];
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
@end
