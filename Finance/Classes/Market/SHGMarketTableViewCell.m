//
//  SHGMarketTableViewCell.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketTableViewCell.h"
#import "UIButton+EnlargeEdge.h"
@interface SHGMarketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
//@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIButton *browseButton;
@property (strong, nonatomic) SHGMarketFirstCategoryObject *obj;
@end

@implementation SHGMarketTableViewCell

- (void)awakeFromNib
{
    [self loadView];
}

- (void)loadView
{
    self.titleLabel.font = FontFactor(15.0f);
    self.typeLabel.font = FontFactor(13.0f);
    self.amountLabel.font = FontFactor(13.0f);
    self.timeLabel.font = FontFactor(13.0f);
    self.contactLabel.font = FontFactor(13.0f);
    self.browseButton.titleLabel.font = FontFactor(12.0f);
    [self.browseButton setTitleColor:[UIColor colorWithHexString:@"d3d3d3"] forState:UIControlStateNormal];
    self.browseButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -1.0f);
    CGFloat titleHeight = [@" " sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height;
    CGFloat height = [@" " sizeWithAttributes:@{NSFontAttributeName : self.typeLabel.font}].height;
    [self.deleteButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
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
    
    UIImage *browseImage = [UIImage imageNamed:@"marketBrowse"];
    CGSize size = browseImage.size;
    self.browseButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contactLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    UIImage *deleteImage = [UIImage imageNamed:@"home_delete"];
    CGSize deleteSize = deleteImage.size;
    self.deleteButton.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.typeLabel)
    .widthIs(deleteSize.width)
    .heightIs(deleteSize.height);
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.contactLabel)
    .rightSpaceToView(self.browseButton, MarginFactor(12.0f))
    .heightRatioToView(self.typeLabel, 1.0f)
    .leftSpaceToView(self.contentView, SCREENWIDTH / 2.0f);
    
    self.amountLabel.sd_layout
    .centerYEqualToView(self.typeLabel)
    .leftEqualToView(self.timeLabel)
    .rightSpaceToView(self.deleteButton, MarginFactor(12.0f))
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
    [self.browseButton setTitle:object.browernum forState:UIControlStateNormal];
    [self.browseButton sizeToFit];
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
    if (object.modifyTime.length > 0) {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* inputDate = [inputFormatter dateFromString:object.modifyTime];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd "];
        NSString *str = [outputFormatter stringFromDate:inputDate];
        self.timeLabel.text = [@"时间：" stringByAppendingString: str];
    } else{
        self.timeLabel.text = @"时间：";
    }
    
    if ([UID isEqualToString:object.createBy]) {
        self.deleteButton.hidden = NO;
    } else{
        self.deleteButton.hidden = YES;
    }
    
}

- (void)clearCell
{
    self.titleLabel.text = @" ";
    self.typeLabel.text = @" ";
    self.amountLabel.text = @" ";
    self.contactLabel.text = @" ";
    self.timeLabel.text = @" ";
    [self.browseButton setTitle:@"" forState:UIControlStateNormal];
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
