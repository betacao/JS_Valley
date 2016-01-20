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
#import "SHGSecondCategoryButton.h"
#import "SHGMarketManager.h"

#define k_ToleftOne 11.0f * XFACTOR
#define k_ToleftTwo 21.0f * XFACTOR
#define k_SectionHeight 40
@interface SHGMarketSecondCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong)NSArray * categoryArray;
@property (nonatomic , strong)NSMutableArray * categoryNameArray;
@property (nonatomic , assign)NSInteger RowHeight;
@property (nonatomic , assign)NSInteger firstCategoryIndex;
@end

@implementation SHGMarketSecondCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"业务";
    
    [[SHGMarketManager shareManager] userListArray:^(NSArray *array) {
        self.categoryArray = array;
    }];
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

#pragma mark -- tableView--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryNameArray.count ;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"SHGMarketSecondCategoryTableViewCell";
    SHGMarketSecondCategoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SHGMarketFirstCategoryObject * objf = [self.categoryArray objectAtIndex:indexPath.section +2];
    NSArray * arry = objf.secondCataLogs;
    if (!cell) {
        cell = [[SHGMarketSecondCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSInteger hangNum = 0 ;
        NSInteger buttonToButton = 8.0f;
        NSInteger buttonToTop = 10.0f;
        NSInteger buttonHeight = 30.0f;
        if (!arry.count == 0) {
                for (NSInteger i = 0; i<arry.count; i ++) {
                    SHGSecondCategoryButton * button = [SHGSecondCategoryButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(i%3 * buttonToButton + i%3*(SCREENWIDTH-k_ToleftTwo*2-buttonToButton*2)/3, i/3*(buttonHeight + buttonToTop) + buttonToTop, (SCREENWIDTH-k_ToleftTwo*2-buttonToButton*2)/3, buttonHeight);
                    button.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
                    [button setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:13];
                    [button addTarget:self action:@selector(secondCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
                    SHGMarketSecondCategoryObject * objs = [arry objectAtIndex:i];
                    button.firstCategory = objf.firstCatalogId;
                    button.secondId = objs.secondCatalogId;
                    button.seocndName = objs.secondCatalogName;
                    [button setTitle:objs.secondCatalogName forState:UIControlStateNormal];
                    button.tag = i ;
                    [cell.bgView addSubview:button];
                }
            if (arry.count%3 > 0) {
                hangNum = arry.count/3 + 1;
            }else
            {
                hangNum = arry.count/3 ;
            }
            cell.bgView.frame =CGRectMake(k_ToleftTwo, 0, SCREENWIDTH-k_ToleftTwo*2, k_SectionHeight +(hangNum-1) * (buttonHeight+buttonToButton));
            cell.lineView.frame = CGRectMake(0, cell.bgView.bottom + buttonToTop, SCREENWIDTH, 0.5f);
        }else{
            cell.bgView.frame =CGRectMake(0, 0, SCREENWIDTH, 5.0f);
            cell.lineView.frame = CGRectMake(0, cell.bgView.bottom - 1.0f , SCREENWIDTH, 0.5f);
        }
        if (indexPath.section + 1 == self.categoryNameArray.count) {
            cell.lineView.hidden = YES;
        }
        self.RowHeight = cell.bgView.height;

      }
    
    return cell;
}

- (void)secondCategoryClick: (SHGSecondCategoryButton * )btn
{
    SHGMarketSecondCategoryListTableViewController * VC = [[SHGMarketSecondCategoryListTableViewController alloc]init];
    [VC fromSecondCategore:btn.firstCategory seocndName:btn.seocndName secondId:btn.secondId];
    [self.navigationController pushViewController:VC animated:YES];
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
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(k_ToleftTwo, titleToTop, 100.0f, 20.0f)];
    title.text = [self.categoryNameArray objectAtIndex:section];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"3A3A3A"];
    DDTapGestureRecognizer *itemGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTap:)];
    itemGes.tag = section;
    [view addGestureRecognizer:itemGes];
    [view addSubview: title];
    UIView * redLine = [[UIView alloc]initWithFrame:CGRectMake(k_ToleftOne, redLineToTop, 1.5f, 10.0f)];
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
