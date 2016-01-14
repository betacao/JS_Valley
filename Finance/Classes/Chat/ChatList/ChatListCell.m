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

@interface ChatListCell ()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *unreadLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat spaceToRight = 15.0f;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 95.0f, 7.0f, 80.0f, 16.0f)];
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"919291"];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 16.0f, 16.0f)];
        self.unreadLabel.backgroundColor = [UIColor redColor];
        self.unreadLabel.textColor = [UIColor whiteColor];
        
        self.unreadLabel.textAlignment = NSTextAlignmentCenter;
        self.unreadLabel.font = [UIFont systemFontOfSize:12.0f];
        self.unreadLabel.layer.cornerRadius = CGRectGetWidth(self.unreadLabel.frame) / 2.0f;
        self.unreadLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.unreadLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 20, SCREENWIDTH-80, 20)];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"565656"];
        [self.contentView addSubview:self.detailLabel];

        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize: 16.0f];
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(spaceToRight, CGRectGetHeight(self.frame) - 1.0f, SCREENWIDTH - spaceToRight, 0.5f)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [self.contentView addSubview:self.lineView];

        UIImage *image = [UIImage imageNamed:@"accessoryView"];
        self.rightImage = [[UIImageView  alloc] initWithImage:image];
        CGSize size = image.size;
        self.rightImage.frame = CGRectMake(SCREENWIDTH - spaceToRight - size.width, (CGRectGetHeight(self.frame) - size.height) / 2.0f, size.width, size.height);
        self.rightImage.image = image;
        [self.contentView addSubview:self.rightImage];

    }
    return self;
}

- (void)awakeFromNib
{

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

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(15, 8, 28, 28);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.imageURL]] placeholderImage:self.placeholderImage];
    self.unreadLabel.center = CGPointMake(CGRectGetMaxX(self.imageView.frame), CGRectGetMinY(self.imageView.frame));
    self.textLabel.text = self.name;
    if([self.name isEqualToString:@"群申请与通知"] || [self.name isEqualToString:@"通知"]){
        self.textLabel.frame = CGRectMake(58, 12, 175, 20);
    } else{
        self.textLabel.frame = CGRectMake(58, 5, 175, 20);
    }

    self.detailLabel.text = self.detailMsg;
    self.timeLabel.text = self.time;
    if (self.unreadCount > 0){
        if (self.unreadCount < 9){
            self.unreadLabel.font = [UIFont systemFontOfSize:13.0f];
        } else if(self.unreadCount > 9 && self.unreadCount < 99){
            self.unreadLabel.font = [UIFont systemFontOfSize:12.0f];
        } else{
            self.unreadLabel.font = [UIFont systemFontOfSize:10.0f];
        }
        [self.unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:self.unreadLabel];
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)self.unreadCount];
    } else{
        [self.unreadLabel setHidden:YES];
    }

}

- (void)setName:(NSString *)name
{
    _name = name;
    self.textLabel.text = name;
    self.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
    self.textLabel.font = [UIFont systemFontOfSize:13];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
@end
