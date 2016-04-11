//
//  SHGBusinessSelectCategoryViewController.m
//  Finance
//
//  Created by changxicao on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessSelectCategoryViewController.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessButtonContentView.h"

@interface SHGBusinessSelectCategoryViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) UIView *lastContentView;
@end

@implementation SHGBusinessSelectCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择分类";
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    [[SHGBusinessManager shareManager] getSecondListWithType:self.firstType block:^(NSArray *array) {
        if (array) {
            [weakSelf initViewWithArray:array];
            [weakSelf addAutoLayout];
        }
    }];
}

- (void)initViewWithArray:(NSArray *)array
{
    self.nextButton.backgroundColor = Color(@"f04241");
    [self.nextButton setTitle:@"确定" forState:UIControlStateNormal];

    [array enumerateObjectsUsingBlock:^(SHGBusinessSecondObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SHGBusinessButtonContentView *contentView = [[SHGBusinessButtonContentView alloc] init];
        [self.scrollView addSubview:contentView];

        UILabel *titleLabel = [[UILabel alloc] init];
        [contentView addSubview:titleLabel];
        titleLabel.font = FontFactor(13.0f);
        titleLabel.textColor = Color(@"161616");
        titleLabel.text = obj.title;

        titleLabel.sd_layout
        .topSpaceToView(contentView, 0.0f)
        .leftSpaceToView(contentView, kLeftToView)
        .rightSpaceToView(contentView, 0.0f)
        .heightIs(MarginFactor(30.0f) + titleLabel.font.lineHeight);

        __block UIButton *lastButton = nil;
        CGFloat width = ceilf((SCREENWIDTH - kLeftToView * 4.0f) / 3.0f);
        [obj.subTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSInteger row = idx / 3;
            NSInteger col = idx % 3;
            CGRect frame = CGRectMake((col + 1) * kLeftToView + col * width, row * (MarginFactor(36.0f) + MarginFactor(10.0f)) + MarginFactor(30.0f) + titleLabel.font.lineHeight, width, MarginFactor(36.0f));
            button.frame = frame;
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:Color(@"f04241") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[[UIImage imageNamed:@"business_unSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"business_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
            button.titleLabel.font = FontFactor(13.0f);
            lastButton = button;

            [contentView addSubview:button];
        }];

        UIView *spliteView = [[UIView alloc] init];
        spliteView.backgroundColor = Color(@"efeeef");
        [contentView addSubview:spliteView];
        spliteView.sd_layout
        .topSpaceToView(lastButton, MarginFactor(10.0f))
        .leftSpaceToView(contentView, 0.0f)
        .rightSpaceToView(contentView, 0.0f)
        .heightIs(MarginFactor(12.0f));

        if (self.lastContentView) {
            contentView.sd_layout
            .leftSpaceToView(self.scrollView, 0.0f)
            .rightSpaceToView(self.scrollView, 0.0f)
            .topSpaceToView(self.lastContentView, 0.0f);
            [contentView setupAutoHeightWithBottomView:spliteView bottomMargin:0.0f];
        } else {
            contentView.sd_layout
            .leftSpaceToView(self.scrollView, 0.0f)
            .rightSpaceToView(self.scrollView, 0.0f)
            .topSpaceToView(self.scrollView, 0.0f);
            [contentView setupAutoHeightWithBottomView:spliteView bottomMargin:0.0f];
        }
        self.lastContentView = contentView;
    }];
}

- (void)addAutoLayout
{
    self.nextButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));


    self.scrollView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.nextButton, 0.0f);
    [self.scrollView setupAutoContentSizeWithBottomView:self.lastContentView bottomMargin:0.0f];
}

- (void)buttonClicked:(UIButton *)button
{
    SHGBusinessButtonContentView *superView = (SHGBusinessButtonContentView *)button.superview;
    [superView didClickButton:button];
}

- (IBAction)nextButtonClicked:(UIButton *)sender
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

