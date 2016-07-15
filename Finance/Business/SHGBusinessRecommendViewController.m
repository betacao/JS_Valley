//
//  SHGBusinessRecommendViewController.m
//  Finance
//
//  Created by changxicao on 16/7/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessRecommendViewController.h"

@interface SHGBusinessRecommendViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SHGBusinessRecommendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{

}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



@interface SHGBusinessRecommendTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIView *typeLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SHGBusinessRecommendTableViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.spliteView.backgroundColor = Color(@"f6f7f8");
    self.spliteLine.backgroundColor = Color(@"e5e5e5");
    self.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.typeLine.backgroundColor = Color(@"e5e5e5");
    self.titleLabel.textColor = Color(@"3e3e3e");
    self.titleLabel.font = FontFactor(17.0f);
    self.firstLabel.textColor = self.secondLabel.textColor = self.thirdLabel.textColor = self.fourthLabel.textColor = Color(@"b8b8b8");
    self.firstLabel.font = self.secondLabel.font = self.thirdLabel.font = self.fourthLabel.font = FontFactor(14.0f);
    self.bottomLine.backgroundColor = Color(@"e5e5e5");

}

- (void)addAutoLayout
{
    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(12.0f));

    self.spliteLine.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteView, 0.0f)
    .heightIs(1 / SCALE);

    self.typeImageView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteLine, 0.0f)
    .widthIs(0.0f)
    .heightIs(0.0f);

    self.typeLine.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(16.0f))
    .rightSpaceToView(self.contentView, MarginFactor(16.0f))
    .topSpaceToView(self.typeImageView, 0.0f)
    .heightIs(1 / SCALE);

    self.accessoryImageView.sd_layout
    .topSpaceToView(self.typeLine, MarginFactor(21.0f))
    .rightEqualToView(self.typeLine)
    .widthIs(self.accessoryImageView.image.size.width)
    .heightIs(self.accessoryImageView.image.size.height);

    self.titleLabel.sd_layout
    .leftEqualToView(self.typeImageView)
    .centerYEqualToView(self.accessoryImageView)
    .rightSpaceToView(self.contentView, MarginFactor(62.0f))
    .heightIs(self.titleLabel.font.lineHeight);

    self.firstLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, MarginFactor(19.0f))
    .heightIs(self.firstLabel.font.lineHeight);
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.secondLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(225.0f))
    .topEqualToView(self.firstLabel)
    .heightIs(self.secondLabel.font.lineHeight);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
    
    self.thirdLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.firstLabel, MarginFactor(16.0f))
    .heightIs(self.thirdLabel.font.lineHeight);
    [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
    
    self.fourthLabel.sd_layout
    .leftEqualToView(self.secondLabel)
    .topEqualToView(self.thirdLabel)
    .heightIs(self.fourthLabel.font.lineHeight);
    [self.fourthLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.thirdLabel, MarginFactor(21.0f))
    .heightIs(1 / SCALE);

    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0.0f];
}

- (void)setObject:(SHGBusinessObject *)object
{
    _object = object;

    self.typeImageView.sd_resetLayout
    .leftSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteLine, 0.0f)
    .widthIs(0.0f)
    .heightIs(0.0f);
}


@end