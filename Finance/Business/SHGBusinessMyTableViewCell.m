//
//  SHGBusinessMyTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/8/12.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessMyTableViewCell.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessMineViewController.h"
#import "SHGBusinessListViewController.h"
#import "SHGBusinessSegmentViewController.h"
@interface SHGBusinessMyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *browaseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *complainNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UIView *topGrayView;
@property (weak, nonatomic) IBOutlet UIView *topGrayLineView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *buttonViewTopLine;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong, nonatomic) SHGBusinessObject *detailObject;

@end

@implementation SHGBusinessMyTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSdLayout];
    [self initView];
    
}

- (void)addSdLayout
{
   self.topGrayView.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    self.topGrayLineView.sd_layout
    .leftSpaceToView(self.topGrayView, 0.0f)
    .rightSpaceToView(self.topGrayView, 0.0f)
    .bottomSpaceToView(self.topGrayView, 0.0f)
    .heightIs(1/SCALE);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.topGrayView, MarginFactor(22.0f))
    .leftSpaceToView(self.contentView, MarginFactor(22.0f))
    .rightSpaceToView(self.contentView, MarginFactor(85.0f))
    .heightIs(self.titleLabel.font.lineHeight);
    
    UIImage *stateImage = [UIImage imageNamed:@"my_businessUnCheck"];
    CGSize stateSize =  stateImage.size;
    self.stateImageView.sd_layout
    .topSpaceToView(self.topGrayView, MarginFactor(36.0f))
    .rightSpaceToView(self.contentView, MarginFactor(33.0f))
    .widthIs(stateSize.width)
    .heightIs(stateSize.height);
    
    self.typeLabel.sd_layout
    .topSpaceToView(self.titleLabel, MarginFactor(15.0f))
    .leftEqualToView(self.titleLabel)
    .heightIs(self.typeLabel.font.lineHeight);
    [self.typeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.typeLabel)
    .leftSpaceToView(self.typeLabel, MarginFactor(10.0f))
    .heightIs(self.typeLabel.font.lineHeight);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.browaseNumLabel.sd_layout
    .topSpaceToView(self.typeLabel, MarginFactor(7.0f))
    .leftEqualToView(self.typeLabel)
    .heightIs(self.browaseNumLabel.font.lineHeight);
    [self.browaseNumLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.complainNumLabel.sd_layout
    .centerYEqualToView(self.browaseNumLabel)
    .leftSpaceToView(self.browaseNumLabel, MarginFactor(7.0f))
    .heightIs(self.browaseNumLabel.font.lineHeight);
    [self.complainNumLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.buttonView.sd_layout
    .topSpaceToView(self.browaseNumLabel, MarginFactor(22.0f))
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(45.0f));
    
    self.buttonViewTopLine.sd_layout
    .topSpaceToView(self.buttonView, 0.0f)
    .leftSpaceToView(self.buttonView, 0.0f)
    .rightSpaceToView(self.buttonView, 0.0f)
    .heightIs(1 / SCALE);
    
    UIImage *buttonImage = [UIImage imageNamed:@"bussiness_myGraybutton"];
    CGSize buttonImageSize = buttonImage.size;
    self.deleteButton.sd_layout
    .rightSpaceToView(self.buttonView, MarginFactor(12.0f))
    .centerYEqualToView(self.buttonView)
    .widthIs(buttonImageSize.width)
    .heightIs(buttonImageSize.height);
    
    self.editButton.sd_layout
    .rightSpaceToView(self.deleteButton, MarginFactor(12.0f))
    .centerYEqualToView(self.buttonView)
    .widthIs(buttonImageSize.width)
    .heightIs(buttonImageSize.height);
    
    self.sendButton.sd_layout
    .rightSpaceToView(self.editButton, MarginFactor(12.0f))
    .centerYEqualToView(self.buttonView)
    .widthIs(buttonImageSize.width)
    .heightIs(buttonImageSize.height);
    
    self.bottomLineView.sd_layout
    .topSpaceToView(self.buttonView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1/SCALE);
    
    [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:0.0f];
}

