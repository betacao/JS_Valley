//
//  SHGMarketSearchViewController.m
//  Finance
//
//  Created by changxicao on 16/2/3.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketSearchViewController.h"
#import "SHGMarketManager.h"
#import "SHGMarketAdvancedSearchViewController.h"
#import "SHGMarketSearchResultViewController.h"

#define kItemLeftMargin MarginFactor(14.0f)
#define kItemHorizontalMargin MarginFactor(16.0f)
#define kItemVerticalMargin MarginFactor(11.0f)

@interface SHGMarketSearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@end

@implementation SHGMarketSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

    [self initView];
    [self addAutoLayout];
    __weak typeof(self) weakSelf = self;
    [SHGMarketManager loadHotSearchWordFinishBlock:^(NSArray *array) {
        weakSelf.dataArray = [NSArray arrayWithArray:array];
        [weakSelf addHotItem];
    }];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, 44.0f)];
        _searchBar.delegate = self;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 3.0f;
        _searchBar.showsCancelButton = YES;
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.placeholder = @"请输入业务名称/类型/地区关键字";
        [_searchBar setImage:[UIImage imageNamed:@"market_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        UIView *view = [_searchBar.subviews firstObject];
        for (id object in view.subviews) {
            if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)object;
                textField.textColor = [UIColor whiteColor];
                textField.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
                [textField setValue:[UIColor colorWithHexString:@"F67070"] forKeyPath:@"_placeholderLabel.textColor"];
                textField.enablesReturnKeyAutomatically = NO;
            } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            } else{
                UIButton *button = (UIButton *)object;
                self.backButton = button;
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
                button.enabled = YES;
            }
        }
        [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"market_searchBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
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
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.moreLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.moreLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *recogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdvancedSearchController:)];
    [self.moreLabel addGestureRecognizer:recogizer];
    [self.moreLabel sizeToFit];

    [self.moreImageView sizeToFit];
}

- (void)addAutoLayout
{
    CGSize size = self.titleLabel.frame.size;

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

    size = self.moreImageView.frame.size;
    self.moreImageView.sd_layout
    .topSpaceToView(self.contentView, MarginFactor(26.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .widthIs(size.width)
    .heightIs(size.height);

    self.moreLabel.sd_layout
    .centerYEqualToView(self.moreImageView)
    .rightSpaceToView(self.moreImageView, MarginFactor(10.0f))
    .autoHeightRatio(0.0f);
    [self.moreLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
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
        button.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
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
    SHGMarketSearchResultViewController *controller = [[SHGMarketSearchResultViewController alloc] initWithType:SHGMarketSearchTypeNormal];
    controller.param = @{@"uid":UID ,@"type":@"searcher" ,@"pageSize":@"10", @"marketName":button.titleLabel.text};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushToAdvancedSearchController:(UITapGestureRecognizer *)recognizer
{
    SHGMarketAdvancedSearchViewController *controller = [[SHGMarketAdvancedSearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------搜索的代理
//退出
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SHGMarketSearchResultViewController *controller = [[SHGMarketSearchResultViewController alloc] initWithType:SHGMarketSearchTypeNormal];
    controller.param = @{@"uid":UID ,@"type":@"searcher" ,@"pageSize":@"10", @"marketName":searchBar.text};
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
