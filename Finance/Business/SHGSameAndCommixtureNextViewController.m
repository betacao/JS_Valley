//
//  SHGSameAndCommixtureNextViewController.m
//  Finance
//
//  Created by weiqiankun on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGSameAndCommixtureNextViewController.h"
#import "EMTextView.h"
#import "SHGBusinessMargin.h"
@interface SHGSameAndCommixtureNextViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//业务说明
@property (strong, nonatomic) IBOutlet UIView *marketExplainView;
@property (weak, nonatomic) IBOutlet UILabel *marketExplainTitleLabel;
@property (weak, nonatomic) IBOutlet EMTextView *marketExplainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *marketExplainSelectImage;

//添加图片
@property (strong, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *addImageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (strong, nonatomic) IBOutlet UIButton *authorizeButton;
@end

@implementation SHGSameAndCommixtureNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布同业混业";
    [self.scrollView addSubview:self.marketExplainView];
    [self.scrollView addSubview:self.addImageView];
    [self.scrollView addSubview:self.authorizeButton];
    [self addSdLayout];
    [self initView];


}

- (void)addSdLayout
{
    self.scrollView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, MarginFactor(50.0f));
    
    self.sureButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));
    //业务说明
    
    self.marketExplainView.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.marketExplainTitleLabel.sd_layout
    .topSpaceToView(self.marketExplainView, ktopToView)
    .leftSpaceToView(self.marketExplainView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.marketExplainTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"biXuan"];
    CGSize size = image.size;
    
    self.marketExplainSelectImage.sd_layout
    .leftSpaceToView(self.marketExplainTitleLabel, kLeftToView)
    .centerYEqualToView(self.marketExplainTitleLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.marketExplainTextView.sd_layout
    .leftEqualToView(self.marketExplainTitleLabel)
    .topSpaceToView(self.marketExplainTitleLabel,ktopToView)
    .rightSpaceToView(self.marketExplainView, kLeftToView)
    .heightIs(MarginFactor(144.0f));
    
    [self.marketExplainView setupAutoHeightWithBottomView:self.marketExplainTextView bottomMargin:ktopToView];
    //添加图片
    UIImage *addImage = [UIImage imageNamed:@"addImageButton"];
    CGSize addSize = addImage.size;
    
    self.addImageView.sd_layout
    .topSpaceToView(self.marketExplainView, kLeftToView)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f);
    
    self.addImageTitleLabel.sd_layout
    .topSpaceToView(self.addImageView, ktopToView)
    .leftSpaceToView(self.addImageView, kLeftToView)
    .autoHeightRatio(0.0f);
    [self.addImageTitleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.addImageButton.sd_layout
    .leftEqualToView(self.addImageTitleLabel)
    .topSpaceToView(self.addImageTitleLabel, ktopToView)
    .widthIs(addSize.width)
    .heightIs(addSize.height);
    
    [self.addImageView setupAutoHeightWithBottomView:self.addImageButton bottomMargin:ktopToView];
    
    self.authorizeButton.sd_layout
    .topSpaceToView(self.addImageView, MarginFactor(20.0f))
    .leftSpaceToView(self.scrollView, kLeftToView)
    .rightSpaceToView(self.scrollView, kLeftToView)
    .heightRatioToView(self.addImageTitleLabel, 1.0f);
    
    [self.scrollView setupAutoHeightWithBottomView:self.authorizeButton bottomMargin:MarginFactor(20.0f)];
    
    
    
}


- (void)initView
{
    self.sureButton.titleLabel.font = FontFactor(19.0f);
    [self.sureButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:Color(@"f04241")];
    self.marketExplainTitleLabel.textColor = Color(@"161616");
    self.marketExplainTitleLabel.font = FontFactor(13.0f);
    
    self.addImageTitleLabel.textColor = Color(@"161616");
    self.addImageTitleLabel.font = FontFactor(13.0f);
    self.marketExplainTextView.font = FontFactor(15.0f);
    self.marketExplainTextView.textColor = Color(@"161616");
    self.marketExplainTextView.placeholder = @" 请描述您的业务详情或将您的业务信息拍照上传";
    self.marketExplainTextView.placeholderColor = Color(@"bebebe");
    
    self.authorizeButton.backgroundColor = [UIColor clearColor];
    self.authorizeButton.titleLabel.font = FontFactor(14.0f);
    [self.authorizeButton setTitleColor:Color(@"8b8b8b") forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"market_unselect"] forState:UIControlStateNormal];
    [self.authorizeButton setImage:[UIImage imageNamed:@"market_select"] forState:UIControlStateSelected];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
