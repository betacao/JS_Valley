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
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, SCREENWIDTH-80, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize: 16.0f];
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
    self.imageView.frame = CGRectMake(15, 7, 45, 45);
    
    self.textLabel.text = _name;
    if([_name isEqualToString:@"群申请与通知"] || [_name isEqualToString:@"通知"])
    {
        self.textLabel.frame = CGRectMake(70, 20, 175, 20);
    }else
    {
        self.textLabel.frame = CGRectMake(70, 7, 175, 20);
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
    
//    frame = _lineView.frame;
//    frame.origin.y = self.contentView.frame.size.height;
//    _lineView.frame = frame;
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
    return 60;
}
@end
