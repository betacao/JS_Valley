//
//  SHGMarketSearchResultViewController.m
//  Finance
//
//  Created by changxicao on 16/2/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketSearchResultViewController.h"
#import "SHGMarketManager.h"
#import "SHGMarketTableViewCell.h"
#import "SHGMarketSegmentViewController.h"
#import "SHGMarketAdvancedSearchViewController.h"
#import "SHGEmptyDataView.h"

@interface SHGMarketSearchResultViewController ()<UITableViewDataSource, UITableViewDelegate, SHGMarketTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) SHGMarketSearchType searchType;

@property (strong, nonatomic) IBOutlet SHGMarketSearchResultHeaderView *sectionView;


@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGMarketSearchResultViewController

- (instancetype)initWithType:(SHGMarketSearchType)type
{
    self = [super init];
    if (self) {
        self.searchType = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"搜索结果";

    [self initView];
    [self addAutoLayout];

    self.sectionView.parentController = self;
    self.sectionView.type = self.searchType;
    
    if (self.searchType == SHGMarketSearchTypeNormal) {
        [self searchNormalMarketList:@"first" marketId:@"-1"];
    } else{
        [self searchAdvancedMarketList:@"first" marketId:@"-1"];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
}

- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        if (self.searchType == SHGMarketSearchTypeNormal) {
            [self searchNormalMarketList:@"load" marketId:[self minMarketID]];
        } else{
            [self searchAdvancedMarketList:@"load" marketId:[self minMarketID]];
        }

    } else{
        if (self.searchType == SHGMarketSearchTypeNormal) {
            [self searchNormalMarketList:@"first" marketId:@"-1"];
        } else{
            [self searchAdvancedMarketList:@"first" marketId:@"-1"];
        }
    }
}

- (NSString *)minMarketID
{
    NSString *marketID = @"";
    for (SHGMarketObject *object in self.dataArr) {
        if ([object.marketId compare:marketID options:NSNumericSearch] == NSOrderedAscending || [marketID isEqualToString:@""]) {
            marketID = object.marketId;
        }
    }
    return marketID;
}

- (void)searchNormalMarketList:(NSString *)target marketId:(NSString *)marketId
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.param];
    [dictionary setObject:target forKey:@"target"];
    [dictionary setObject:marketId forKey:@"marketId"];

    [SHGMarketManager searchNormalMarketList:dictionary block:^(NSString *count, NSArray *array) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        weakSelf.sectionView.totalCount = count;
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            if (array.count < 10) {
                [weakSelf.tableView.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)searchAdvancedMarketList:(NSString *)target marketId:(NSString *)marketId
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.advancedParam];
    [dictionary setObject:target forKey:@"target"];
    [dictionary setObject:marketId forKey:@"marketId"];

    [SHGMarketManager searchAdvancedMarketList:dictionary block:^(NSString *count, NSArray *array) {

        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        weakSelf.sectionView.totalCount = count;
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"refresh"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        } else if([target isEqualToString:@"load"]){
            [weakSelf.dataArr addObjectsFromArray:array];
            if (array.count < 10) {
                [weakSelf.tableView.footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    }];
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
        SHGMarketObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGMarketTableViewCell class] contentViewWidth:SCREENWIDTH];
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
    NSString *identifier = @"SHGMarketTableViewCell";
    SHGMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    [cell loadNewUiFortype:SHGMarketTableViewCellTypeAll];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGMarketDetailViewController *controller = [[SHGMarketDetailViewController alloc] init];
        controller.object = [self.dataArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }

}


#pragma mark ------ tableViewCellDelegate

- (void)clickCollectButton:(SHGMarketObject *)object state:(void (^)(BOOL))block
{
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:object state:^(BOOL state) {
//        block(state);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end


@interface SHGMarketSearchResultHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SHGMarketSearchResultHeaderView

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.leftLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftLabelClick:)];
    [self.leftLabel addGestureRecognizer:recognizer];
    self.leftLabel.userInteractionEnabled = YES;

    [self.arrowButton sizeToFit];
    self.rightLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
}

- (void)addAutoLayout
{
    self.sd_layout
    .heightIs(MarginFactor(41.0f));

    self.leftLabel.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self)
    .autoHeightRatio(0.0f);
    [self.leftLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    CGSize size = self.arrowButton.frame.size;
    self.arrowButton.sd_layout
    .leftSpaceToView(self.leftLabel, MarginFactor(7.0f))
    .centerYEqualToView(self)
    .widthIs(size.width)
    .heightIs(size.height);

    self.rightLabel.sd_layout
    .rightSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self)
    .autoHeightRatio(0.0f);
    [self.rightLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.bottomLine.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self,0.0f)
    .heightIs(0.5f);
}

- (void)setTotalCount:(NSString *)totalCount
{
    _totalCount = totalCount;
    self.rightLabel.text = [NSString stringWithFormat:@"共%@个搜索结果",totalCount];
    [self.rightLabel updateLayout];
}

- (void)setType:(SHGMarketSearchType)type
{
    _type = type;
    if (type == SHGMarketSearchTypeNormal) {
        self.leftLabel.text = @"更多搜索条件";
        self.arrowButton.hidden = YES;
    } else{
        self.leftLabel.text = @"显示搜索条件";
        self.arrowButton.hidden = NO;
    }
}

- (void)leftLabelClick:(UITapGestureRecognizer *)recognizer
{
    if (self.type == SHGMarketSearchTypeNormal) {
        SHGMarketAdvancedSearchViewController *controller = [[SHGMarketAdvancedSearchViewController alloc] init];
        [self.parentController.navigationController pushViewController:controller animated:YES];
    } else{
        [self.parentController.navigationController popViewControllerAnimated:YES];
    }
}

@end