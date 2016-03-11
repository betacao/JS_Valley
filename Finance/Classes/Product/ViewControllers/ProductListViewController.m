//
//  ProductListViewController.m
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProductListViewController.h"
#import "CirclleItemObj.h"
#import "ProdListObj.h"
#import "ProductListTableViewCell.h"
#import "AppDelegate.h"
#import "VerifyIdentityViewController.h"
@interface ProductListViewController ()
{
    NSMutableArray *itemArr;
    UIScrollView *backScrollView;
    UIImageView *imageBttomLine;
    NSInteger width;
    NSInteger index;
    BOOL hasRequestFailed;
    BOOL hasDataFinished;
}
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIBarButtonItem *searchItem;
@property (strong, nonatomic) UIBarButtonItem *addItem;
@property (strong, nonatomic) UIBarButtonItem *cancelItem;
@property (nonatomic ,strong) UILabel *titleLabel;
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!itemArr)
    {
        itemArr = [NSMutableArray array];
    }
    _noDataLabel.hidden = YES;
    [self.view bringSubviewToFront:_noDataLabel];
    index = 0;
    [self initSearch];
    self.navigationItem.rightBarButtonItem = self.addItem;
    self.listTable.tag = 1002;
    [self requestType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:YES andFooter:YES];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor colorWithHexString:@"d43c33"];
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.placeholder = @"输入产品名称";
        [_searchBar setImage:[UIImage imageNamed:@"market_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        UIView *view = [_searchBar.subviews firstObject];
        for (id object in view.subviews) {
            if ([object isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)object;
                textField.textColor = [UIColor whiteColor];
                textField.enablesReturnKeyAutomatically = NO;
                [textField setValue:[UIColor colorWithHexString:@"F67070"] forKeyPath:@"_placeholderLabel.textColor"];
            } else if ([object isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            } else{

            }
        }
        [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"market_searchBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    }
    return _searchBar;
}

- (void)requestType
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"type"];
    [MOCHTTPRequestOperationManager getWithURL:url class:[CirclleItemObj class] parameters:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.dataArray);
        CirclleItemObj *obj = [[CirclleItemObj alloc] init];
        obj.tname = @"热门";
        obj.timg = @"热门";
        obj.tcode = @"";
        [itemArr addObject:obj];
        if (response.dataArray.count > 0)
        {
            [itemArr addObjectsFromArray:response.dataArray];
            
        }
        [self initHeader];

    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);
    }];
}

-(void)requestDataWithtcode:(NSString *)tcode isHot:(NSString*)isHot target:(NSString*)target name:(NSString *)name time:(NSString *)time
{
    if ([target isEqualToString:@"first"])
    {
        [self.listTable.footer resetNoMoreData];
        hasDataFinished = NO;
    }
    [Hud showLoadingWithMessage:@"加载中"];
    if (IsStrEmpty(name)) {
        self.searchBar.text = @"";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [param setObject:uid forKey:@"uid"];
    [param setObject:name forKey:@"name"];
    [param setObject:tcode forKey:@"tcode"];
    [param setObject:isHot forKey:@"ishot"];
    [param setObject:target forKey:@"target"];
    [param setObject:time forKey:@"time"];
    [param setObject:rRequestNum forKey:@"num"];
    if (IsStrEmpty(name))
    {
        [param removeObjectForKey:@"name"];
    }
    if (IsStrEmpty(isHot)) {
        [param removeObjectForKey:@"ishot"];
    }
    if (IsStrEmpty(tcode)) {
        [param removeObjectForKey:@"tcode"];
    }
    if (IsStrEmpty(time)) {
        [param removeObjectForKey:@"time"];

    }
    [MOCHTTPRequestOperationManager getWithURL:rBaseAddressForHttpProd class:[ProdListObj class]parameters:param success:^(MOCHTTPResponse *response) {
       
        if (IsArrEmpty(response.dataArray)) {
            hasDataFinished = YES;
        }
        else
        {
            hasDataFinished = NO;
        }
        hasRequestFailed = NO;
        NSLog(@"%@",response.dataArray);
        if ([target isEqualToString:@"first"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:response.dataArray];

        }
        if ([target isEqualToString:@"refresh"]) {
            if (response.dataArray.count > 0) {
                for (NSInteger i = response.dataArray.count-1; i >= 0; i --) {
                    ProdListObj *obj = response.dataArray[i];
                    [self.dataArr insertObject:obj atIndex:0];
                }
                
            }
        }
        if ([target isEqualToString:@"load"]) {
            [self.dataArr addObjectsFromArray:response.dataArray];

        }
        if (self.dataArr.count > 0) {
            _noDataLabel.hidden = YES;

        }
        else
        {
            _noDataLabel.hidden = NO;

        }
        [self.listTable reloadData];
        [self.listTable.header endRefreshing];
        [self.listTable.footer endRefreshing];
        [Hud hideHud];

    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        hasRequestFailed = YES;
        NSLog(@"%@",response.errorMessage);
        [self.listTable.header endRefreshing];
         [self performSelector:@selector(endrefresh) withObject:nil afterDelay:1.0];
    }];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.searchBar;
}

- (void)initSearch
{

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"发布" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addSelect) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [addBtn sizeToFit];
    self.addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];


    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"marketSearch"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchSelect) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn sizeToFit];

    self.searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.textColor = TEXT_COLOR;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn sizeToFit];
    self.cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
}

