//
//  SHGCircleSearchViewController.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleSearchViewController.h"
#import "SHGCircleManager.h"
#import "SHGCircleSearchResultViewController.h"
#import "EMSearchBar.h"

#define kItemLeftMargin MarginFactor(12.0f)
#define kItemHorizontalMargin MarginFactor(16.0f)
#define kItemVerticalMargin MarginFactor(11.0f)


@interface SHGCircleSearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@end

@implementation SHGCircleSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;

    [self initView];
    [self addAutoLayout];
    WEAK(self, weakSelf);
    [SHGCircleManager loadHotSearchWordFinishBlock:^(NSArray *array) {
        weakSelf.dataArray = [NSArray arrayWithArray:array];
        [weakSelf addHotItem];
    }];
}

- (void)initUI
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.needLineView = NO;
        _searchBar.placeholder = @"请输入业务名称/地区关键字";
        _searchBar.backgroundImageColor = Color(@"f04f46");
    }
    return _searchBar;
}


- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)initView
{
    self.titleLabel.font = FontFactor(15.0f);
}

- (void)addAutoLayout
{
    self.titleLabel.sd_layout
    .topSpaceToView(self.view, MarginFactor(28.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.contentView.sd_layout
    .topSpaceToView(self.titleLabel, MarginFactor(20.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(10.0f));
}

- (void)addHotItem
{
    CGFloat width = ceilf((SCREENWIDTH - 2 * (kItemLeftMargin + kItemHorizontalMargin)) / 3.0f);
    CGFloat height = MarginFactor(35.0f);
    NSInteger row = 0;
    NSInteger col = 0;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        row = i / 3;
        col = i % 3;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.0f;
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor colorWithHexString:@"e1e1e8"].CGColor;
        [button setTitle:[self.dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithHexString:@"feffff"];
        button.titleLabel.font = FontFactor(14.0f);
        CGRect frame = CGRectMake(kItemLeftMargin + col * (kItemHorizontalMargin + width), row * (kItemVerticalMargin + height) , width, height);
        button.frame = frame;
        [self.contentView addSubview:button];
        [self.buttonArray addObject:button];
    }
    CGFloat maxHeight = CGRectGetMaxY(((UIButton *)[self.buttonArray lastObject]).frame);
    self.contentView.sd_resetLayout
    .topSpaceToView(self.titleLabel, MarginFactor(20.0f))
    .leftSpaceToView(self.view, 0.0f)
    .widthIs(SCREENWIDTH)
    .heightIs(maxHeight);

}

- (void)buttonClick:(UIButton *)button
{
    SHGCircleSearchResultViewController *controller = [[SHGCircleSearchResultViewController alloc] init];
    controller.param = @{@"uid":UID ,@"type":@"search" ,@"pageSize":@"10", @"keyword":button.titleLabel.text};
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------搜索的代理
//退出
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[SHGGloble sharedGloble] recordUserAction:searchBar.text type:@"business_search_word"];
    SHGCircleSearchResultViewController *controller = [[SHGCircleSearchResultViewController alloc] init];
    controller.param = @{@"uid":UID ,@"type":@"search" ,@"pageSize":@"10", @"keyword":searchBar.text};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end