//
//  SHGDiscoverySearchViewController.m
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoverySearchViewController.h"
#import "EMSearchBar.h"

@interface SHGDiscoverySearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SHGDiscoverySearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"人脉搜索";
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    [self.view addSubview:self.searchBar];

    self.tableView.tableFooterView = [[UIView alloc] init];

    self.middleImageView.image = [UIImage imageNamed:@"discovery_search"];
}

- (void)addAutoLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);

    self.middleImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.searchBar, MarginFactor(65.0f))
    .widthIs(self.middleImageView.image.size.width)
    .heightIs(self.middleImageView.image.size.height);

}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