- (void)searchSelect
{
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addItem,self.cancelItem, nil];
}

- (void)cancelSearch
{
    [self.searchBar resignFirstResponder];
    if (itemArr.count > 0) {
        CirclleItemObj *obj = itemArr[index];
        self.titleLabel.text = obj.tname;
    }
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addItem,self.searchItem, nil];
}


- (void)addSelect
{
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            __weak typeof(self)weakSelf = self;
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否需要发布产品?" leftButtonTitle:@"否" rightButtonTitle:@"是"];
            alert.rightBlock = ^{
                NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,@"publish"];
                [Hud showLoadingWithMessage:@"加载中"];
                NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
                [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                    [Hud hideHud];
                    NSString *code = [response.data valueForKey:@"code"];
                    if ([code isEqualToString:@"000"]) {

                        ProdSubViewController *vc = [[ProdSubViewController alloc] initWithNibName:@"ProdSubViewController" bundle:nil];
                        [MobClick event:@"ProductAddController" label:@"onClick"];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                } failed:^(MOCHTTPResponse *response) {
                    [Hud hideHud];

                    [Hud showMessageWithText:response.errorMessage];
                }];

            };
            [alert show];
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能发布产品哦～"];
}
-(void)refreshHeader
{
    if (IsArrEmpty(itemArr)) {
        [self requestType];
        [self.listTable.header endRefreshing];
        return;

    }
    CirclleItemObj *obj = itemArr[index];
    NSString *tcode = @"";
    NSString *ishot = @"";
    if (!IsStrEmpty(obj.tcode)) {
        tcode = obj.tcode;
    }
    else
    {
        ishot = @"1";
    }
    NSString *time = @"";
    NSString *target = @"first";
    if (self.dataArr.count > 0) {
      ProdListObj *firObj = self.dataArr[0];
        target = @"refresh";
        time = firObj.time;
    }
    [self requestDataWithtcode:tcode isHot:ishot target:target name:@"" time:time ];
}
-(void)chageValue
{
    hasRequestFailed = NO;
}

-(void)endrefresh
{
    [self.listTable.footer endRefreshing];

}
-(void)refreshFooter
{
    if (hasDataFinished) {
        [self.listTable.footer endRefreshingWithNoMoreData];
        return;
    }
    NSLog(@"freshFooter");
    if (IsArrEmpty(itemArr)) {
        [self.listTable.footer endRefreshing];
        return;

    }
    CirclleItemObj *obj = itemArr[index];
    NSString *time = @"";
    if (self.dataArr.count > 0) {
        ProdListObj *firObj = [self.dataArr lastObject];
        time = firObj.time;
    }
  

    NSString *tcode = @"";
    NSString *ishot = @"";
    if (!IsStrEmpty(obj.tcode)) {
        tcode = obj.tcode;
    }
    else
    {
        ishot = @"1";
    }
    [self requestDataWithtcode:tcode isHot:ishot target:@"load" name:@"" time:time ];
}

