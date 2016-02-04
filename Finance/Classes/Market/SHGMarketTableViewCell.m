//
//  SHGMarketTableViewCell.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketTableViewCell.h"

@interface SHGMarketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong ,nonatomic) SHGMarketFirstCategoryObject *obj;
@end

@implementation SHGMarketTableViewCell

- (void)awakeFromNib
{
    [self clearCell];
    [self loadView];
}

- (void)loadView
{
    self.titleView.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.typeLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.amountLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.timeLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.contactLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.titleView.numberOfLines = 1;
    
    self.titleView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(18.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH - MarginFactor(24.0f))
    .heightIs(MarginFactor(15.0f));
    //[self.titleView setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH - factor(24.0f)];
    
    self.typeLabel.sd_layout
    .topSpaceToView(self.titleView, MarginFactor(14.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.typeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.amountLabel.sd_layout
    .topSpaceToView(self.titleView, MarginFactor(14.0f))
    .leftSpaceToView(self.contentView, SCREENWIDTH /2.0f)
    .autoHeightRatio(0.0f);
    [self.amountLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.contactLabel.sd_layout
    .topSpaceToView(self.typeLabel, MarginFactor(11.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.contactLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.amountLabel, MarginFactor(11.0f))
    .leftSpaceToView(self.contentView, SCREENWIDTH /2.0f)
    .autoHeightRatio(0.0f);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    [self.collectButton sizeToFit];
    CGSize size = self.collectButton.frame.size;
    self.collectButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .bottomEqualToView(self.timeLabel)
    .widthIs(MarginFactor(size.width))
    .heightIs(MarginFactor(size.height));
    
    self.bottomLineView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(0.0f))
    .rightSpaceToView(self.contentView, MarginFactor(0.0f))
    .heightIs(0.5f)
    .topSpaceToView(self.contactLabel, MarginFactor(13.0f));
    
    self.bottomView.sd_layout
    .topSpaceToView(self.bottomLineView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(10.0f));
}

- (void)setObject:(SHGMarketObject *)object
{
    _object = object;
    [self clearCell];
    if (object.marketName.length == 0) {
        self.titleView.text = @" ";
    } else{
         self.titleView.text = object.marketName;
    }
    self.typeLabel.text = [@"类型：" stringByAppendingString:object.catalog];
    if ([object.price isEqualToString:@""]) {
        self.amountLabel.text = @"金额：暂未说明";
    } else{
        self.amountLabel.text = [@"金额：" stringByAppendingString: object.price];
    
   }
    
    
    self.contactLabel.text = [@"地区：" stringByAppendingString: object.position];
    if (object.isCollection ) {
        [self.collectButton setImage:[UIImage imageNamed:@"newDetialCollect"] forState:UIControlStateNormal];
    } else{
        [self.collectButton setImage:[UIImage imageNamed:@"newNoDetialCollect"] forState:UIControlStateNormal];
    }
    self.timeLabel.text = [@"时间：" stringByAppendingString: object.createTime];
    [self setupAutoHeightWithBottomView:self.bottomView bottomMargin:0.0f];
}

- (void)clearCell
{
    self.titleView.text = @"";
    self.typeLabel.text = @"";
    self.amountLabel.text = @"";
    self.contactLabel.text = @"";
    [self.collectButton setImage:[UIImage imageNamed:@"newNoDetialCollect"] forState:UIControlStateNormal];
}
//收藏
- (IBAction)clickCollectButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickCollectButton:)]) {
        [self.delegate ClickCollectButton:self.object];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
