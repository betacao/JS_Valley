//
//  SHGBusinessListViewController.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessListViewController.h"
#import "SHGBusinessScrollView.h"
#import "SHGBusinessObject.h"
#import "EMSearchBar.h"

@interface SHGBusinessListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SHGBusinessScrollViewDelegate>
//
@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SHGBusinessScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (assign, nonatomic) CGSize addBusinessSize;
//
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBusinessButton;

@end

@implementation SHGBusinessListViewController

+ (instancetype)sharedController
{
    static SHGBusinessListViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.block) {
        self.block(self.searchBar);
    }

    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];

    NSArray *array = @[@"推荐", @"债权融资", @"股权融资", @"资金方", @"同业混业"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.categoryArray addObject:[[SHGBusinessFirstObject alloc] initWithName:obj]];
    }];
    self.scrollView.categoryArray = self.categoryArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initAddMarketButton];
}

- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

- (SHGBusinessScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[SHGBusinessScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, kBusinessScrollViewHeight)];
        _scrollView.categoryDelegate = self;
    }
    return _scrollView;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton addTarget:self action:@selector(moveToProvincesViewController:) forControlEvents:UIControlEventTouchUpInside];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FontFactor(15.0f);
        self.titleLabel.textColor = [UIColor whiteColor];
        [_titleButton addSubview:self.titleLabel];

        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"market_locationArrow"]];
        [self.titleImageView sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        [_titleButton addSubview:self.titleImageView];
    }
    return _titleButton;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {

        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleButton];
    }
    return _leftBarButtonItem;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.needLineView = NO;
        _searchBar.placeholder = @"请输入业务名称/类型/地区关键字";
        _searchBar.backgroundImageColor = Color(@"d43c33");
    }
    return _searchBar;
}



- (void)initAddMarketButton
{
    if (CGSizeEqualToSize(CGSizeZero, self.addBusinessSize)) {
        self.addBusinessSize = self.addBusinessButton.currentImage.size;
        CGRect frame = self.addBusinessButton.frame;
        frame.size = self.addBusinessSize;
        frame.origin.x = SCREENWIDTH - MarginFactor(17.0f) - self.addBusinessSize.width;
        frame.origin.y = CGRectGetHeight(self.view.frame) - kTabBarHeight - MarginFactor(45.0f) - self.addBusinessSize.height;
        self.addBusinessButton.frame = frame;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageButton:)];
        [self.addBusinessButton addGestureRecognizer:panRecognizer];
    }
}

- (void)panImageButton:(UIPanGestureRecognizer *)recognizer
{
    UIView *touchedView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {

    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.view];
        if (point.x - self.addBusinessSize.width / 2.0f < 0.0f) {
            point.x = self.addBusinessSize.width / 2.0f;
        }
        if (point.x + self.addBusinessSize.width / 2.0f > SCREENWIDTH) {
            point.x = SCREENWIDTH - self.addBusinessSize.width / 2.0f;
        }
        if (point.y + self.addBusinessSize.height / 2.0f > CGRectGetHeight(self.view.frame) - kTabBarHeight) {
            point.y = CGRectGetHeight(self.view.frame) - kTabBarHeight - self.addBusinessSize.height / 2.0f;
        }
        if (point.y - self.addBusinessSize.height / 2.0f  < kBusinessScrollViewHeight) {
            point.y = kBusinessScrollViewHeight + self.addBusinessSize.height / 2.0f;
        }
        [UIView animateWithDuration:0.01f animations:^{
            touchedView.center = point;
        }];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}



- (void)moveToProvincesViewController:(UIButton *)button
{

}

#pragma mark ------tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.scrollView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetHeight(self.scrollView.frame);
}

#pragma mark ------变更城市代理

- (void)changeTitleCityName:(NSString *)city
{
    if ([city isEqualToString:@"其他城市"]) {
        city = @"其他";
    }
    if (![city isEqualToString:self.titleLabel.text] && city.length > 0) {
        self.titleButton.frame = CGRectZero;
        self.titleLabel.text = city;
        [self.titleLabel sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        self.titleButton.size = CGSizeMake(CGRectGetMaxX(self.titleImageView.frame) + MarginFactor(17.0f), CGRectGetHeight(self.titleLabel.frame));

        //        [self cle
    } else if (city.length == 0){
        self.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_AREA];
        [self.titleLabel sizeToFit];
    }
}

- (void)didChangeToIndex:(NSInteger)index firstId:(NSString *)firstId secondId:(NSString *)secondId
{

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
