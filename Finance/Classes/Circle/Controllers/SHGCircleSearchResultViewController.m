//
//  SHGCircleSearchResultViewController.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleSearchResultViewController.h"
#import "SHGEmptyDataView.h"
#import "CircleListObj.h"
#import "SHGCircleManager.h"
#import "SHGCircleSearchTableViewCell.h"

@interface SHGCircleSearchResultViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UILabel *numMessageLabel;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGCircleSearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.tableView.backgroundColor = Color(@"efeeef");
    [self initView];
    [self addAutoLayout];
    [self searchNormalCircleList:@"first" rid:@"-1"];
}
- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}

- (void)initView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.sectionView.backgroundColor = Color(@"f6f6f6");
    self.numMessageLabel.textColor = Color(@"BBBBBB");
    self.numMessageLabel.font = FontFactor(14.0f);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addHeaderRefresh:self.tableView headerRefesh:NO headerTitle:nil andFooter:YES footerTitle:@{@(MJRefreshStateIdle):@"以上为当前动态信息"}];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
    
    self.sectionView.sd_layout
    .heightIs(MarginFactor(41.0f));
    
    self.numMessageLabel.sd_layout
    .topSpaceToView(self.sectionView, 0.0f)
    .leftSpaceToView(self.sectionView, MarginFactor(12.0f))
    .rightSpaceToView(self.sectionView, 0.0f)
    .bottomSpaceToView(self.sectionView, 0.0f);
}

- (void)searchNormalCircleList:(NSString *)target rid:(NSString *)rid
{
    WEAK(self, weakSelf);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:weakSelf.param];
    [dictionary setObject:target forKey:@"target"];
    [dictionary setObject:rid forKey:@"rid"];
    [SHGCircleManager getMyorSearchDataWithParam:dictionary block:^(NSArray *dataArray, NSString *total) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            weakSelf.numMessageLabel.text = [NSString stringWithFormat:@"共%@个搜索结果",total];
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:dataArray];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:dataArray];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.dataArr addObjectsFromArray:dataArray];
            if (dataArray.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }

    }];
    
}
- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self searchNormalCircleList:@"load" rid:[self minrid]];
    } else{
        [self searchNormalCircleList:@"first" rid:@"-1"];
    }
}

- (NSString *)minrid
{
    NSString *rid = @"";
    for (CircleListObj *object in self.dataArr) {
        if ([object.rid compare:rid options:NSNumericSearch] == NSOrderedAscending || [rid isEqualToString:@""]) {
            rid = object.rid;
        }
    }
    return rid;
}

#pragma mark ------tableview 代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = CGRectGetHeight(self.sectionView.frame);
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count == 0 ? 1 : self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGCircleSearchTableViewCell class] contentViewWidth:SCREENWIDTH];
        return height;
    } else{
        return CGRectGetHeight(self.view.frame);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == 0) {
        return self.emptyCell;
    }
    NSString *identifier = @"SHGCircleSearchTableViewCell";
    SHGCircleSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGCircleSearchTableViewCell" owner:self options:nil] lastObject];
    }
    CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    cell.object = obj;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        CircleListObj *obj = [self.dataArr objectAtIndex:indexPath.row];
        CircleDetailViewController *controller = [[CircleDetailViewController alloc] init];
        controller.rid = obj.rid;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