- (SHGBusinessObject *)detailObject
{
    if (!_detailObject) {
        _detailObject = [[SHGBusinessObject alloc] init];
    }
    return _detailObject;
}
- (void)initView
{
    [self.sendButton setTitle:@"再发布" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:Color(@"ff2f00") forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:Color(@"ff2f00") forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myRedbutton"] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = self.editButton.titleLabel.font = self.deleteButton.titleLabel.font = FontFactor(12.0f);
    
    [self.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.textColor = Color(@"161616");
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = FontFactor(16.0f);
    
    self.typeLabel.textColor = Color(@"019b46");
    self.typeLabel.textAlignment = NSTextAlignmentLeft;
    self.typeLabel.font = FontFactor(12.0f);
    
    self.timeLabel.textColor = Color(@"8d8d8d");
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = FontFactor(12.0f);
    
    self.browaseNumLabel.textColor = Color(@"8d8d8d");
    self.browaseNumLabel.textAlignment = NSTextAlignmentLeft;
    self.browaseNumLabel.font = FontFactor(12.0f);
    
    self.complainNumLabel.textColor = Color(@"8d8d8d");
    self.complainNumLabel.textAlignment = NSTextAlignmentLeft;
    self.complainNumLabel.font = FontFactor(12.0f);

    self.topGrayView.backgroundColor = Color(@"f7f7f7");
    
    self.topGrayLineView.backgroundColor = self.buttonViewTopLine.backgroundColor = self.bottomLineView.backgroundColor = Color(@"e6e7e8");
}


- (void)setArray:(NSArray *)array
{
    _array = array;
    SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
    object = [array firstObject];
    if ([[array lastObject] isEqualToString:@"other"]) {
        self.stateImageView.hidden = YES;
        self.buttonView.hidden = YES;
        self.complainNumLabel.hidden = YES;
        self.bottomLineView.sd_resetLayout
        .topSpaceToView(self.browaseNumLabel, MarginFactor(22.0f))
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(1/SCALE);
    } else if ([[array lastObject] isEqualToString:@"mine"]){
        self.buttonView.hidden = NO;
        self.stateImageView.hidden = NO;
        self.complainNumLabel.hidden = NO;
    }
    self.titleLabel.text = object.title;
    NSArray *globleKeyArray =[[[SHGGloble  sharedGloble]getBusinessKeysAndValues] allKeys];
    NSArray *globleValueArray = [[[SHGGloble  sharedGloble]getBusinessKeysAndValues] allValues];
    if (object.businessType) {
        self.typeLabel.text = [globleKeyArray objectAtIndex:[globleValueArray indexOfObject:object.businessType]];
    }
    

    self.timeLabel.text = [NSString stringWithFormat:@"发布于%@",object.createTime];
    NSMutableAttributedString *browase = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"浏览%@次",object.browseNum] attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName:Color(@"8d8d8d")}];
    [browase addAttributes:@{NSForegroundColorAttributeName:Color(@"ff3904")} range:NSMakeRange(2, object.browseNum.length)];
    self.browaseNumLabel.attributedText = browase;
    
    NSMutableAttributedString *complain = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"投诉%@次",object.complainNum] attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName:Color(@"8d8d8d")}];
    [complain addAttributes:@{NSForegroundColorAttributeName:Color(@"ff3904")} range:NSMakeRange(2, object.complainNum.length)];
    self.complainNumLabel.attributedText = complain;
    
    if ([object.auditState isEqualToString:@"0"] || [object.auditState isEqualToString:@"9"]){
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editButton setTitleColor:Color(@"ff2f00") forState:UIControlStateNormal];
        [self.editButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myRedbutton"] forState:UIControlStateNormal];
    } else{
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editButton setTitleColor:Color(@"9b9b9b") forState:UIControlStateNormal];
        [self.editButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myGraybutton"] forState:UIControlStateNormal];
    }
    if ([object.auditState isEqualToString:@"0"]) {
        self.stateImageView.hidden = YES;
    } else if ([object.auditState isEqualToString:@"1"] || [object.auditState isEqualToString:@"2"]){
        self.stateImageView.hidden = NO;
        self.stateImageView.image = [UIImage imageNamed:@"my_businessUnCheck"];
    } else if ([object.auditState isEqualToString:@"9"]){
        self.stateImageView.hidden = NO;
        self.stateImageView.image = [UIImage imageNamed:@"my_businessReject"];
    }
    if ([object.isRefresh isEqualToString:@"true"]) {
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myRedbutton"] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:Color(@"ff2f00") forState:UIControlStateNormal];
    } else{
        [self.sendButton setTitleColor:Color(@"9b9b9b") forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myGraybutton"] forState:UIControlStateNormal];
    }
    
}
- (void)editButtonClick:(UIButton *)btn
{
    WEAK(self, weakSelf);
    SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
    object = [weakSelf.array firstObject];
    if ([object.auditState isEqualToString:@"0"] || [object.auditState isEqualToString:@"9"]) {
        [SHGBusinessManager getBusinessDetail:object success:^(SHGBusinessObject *detailObject) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(goToEditBusiness:)]) {
                [weakSelf.delegate goToEditBusiness:detailObject];
            }
            NSLog(@"%@",weakSelf.detailObject);
        }];
    } else{
        
    }
    
    
}

- (IBAction)deleteBusiness:(UIButton *)button
{
    WEAK(self, weakSelf);
    SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
    object = [weakSelf.array firstObject];
    SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alertView.rightBlock = ^{
        [SHGBusinessManager deleteBusiness:object success:^(BOOL success) {
            if (success) {
                for (SHGBusinessSegmentViewController  *controller in [SHGBusinessListViewController sharedController].navigationController.viewControllers) {
                    if ([controller isKindOfClass:[SHGBusinessSegmentViewController class]]) {
                        [controller deleteBusinessWithBusinessID:object.businessID];
                    }
                }
                [[SHGBusinessListViewController sharedController] deleteBusinessWithBusinessID:object.businessID];
            }
        }];
    };
    [alertView show];
    
}
- (IBAction)refreshButtonClick:(UIButton *)sender
{
    WEAK(self, weakSelf);
    SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
    object = [weakSelf.array firstObject];
    if ([object.auditState isEqualToString:@"0"] || [object.auditState isEqualToString:@"9"]) {
        if ([object.isRefresh isEqualToString:@"true"]) {
            [SHGBusinessManager refreshBusiness:object success:^(BOOL success) {
                if (success) {
                    [weakSelf.sendButton setBackgroundImage:[UIImage imageNamed:@"bussiness_myGraybutton"] forState:UIControlStateNormal];
                    [self.sendButton setTitleColor:Color(@"9b9b9b") forState:UIControlStateNormal];
                    object.isRefresh = @"false";
                };
            }];
            
        } else{
            [Hud showMessageWithText:@"莫心急，24小时内只能刷新一次哦～"];
        }

    } else{
        
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
