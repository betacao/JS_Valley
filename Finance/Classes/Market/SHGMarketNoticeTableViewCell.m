//
//  SHGMarketNoticeTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketNoticeTableViewCell.h"
#import "UIButton+WebCache.h"

@interface SHGMarketNoticeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;//展示图片当数据中含有tipUrl的时候显示 然后隐藏其他全部控件
@end

@implementation SHGMarketNoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadDataWithObject:(SHGMarketObject *)object block:(void (^)(CGFloat))block
{
    if (object.tipUrl.length > 0) {
        self.imageButton.hidden = NO;
        __weak typeof(self)weakSelf = self;
        [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage, object.tipUrl]] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat height = ceilf(SCREENWIDTH * image.size.height / image.size.width);
            if (block && CGRectGetHeight(weakSelf.imageButton.frame) != height) {
                weakSelf.imageButton.height = height;
                block(height);
            }

        }];
        return;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
