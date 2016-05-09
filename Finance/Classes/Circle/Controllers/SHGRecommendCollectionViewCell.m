//
//  SHGRecommendCollectionViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/4/26.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendCollectionViewCell.h"
@interface SHGRecommendCollectionViewCell()
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *companylabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;


@end
@implementation SHGRecommendCollectionViewCell

- (void)awakeFromNib
{
    [self addSdLayout];

}

- (void)addSdLayout
{
    self.companylabel.textColor = Color(@"626262");
    self.companylabel.font = FontFactor(12.0f);
    
    self.nameLabel.textColor = Color(@"1d5798");
    self.nameLabel.font = FontFactor(14.0f);
    
    self.positionLabel.textColor = Color(@"626262");
    self.positionLabel.font = FontFactor(13.0f);
    
    self.areaLabel.textColor = Color(@"a5a5a5");
    self.areaLabel.font = FontFactor(10.0f);
    
    UIImage *image = [UIImage imageNamed:@"newAddAttention"];
    CGSize size = image.size;
    self.headerView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(6.0f))
    .topSpaceToView(self.contentView, MarginFactor(10.0f))
    .widthIs(MarginFactor(48.0f))
    .heightIs(MarginFactor(48.0f));
    
    self.companylabel.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(6.0f))
    .centerYEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, MarginFactor(6.0f))
    .autoHeightRatio(0.0f);
    
    self.nameLabel.sd_layout
    .leftEqualToView(self.headerView)
    .topSpaceToView(self.headerView, MarginFactor(7.0f))
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(20.0f));
    
    self.positionLabel.sd_layout
    .leftEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel, MarginFactor(9.0f))
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(16.0f));
    
    self.areaLabel.sd_layout
    .leftEqualToView(self.positionLabel)
    .topSpaceToView(self.positionLabel, MarginFactor(10.0f))
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(12.0f));

    self.attentionButton.sd_layout
    .bottomEqualToView(self.positionLabel)
    .rightSpaceToView(self.contentView, MarginFactor(7.0f))
    .widthIs(size.width)
    .heightIs(size.height);
    
}

- (void)setObject:(CircleListObj *)object
{
    _object = object;
    [self clearCell];
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,_object.picname] placeholderImage:[UIImage imageNamed:@"default_head"] status:YES userID:_object.userid];
    [self.attentionButton setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
    [self.attentionButton setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateSelected];
    
    if (_object.realname.length == 0) {
        self.nameLabel.text = @" ";
    } else{
        self.nameLabel.text = _object.realname;
    }
    
    if (_object.position.length == 0) {
        self.areaLabel.text = @" ";
    } else{
        self.areaLabel.text = _object.position;
    }
    
    if (_object.title.length == 0) {
        self.positionLabel.text = @" ";
    } else{
        self.positionLabel.text = _object.title;
        
    }
    
    self.companylabel.text = _object.companyname;
    
}

- (void)clearCell
{
    self.nameLabel.text = @"";
    self.positionLabel.text = @"";
    self.areaLabel.text = @"";
    self.attentionButton.titleLabel.text = @"";
    
}
- (IBAction)attentionClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionClicked:)]){
        [self.delegate attentionClicked:self.object];
    }

}

@end
