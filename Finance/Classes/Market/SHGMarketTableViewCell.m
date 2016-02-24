//
//  SHGMarketTableViewCell.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketTableViewCell.h"

@interface SHGMarketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong ,nonatomic) SHGMarketFirstCategoryObject *obj;
@end

@implementation SHGMarketTableViewCell

- (void)awakeFromNib
{
    [self loadView];
}

- (void)loadView
{
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.typeLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.amountLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.timeLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.contactLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];

    CGFloat titleHeight = [@" " sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height;
    CGFloat height = [@" " sizeWithAttributes:@{NSFontAttributeName : self.typeLabel.font}].height;

    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(18.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightIs(titleHeight);

    self.typeLabel.sd_layout
    .topSpaceToView(self.titleLabel, MarginFactor(14.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH/2.0f - MarginFactor(12.0f))
    .heightIs(height);
    
    self.contactLabel.sd_layout
    .topSpaceToView(self.typeLabel, MarginFactor(11.0f))
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH/2.0f - MarginFactor(12.0f))
    .heightRatioToView(self.typeLabel, 1.0f);
    
    [self.collectButton sizeToFit];
    CGSize size = self.collectButton.frame.size;
    self.collectButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contactLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    [self.deleteButton sizeToFit];
    CGSize deleteSize = self.deleteButton.frame.size;
    self.deleteButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contactLabel)
    .widthIs(deleteSize.width)
    .heightIs(deleteSize.height);
    
    [self.editButton sizeToFit];
    CGSize editeSize = self.deleteButton.frame.size;
    self.editButton.sd_layout
    .rightSpaceToView(self.deleteButton, MarginFactor(15.0f))
    .centerYEqualToView(self.contactLabel)
    .widthIs(editeSize.width)
    .heightIs(editeSize.height);
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.contactLabel)
    .rightSpaceToView(self.editButton, MarginFactor(12.0f))
    .heightRatioToView(self.typeLabel, 1.0f);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.amountLabel.sd_layout
    .centerYEqualToView(self.typeLabel)
    .leftEqualToView(self.timeLabel)
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .heightRatioToView(self.typeLabel, 1.0f);
    
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
    
    [self setupAutoHeightWithBottomView:self.bottomView bottomMargin:0.0f];
}

- (void)setObject:(SHGMarketObject *)object
{
    _object = object;
    [self clearCell];
    
    if (object.marketName.length == 0) {
        self.titleLabel.text = @" ";
    } else{
        self.titleLabel.text = object.marketName;
    }
    if (!object.catalog.length == 0) {
         self.typeLabel.text = [@"类型：" stringByAppendingString:object.catalog];
    } else{
        self.typeLabel.text = [@"类型：" stringByAppendingString:object.firstcatalog];
    }
   
    if ([object.price isEqualToString:@""]) {
        self.amountLabel.text = @"金额：暂未说明";
    } else{
        self.amountLabel.text = [@"金额：" stringByAppendingString: object.price];
    }
    self.contactLabel.text = [@"地区：" stringByAppendingString: object.position];

    NSString * timeStr = [object.modifyTime substringToIndex:10];
    self.timeLabel.text = [@"时间：" stringByAppendingString: timeStr];

    [self loadCollectionState];
    
}
- (void)loadNewUiFortype:(SHGMarketTableViewCellType)type
{
    if (type == SHGMarketTableViewCellTypeAll) {
        self.editButton.hidden = YES;
        self.deleteButton.hidden = YES;
    } else if (type == SHGMarketTableViewCellTypeMine){
        self.collectButton.hidden = YES;
        
    }
}
- (void)loadCollectionState
{
    if (self.object.isCollection ) {
        [self.collectButton setImage:[UIImage imageNamed:@"marketListCollection"] forState:UIControlStateNormal];
    } else{
        [self.collectButton setImage:[UIImage imageNamed:@"marketListNoCollection"] forState:UIControlStateNormal];
    }
}

- (void)clearCell
{
    self.titleLabel.text = @"";
    self.typeLabel.text = @"";
    self.amountLabel.text = @"";
    self.contactLabel.text = @"";
    self.timeLabel.text = @"";
    [self.collectButton setImage:[UIImage imageNamed:@"marketListNoCollection"] forState:UIControlStateNormal];
}
//收藏
- (IBAction)clickCollectButton:(UIButton *)sender
{
//    __weak typeof(self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCollectButton:state:)]) {
        [self.delegate clickCollectButton:self.object state:^(BOOL state) {
//            [weakSelf loadCollectionState];
        }];
    }
}

//修改
- (IBAction)clickEditButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditButton:)]) {
        [self.delegate clickEditButton:self.object];
    }
}

//删除
- (IBAction)clickDeleteButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDeleteButton:)]) {
        [self.delegate clickDeleteButton:self.object];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
