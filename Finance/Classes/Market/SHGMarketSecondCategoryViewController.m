//
//  SHGMarketSecondCategoryViewController.m
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSecondCategoryViewController.h"
#import "SHGMarketObject.h"
#import "SHGMarketSecondCategoryTableViewCell.h"
#import "SHGMarketSecondCategoryListTableViewController.h"
#import "SHGMarketListViewController.h"
#define k_ToleftOne 11.0f * XFACTOR
#define k_ToleftTwo 21.0f * XFACTOR
#define k_SectionHeight 40
@interface SHGMarketSecondCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong)NSArray * categoryArray;
@property (nonatomic , strong)NSMutableArray * categoryNameArray;
@property (nonatomic , assign)NSInteger RowHeight;
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
        if (![obj.firstCatalogName isEqualToString: @"热门"]) {
            [self.categoryNameArray addObject:obj.firstCatalogName];
        }
        
    }];
    
}
#pragma mark -- tableView--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryNameArray.count ;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  num;
    SHGMarketFirstCategoryObject * obj = [self.categoryArray objectAtIndex:section + 1];
    if (obj.secondCataLogs.count == 0) {
        num = 0;
    }else{
         num = 1;
    }
    
    return  num;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"SHGMarketSecondCategoryTableViewCell";
    SHGMarketSecondCategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SHGMarketFirstCategoryObject * objf = [self.categoryArray objectAtIndex:indexPath.section +1];
    NSArray * arry = objf.secondCataLogs;
    if (!cell) {
        cell = [[SHGMarketSecondCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSInteger hangNum = 0 ;
        NSInteger buttonToButton = 8.0f;
        NSInteger buttonToTop = 10.0f;
        NSInteger buttonHeight = 30.0f;
        if (!arry.count == 0) {
                for (NSInteger i = 0; i<arry.count; i ++) {
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(i%3 * buttonToButton + i%3*(SCREENWIDTH-k_ToleftTwo*2-buttonToButton*2)/3, i/3*(buttonHeight + buttonToTop) + buttonToTop, (SCREENWIDTH-k_ToleftTwo*2-buttonToButton*2)/3, buttonHeight);
                    button.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
                    [button setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:13];
                    [button addTarget:self action:@selector(secondCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
                    SHGMarketSecondCategoryObject * objs = [arry objectAtIndex:i];
                    [button setTitle:objs.catalogName forState:UIControlStateNormal];
                    [cell.bgView addSubview:button];
                }
            if (arry.count%3 > 0) {
                hangNum = arry.count/3 + 1;
            }else
            {
                hangNum = arry.count/3 ;
            }
            cell.bgView.frame =CGRectMake(k_ToleftTwo, 0, SCREENWIDTH-k_ToleftTwo*2, k_SectionHeight +(hangNum-1) * (buttonHeight+buttonToButton));
            self.RowHeight = cell.bgView.height;
        }
        
      }
    
    return cell;
}

- (void)secondCategoryClick: (UIButton * )btn
{
    SHGMarketSecondCategoryListTableViewController * VC = [[SHGMarketSecondCategoryListTableViewController alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return k_SectionHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height;
    height = self.RowHeight;
    return height;
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger sectionHeight = 50.0f;
    NSInteger titleToTop = 20.0f;
    NSInteger redLineToTop = 25.0f;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, sectionHeight)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(k_ToleftTwo, titleToTop, 100.0, 20.0)];
    title.text = [self.categoryNameArray objectAtIndex:section];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"3A3A3A"];
    DDTapGestureRecognizer *itemGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)];
    itemGes.tag = section;
    [view addGestureRecognizer:itemGes];
    [view addSubview: title];
    UIView * redLine = [[UIView alloc]initWithFrame:CGRectMake(k_ToleftOne, redLineToTop, 1.5, 10.0)];
    redLine.backgroundColor = [UIColor colorWithHexString:@"F5BF9A"];
    [view addSubview:redLine];
    return view;
}

- (void)itemTap: (DDTapGestureRecognizer * )Gesture
{
    if (self.secondCategoryDelegate && [self.secondCategoryDelegate respondsToSelector:@selector(backFromSecondChangeToIndex:)] ) {
        [self.secondCategoryDelegate backFromSecondChangeToIndex:Gesture.tag +1 ];
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
