//
//  SHGMarketSecondCategoryViewController.m
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSecondCategoryViewController.h"
#import "SHGMarketObject.h"
@interface SHGMarketSecondCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong)NSArray * categoryArray;
@property (nonatomic , strong)NSMutableArray * categoryNameArray;
@end

@implementation SHGMarketSecondCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"业务";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}
-(NSArray * )categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSArray array];
    }
    return _categoryArray;
}
-(NSMutableArray * )categoryNameArray
{
    if (!_categoryNameArray) {
        _categoryNameArray = [NSMutableArray array];
    }
    return _categoryNameArray;
}

-(void)getArr:(NSArray * )arry
{
    self.categoryArray = arry;
    [self.categoryArray enumerateObjectsUsingBlock:^(SHGMarketFirstCategoryObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.categoryNameArray addObject:obj.firstCatalogName];
    }];
    
}
#pragma mark -- tableView--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryNameArray.count - 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(21, 20, 100, 20)];
    title.text = [self.categoryNameArray objectAtIndex:section + 1];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"3A3A3A"];
    [view addSubview: title];
    UIView * redLine = [[UIView alloc]initWithFrame:CGRectMake(11, 25, 1.5, 10)];
    redLine.backgroundColor = [UIColor colorWithHexString:@"F5BF9A"];
    [view addSubview:redLine];
    return view;
}
@end
