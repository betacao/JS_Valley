//
//  SHGMarketSearchViewController.m
//  Finance
//
//  Created by changxicao on 16/2/3.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketSearchViewController.h"
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

    self.dataArray = @[@"上海", @"北京", @"南京", @"融资", @"投资", @"优劣项目", @"PE/VC", @"通道业务", @"同业业务"];

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;

    [self initView];
    [self addAutoLayout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addHotItem];
    });
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
                button.titleLabel.font = [UIFont systemFontOfSize:FontFactor(16.0f)];
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
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(16.0f)];

    self.moreLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
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
    CGFloat height = FontFactor(35.0f);
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
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"feffff"]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
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

#pragma mark ------搜索的代理
//退出
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
