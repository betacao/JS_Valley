//
//  SHGBusinessDetailViewController.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessDetailViewController.h"
#import "MLEmojiLabel.h"
#import "SHGEmptyDataView.h"

@interface SHGBusinessDetailViewController ()<BRCommentViewDelegate, MLEmojiLabelDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;


@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) BRCommentView *popupView;
@property (strong, nonatomic) UIView *photoView ;
@end

@implementation SHGBusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务详情";
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    [self.detailTable setTableFooterView:[[UIView alloc] init]];
    [self initView];
    [self addLayout];
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateTypeMarketDeleted;
    }
    return _emptyView;
}
- (void)initView
{
    self.nameLabel.font = FontFactor(15.0f);
    self.companyLabel.font = FontFactor(13.0f);
    self.positionLabel.font = FontFactor(13.0f);
    self.titleLabel.font = FontFactor(15.0f);
    self.typeLabel.font = FontFactor(14.0f);
    self.phoneNumLabel.numberOfLines = 0;
    self.phoneNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.phoneNumLabel.textColor = [UIColor colorWithHexString:@"888888"];
    self.phoneNumLabel.font = FontFactor(14.0f);
    self.phoneNumLabel.delegate = self;
    self.phoneNumLabel.backgroundColor = [UIColor clearColor];
    
    self.marketDetialLabel.font = FontFactor(15.0f);
    self.detailContentLabel.font = FontFactor(15.0f);
    self.speakButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f,0.0f);
    self.speakButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(15.0f), 0.0f, 0.0f);
    self.speakButton.titleLabel.font = FontFactor(13.0);
    self.speakButton.layer.masksToBounds = YES;
    self.speakButton.layer.cornerRadius = 4;
    [self.collectionButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.editButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnShare  setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
}

- (void)addLayout
{
    self.viewInput.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(45.0f));
    
    self.detailTable.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.viewInput, 0.0f);
    
    self.speakButton.sd_layout
    .leftSpaceToView(self.viewInput, MarginFactor(13.0f))
    .topSpaceToView(self.viewInput, MarginFactor(10.0f))
    .bottomSpaceToView(self.viewInput, MarginFactor(10.0f))
    .widthIs(MarginFactor(256.0f));
    
    [self.btnShare sizeToFit];
    CGSize shareSize = self.btnShare.frame.size;
    self.btnShare.sd_layout
    .rightSpaceToView(self.viewInput, MarginFactor(18.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(shareSize.width)
    .heightIs(shareSize.height);
    
    [self.collectionButton sizeToFit];
    CGSize collectSize = self.collectionButton.frame.size;
    self.collectionButton.sd_layout
    .rightSpaceToView(self.btnShare, MarginFactor(25.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(collectSize.width)
    .heightIs(collectSize.height);
    
    [self.editButton sizeToFit];
    CGSize editSize = self.editButton.frame.size;
    self.editButton.sd_layout
    .rightSpaceToView(self.btnShare, MarginFactor(25.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(editSize.width)
    .heightIs(editSize.height);
    
    
    //headerView
    self.headImageView.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .topSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .widthIs(MarginFactor(45.0f))
    .heightIs(MarginFactor(45.0f));
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headImageView, MarginFactor(9.0f))
    .topEqualToView(self.headImageView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.positionLabel.sd_layout
    .leftSpaceToView(self.nameLabel, MarginFactor(7.0f))
    .bottomEqualToView(self.nameLabel)
    .autoHeightRatio(0.0);
    [self.positionLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.firstHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .widthIs(SCREENWIDTH)
    .heightIs(0.5f)
    .topSpaceToView(self.headImageView, MarginFactor(15.0f));
    
    self.companyLabel.sd_layout
    .bottomEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView, MarginFactor(9.0f))
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    
    self.typeLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.titleLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.typeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    
    self.phoneNumLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.typeLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    self.phoneNumLabel.isAttributedContent = YES;
    
    self.secondHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.phoneNumLabel, MarginFactor(12.0f))
    .heightIs(0.5f);
    
    self.marketDetialLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.marketDetialLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.thirdHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.marketDetialLabel, MarginFactor(12.0f))
    .heightIs(0.5f);
    
    self.detailContentLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(16.0f))
    .autoHeightRatio(0.0f);
    self.detailContentLabel.isAttributedContent = YES;
    
    self.photoView = [[UIView alloc] init];
    [self.viewHeader addSubview:self.photoView];
    self.photoView.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .topSpaceToView(self.detailContentLabel,0.0f)
    .heightIs(0.0f);
    
    [self.viewHeader setupAutoHeightWithBottomView:self.photoView bottomMargin:MarginFactor(16.0f)];
    
    self.detailTable.tableHeaderView = self.viewHeader;
}

#pragma mark ----tableView----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