-(void)initHeader
{
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 108)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    NSInteger itemWidth = SCREENWIDTH/5;
    NSInteger contentWidth = SCREENWIDTH ;
    backScrollView.tag = 1001;
    if (IsArrEmpty(itemArr)) {
        return;
    }
    if (itemArr.count < 5)
    {
        itemWidth = SCREENWIDTH/itemArr.count;
    }
    width = itemWidth;
    for (int i = 0; i < itemArr.count ;i ++)
    {
        CirclleItemObj *obj = itemArr[i];
        UILabel *item = [[UILabel alloc] init];
        item.userInteractionEnabled = YES;
        [item setFrame:CGRectMake(itemWidth *i, 0, itemWidth, 80)];
        item.tag = i + 1000;
        UIImageView *timg = [[UIImageView alloc] initWithFrame:CGRectMake((itemWidth/2-21), 10, 42, 42)];
        timg.layer.masksToBounds = YES;
        timg.layer.cornerRadius = 21;
        DDTapGestureRecognizer *itemGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)];
        itemGes.tag = i;
        [item addGestureRecognizer:itemGes];
        if (i == 0) {
            [timg setImage:[UIImage imageNamed:obj.timg]];
        }
        else{
           [timg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.timg]] placeholderImage:[UIImage imageNamed:@"default_image"]];}
        [item addSubview:timg];
        
        UILabel *tname = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, itemWidth, 20)];
        [tname setFont:[UIFont systemFontOfSize:14.0f]];
        [tname setTextColor: [UIColor blackColor]];
        [tname setTextAlignment:NSTextAlignmentCenter];
        [tname setText:obj.tname];
        [item addSubview:tname];
        [backScrollView addSubview:item];
    }
    if (itemArr.count > 5)
    {
        contentWidth = (SCREENWIDTH/5) * itemArr.count;
    }
    UIView *backsView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREENHEIGHT, 8)];
    backsView.backgroundColor = RGB(242, 242, 242);
    imageBttomLine = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth/2-20, 0, 40, 1)];
    [imageBttomLine setImage:[UIImage imageNamed:@"tab下划线"]];
    [backsView addSubview:imageBttomLine];
    
    [backScrollView addSubview:backsView];
    
    [backScrollView setContentSize:CGSizeMake(contentWidth, 93)];

    self.listTable.tableHeaderView = backScrollView;
    
    [self requestDataWithtcode:@"" isHot:@"1" target:@"first" name:@"" time:@""];
}

-(void)itemTap:(DDTapGestureRecognizer *)ges
{
    index =ges.tag;
    CGRect rect = imageBttomLine.frame;
    rect.origin.x = (width/2-20) +( ges.tag* width);

    CirclleItemObj *obj = itemArr[ges.tag];
    if (ges.tag == 0) {
        [self requestDataWithtcode:obj.tcode isHot:@"1" target:@"first" name:@"" time:@""];
    }else
    {
        [self requestDataWithtcode:obj.tcode isHot:@"" target:@"first" name:@"" time:@""];
    }
    [UIView beginAnimations:nil context:nil];
    [imageBttomLine setFrame:rect];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called when scroll view grinds to a halt

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.searchBar resignFirstResponder];
    if (scrollView.tag == 1001){
    } else if(scrollView.tag == 1002){
        if (scrollView.contentOffset.y > 46.0f){
            if (self.listTable.tableHeaderView){
                self.listTable.tableHeaderView = nil;
                if (itemArr.count > 0) {
                    CirclleItemObj *obj = itemArr[index];
                    self.titleLabel.text = obj.tname;
                    self.navigationItem.titleView = self.titleLabel;
                }
                self.navigationItem.rightBarButtonItems = @[self.addItem,self.searchItem];
            }
        }
        if (scrollView.contentOffset.y < -46.0f){
            if (!self.listTable.tableHeaderView) {
                self.listTable.tableHeaderView = backScrollView;
                self.navigationItem.titleView = self.searchBar;
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addItem, nil];
            }
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductListTableViewCell" owner:self options:nil] lastObject];
    }
    ProdListObj *obj = self.dataArr[indexPath.row];
    cell.object = obj;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(116.0f);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            ProdListObj *obj = self.dataArr[indexPath.row];
            ProdConfigViewController *vc = [[ProdConfigViewController alloc] initWithNibName:@"ProdConfigViewController" bundle:nil];
            vc.obj = obj;
            NSString *type ;
            if ([obj.type isEqualToString:@"pz"]){
                type = @"配资";
            } else if ([obj.type isEqualToString:@"xg"]){
                type = @"打新股";
            } else if ([obj.type isEqualToString:@"sb"]){
                type = @"新三板";
            } else if ([obj.type isEqualToString:@"dx"]){
                type = @"定增";
            }
            vc.type= type;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能进行操作哦～"];

}

#pragma mark - textfieldDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    CirclleItemObj *obj = itemArr[index];
    NSString *tcode = @"";
    NSString *ishot = @"";
    if (!IsStrEmpty(obj.tcode)) {
        tcode = obj.tcode;
    }
    else
    {
        ishot = @"1";
    }
    NSString *transString = [NSString stringWithString:[searchBar.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self requestDataWithtcode:tcode isHot:ishot target:@"first" name:transString time:@""];
//    return YES;
}

@end
