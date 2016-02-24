//
//  SHGMarketNoticeTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketImageTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SHGMarketListViewController.h"

@interface SHGMarketImageTableViewCell ()

@property (strong, nonatomic) UIButton *imageButton;//展示图片当数据中含有tipUrl的时候显示 然后隐藏其他全部控件
@end

@implementation SHGMarketImageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
    self.imageButton.userInteractionEnabled = NO;

    [self.contentView addSubview:self.imageButton];
}

- (void)addAutoLayout
{
    self.imageButton.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.0f);
}

- (void)setTipUrl:(NSString *)tipUrl
{
    _tipUrl = tipUrl;
    if (CGRectGetHeight(self.imageButton.frame) > 0) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage, tipUrl]] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = ceilf(SCREENWIDTH * image.size.height / image.size.width);
            weakSelf.imageButton.height = height;
            [weakSelf.imageButton setBackgroundImage:image forState:UIControlStateNormal];
        });
    }];
}


@end



@interface SHGMarketLabelTableViewCell()

@property (strong, nonatomic) UILabel *titleLabel;

@end



@implementation SHGMarketLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self addAutoLayout];
        [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:MarginFactor(12.0f)];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(12.0f)];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"cbc9c9"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.titleLabel];
}

- (void)addAutoLayout
{

    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(2.0f))
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .autoHeightRatio(0.0f);

}

- (void)setText:(NSString *)text
{
    _text = text;
//    @"本地区该业务较少，现为您推荐其他地区同业务信息";
    self.titleLabel.text = text;
}

@end