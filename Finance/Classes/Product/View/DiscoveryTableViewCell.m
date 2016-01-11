//
//  DiscoveryTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "DiscoveryTableViewCell.h"
@interface DiscoveryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblRight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imageTitle;

@end

@implementation DiscoveryTableViewCell

- (void)awakeFromNib
{
    self.lineView.size = CGSizeMake(self.lineView.width, 0.5f);
}

- (void)loadDataWithImage:(NSString *)imageName title:(NSString *)title rightItem:(NSString *)itemName rightItemColor:(UIColor *)color
{
    if ([imageName hasPrefix:@"http://"]){
        [self.imageTitle sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    } else{
        [self.imageTitle setImage:[UIImage imageNamed:imageName]];
    }
    self.lblTitle.text = title;
    if (itemName && color){
        self.lblRight.text = itemName;
        self.lblRight.backgroundColor = color;
    } else{
        self.lblRight.text = nil;
        self.lblRight.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
