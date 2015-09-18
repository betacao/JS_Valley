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
@interface ProductListViewController ()
{
    NSMutableArray *itemArr;
    UIView *backView;
    UIButton *addBtn;
    UIButton *searchBtn;
    UIScrollView *backScrollView;
    UIImageView *imageBttomLine;
    NSInteger width;
    NSInteger index;
    UIBarButtonItem *searchItem;
    UIBarButtonItem *addItem;
    UIBarButtonItem *cancelItem;

    UITextField *searchTextField;
    BOOL hasRequestFailed;
    BOOL hasDataFinished;
   // UISearchBar *searchHeader;
}
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic,strong) UIView *titleView;

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
    self.navigationItem.titleView = backView;
    self.navigationItem.rightBarButtonItems =@[addItem];
    self.listTable.tag = 1002;
    [self requestType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:YES andFooter:YES];
}

- (UIView *)titleView
{
    if (!_titleView)
    {
        _titleView =backView;
    }
    return _titleView;
}


-(NSArray *)rightBarButtonItemArr
{
    if (!_rightBarButtonItemArr) {
        
        _rightBarButtonItemArr =@[addItem,searchItem];
        
    }
    return _rightBarButtonItemArr;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addSelect) forControlEvents:UIControlEventTouchUpInside];
        addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
        [addBtn setFrame:CGRectMake(0, 0, 24, 24)];
        
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
        
    }
    return _rightBarButtonItem;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
    }
    
    return _leftBarButtonItem;
}

-(void)requestType
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
        searchTextField.text = @"";
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
-(void)viewDidAppear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{
}
-(void)initSearch
{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 219, 27)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 13.5;
    backView.backgroundColor = RGB(242, 242, 242);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6.8, 13.5, 13.5)];
    imageView.image = [UIImage imageNamed:@"搜索图标"];
    [backView addSubview:imageView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(28.5, 0, 190, 27)];
    searchTextField.font = [UIFont systemFontOfSize:15];
    [searchTextField setReturnKeyType:UIReturnKeySearch];
    searchTextField.delegate = self;
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.placeholder = @"搜索产品";
    [searchTextField setValue:RGB(180, 180, 180)forKeyPath:@"_placeholderLabel.textColor"];

    [backView addSubview:searchTextField];
    
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addSelect) forControlEvents:UIControlEventTouchUpInside];
    addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    [addBtn setFrame:CGRectMake(0, 0, 24, 24)];
    addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchSelect) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setFrame:CGRectMake(0, 0, 27, 27)];

    searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _titleLabel.font = [UIFont fontWithName:@"Palatino" size:17];
    _titleLabel.textColor = TEXT_COLOR;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 24)];

    cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
   // self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addItem, nil];
    //self.navigationItem.titleView = backView;
}

-(void)searchSelect
{
    self.navigationItem.titleView = backView;
    [searchTextField becomeFirstResponder];
     self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addItem,cancelItem, nil];
}
-(void)cancelSearch
{
    [searchTextField resignFirstResponder];
    if (itemArr.count > 0) {
        CirclleItemObj *obj = itemArr[index];
        
        _titleLabel.text = obj.tname;
    }
    self.navigationItem.titleView = _titleLabel;
     self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addItem,searchItem, nil];
}


-(void)addSelect
{
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHSTATE];
    if (![state boolValue])
    {
        [Hud showNoAuthMessage];
    } else{
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
    }
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
        [self.listTable.footer noticeNoMoreData];
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
        item.tag = i+ 1000;
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
        [tname setFont:[UIFont fontWithName:@"Palatino" size:14]];
        [tname setTextColor:TEXT_COLOR];
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
    [searchTextField resignFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [searchTextField resignFirstResponder];
    if (scrollView.tag == 1001)
    {
    }
    else if(scrollView.tag == 1002)
    {
        if (scrollView.contentOffset.y >46 )
        {
            if (self.listTable.tableHeaderView)
            {
                [UIView beginAnimations:nil context:nil];
                
                self.listTable.tableHeaderView = nil;
                if (itemArr.count > 0) {
                    CirclleItemObj *obj = itemArr[index];
                    
                    _titleLabel.text = obj.tname;
                    self.navigationItem.titleView = _titleLabel;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_NAV_TITLEVIEW object:@"1"];
                self.navigationItem.rightBarButtonItems = @[addItem,searchItem];
                [UIView setAnimationDuration:0.4];
                [UIView commitAnimations];
                NSLog(@"NoHeader ===== %f",scrollView.contentOffset.y);

            }
        }
        if (scrollView.contentOffset.y < -46 )
        {
            if (!self.listTable.tableHeaderView) {
                [UIView beginAnimations:nil context:nil];
                self.listTable.tableHeaderView = backScrollView;
                    self.navigationItem.titleView = backView;
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addItem, nil];
                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_NAV_TITLEVIEW object:@"0"];
                [UIView setAnimationDuration:0.4];
                [UIView commitAnimations];
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
    [cell loadDatasWithObj:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHSTATE];
    if (![state boolValue])
    {
        [Hud showNoAuthMessage];
        return;
        
    }
    ProdListObj *obj = self.dataArr[indexPath.row];
    ProdConfigViewController *vc = [[ProdConfigViewController alloc] initWithNibName:@"ProdConfigViewController" bundle:nil];
    vc.obj = obj;
    NSString *type ;
    if ([obj.type isEqualToString:@"pz"])
    {
        type = @"配资";
    }else if ([obj.type isEqualToString:@"xg"])
    {
        type = @"打新股";
    }else if ([obj.type isEqualToString:@"sb"])
    {
        type = @"新三板";
    }else if ([obj.type isEqualToString:@"dx"])
    {
        type = @"定增";

    }
    vc.type= type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - textfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    NSString *transString = [NSString stringWithString:[textField.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self requestDataWithtcode:tcode isHot:ishot target:@"first" name:transString time:@""];
    return YES;
}

@end
