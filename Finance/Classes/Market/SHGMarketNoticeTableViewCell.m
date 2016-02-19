//
//  SHGMarketNoticeTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/1/22.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketNoticeTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SHGMarketListViewController.h"

@interface SHGMarketNoticeTableViewCell ()

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *imageButton;//展示图片当数据中含有tipUrl的时候显示 然后隐藏其他全部控件
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation SHGMarketNoticeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
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
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(12.0f)];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"cbc9c9"];
    self.titleLabel.hidden = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"本地区该业务较少，现为您推荐其他业务同业务信息";

    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];

    [self.contentView addSubview:self.imageButton];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)addAutoLayout
{
    self.imageButton.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.0f);

    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView, -MarginFactor(10.0f))
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f);

    self.bottomView.sd_layout
    .topSpaceToView(self.imageButton, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(10.0f));
}

- (void)setObject:(SHGMarketNoticeObject *)object
{
    _object = object;
    if (object.type == SHGMarketNoticeTypePositionAny) {
        self.titleLabel.hidden = NO;
        [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
        if (CGRectGetHeight(self.imageButton.frame) != MarginFactor(16.0f)) {
            self.imageButton.height = MarginFactor(16.0f);
            [((SHGMarketListViewController *)(self.controller)) reloadDataWithHeight:MarginFactor(26.0f)];
        }
        return;
    }
    self.titleLabel.hidden = YES;
    if (object.tipUrl.length > 0 && !self.imageButton.currentBackgroundImage) {
        __weak typeof(self)weakSelf = self;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage, object.tipUrl]] options:SDWebImageLowPriority|SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat height = ceilf(SCREENWIDTH * image.size.height / image.size.width);
                weakSelf.imageButton.height = height;
                [weakSelf.imageButton setBackgroundImage:image forState:UIControlStateNormal];
                [((SHGMarketListViewController *)(weakSelf.controller)) reloadDataWithHeight:height + CGRectGetHeight(self.bottomView.frame)];

            });
        }];
    }
}


@end
