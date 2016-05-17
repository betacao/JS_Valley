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
#import "SHGBusinessScrollView.h"
#import "SHGBusinessListViewController.h"

@interface SHGBusinessSelectCategoryViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSArray *listArray;
@property (strong, nonatomic) UIView *lastContentView;
@end

@implementation SHGBusinessSelectCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择分类";
    self.view.backgroundColor = Color(@"efeeef");
    self.nextButton.backgroundColor = Color(@"f04241");
    [self.nextButton setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    [[SHGBusinessManager shareManager] getSecondListBlock:^(NSArray *array, NSString *cityName) {
        if (array) {
            weakSelf.listArray = array;
            [weakSelf initViewWithArray:array];
            [weakSelf addAutoLayout];
        }
    }];
}

- (void)initViewWithArray:(NSArray *)array
{
    [[SHGBusinessListViewController sharedController] loadFilterTitleAndParam:^(NSArray *titleArray, NSDictionary *param, NSArray *selectedArray) {

        [array enumerateObjectsUsingBlock:^(SHGBusinessSecondObject *secondObject, NSUInteger idx, BOOL * _Nonnull stop) {
            SHGBusinessButtonContentView *contentView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeExclusiveChoice];
            contentView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:contentView];

            UILabel *titleLabel = [[UILabel alloc] init];
            [contentView addSubview:titleLabel];
            titleLabel.font = FontFactor(13.0f);
            titleLabel.textColor = Color(@"161616");
            titleLabel.text = secondObject.title;

            titleLabel.sd_layout
            .topSpaceToView(contentView, 0.0f)
            .leftSpaceToView(contentView, kLeftToView)
            .rightSpaceToView(contentView, 0.0f)
            .heightIs(MarginFactor(30.0f) + titleLabel.font.lineHeight);

            __block UIButton *lastButton = nil;
            CGFloat width = ceilf((SCREENWIDTH - kLeftToView * (self.columnsInOnerow + 1)) / self.columnsInOnerow);
            [secondObject.subArray enumerateObjectsUsingBlock:^(SHGBusinessSecondsubObject *subObject, NSUInteger idx, BOOL * _Nonnull stop) {

                SHGCategoryButton *button = [SHGCategoryButton buttonWithType:UIButtonTypeCustom];
                NSInteger row = idx / self.columnsInOnerow;
                NSInteger col = idx % self.columnsInOnerow;
                CGRect frame = CGRectMake((col + 1) * kLeftToView + col * width, row * (MarginFactor(36.0f) + MarginFactor(10.0f)) + MarginFactor(30.0f) + ceilf(titleLabel.font.lineHeight), width, MarginFactor(36.0f));
                button.frame = frame;
                button.object = subObject;
                [button setTitle:subObject.value forState:UIControlStateNormal];
                [button setTitleColor:Color(@"111111") forState:UIControlStateNormal];
                [button setTitleColor:Color(@"f33300") forState:UIControlStateSelected];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[[UIImage imageNamed:@"business_unSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
                [button setBackgroundImage:[[UIImage imageNamed:@"business_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 1.0f, 1.0f, 15.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
                button.titleLabel.font = FontFactor(13.0f);
                lastButton = button;

                [contentView addSubview:button];
                if ([selectedArray containsObject:subObject]) {
                    button.selected = YES;
                }
            }];

            UIView *spliteView = [[UIView alloc] init];
            spliteView.backgroundColor = Color(@"efeeef");
            [contentView addSubview:spliteView];

            spliteView.sd_layout
            .topSpaceToView(lastButton, MarginFactor(10.0f))
            .leftSpaceToView(contentView, 0.0f)
            .rightSpaceToView(contentView, 0.0f)
            .heightIs(MarginFactor(12.0f));
            if (idx == array.count - 1) {
                spliteView.hidden = YES;
            }

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
    }];
}

- (void)addAutoLayout
{
    self.nextButton.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));


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
    NSMutableDictionary *codeParam = [NSMutableDictionary dictionary];
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *selectedArray = [NSMutableArray array];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(SHGBusinessButtonContentView *contentView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([contentView isKindOfClass:[SHGBusinessButtonContentView class]]) {
            NSString *key = ((SHGBusinessSecondObject *)[self.listArray objectAtIndex:idx]).key;
            __block NSString *codeValue = @"";

            NSArray *array = [contentView selectedArray];
            [array enumerateObjectsUsingBlock:^(SHGBusinessSecondsubObject *subObject, NSUInteger idx, BOOL * _Nonnull stop) {
                codeValue = [codeValue stringByAppendingFormat:@"%@;",subObject.code];
                if ([subObject.value isEqualToString:@"不限"]) {
                    subObject.superCode = key;
                } else {
                    [titleArray addObject:subObject];
                }
                [selectedArray addObject:subObject];
            }];
            //去除多余的一个分号
            if (codeValue.length > 0) {
                codeValue = [codeValue substringToIndex:codeValue.length - 1];
                [codeParam setObject:codeValue forKey:key];
            }
        }

    }];
    if (self.selectedBlock) {
        self.selectedBlock(codeParam, titleArray, selectedArray, NO);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

