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
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;


@end

@implementation DiscoveryTableViewCell

- (void)awakeFromNib
{
    self.lineView.height = 0.5f;
    self.lblTitle.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.lblTitle.textColor = [UIColor colorWithHexString:@"161616"];
    self.numberLable.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.numberLable.textAlignment = NSTextAlignmentRight;
    [self addLayout];
}

- (void)addLayout
{
    UIImage * image = [UIImage imageNamed:@"hezuo"];
    CGSize size = image.size;
    self.imageTitle.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .topSpaceToView(self.contentView, MarginFactor((60.0f - size.height))/2.0f)
    .widthIs(MarginFactor(size.width))
    .heightIs(MarginFactor(size.height));
   
   self.lblTitle.sd_layout
    .leftSpaceToView(self.imageTitle, MarginFactor(13.0f))
    .centerYEqualToView(self.imageTitle)
    .autoHeightRatio(0.0f);
    [self.lblTitle setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(15.0f))
    .bottomSpaceToView(self.contentView, 1.0f)
    .widthIs(SCREENWIDTH-  MarginFactor(15.0f))
    .heightIs(0.5f);
    
    CGSize rightSize = self.rightImage.frame.size;
    self.rightImage.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(15.0f))
    .centerYEqualToView(self.imageTitle)
    .widthIs(rightSize.width)
    .heightIs(rightSize.height);
    
    self.numberLable.sd_layout
    .rightSpaceToView(self.rightImage, MarginFactor(13.0f))
    .centerYEqualToView(self.rightImage)
    .autoHeightRatio(0.0f);
    [self.numberLable  setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
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
