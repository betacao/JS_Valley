//
//  SHGBusinessSearchResultViewController.m
//  Finance
//
//  Created by changxicao on 16/4/14.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessSearchResultViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessTableViewCell.h"
#import "SHGEmptyDataView.h"
#import "SHGBusinessDetailViewController.h"

@interface SHGBusinessSearchResultViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) SHGBusinessSearchType searchType;

@property (strong, nonatomic) IBOutlet SHGBusinssSearchResultHeaderView *sectionView;


@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@end

@implementation SHGBusinessSearchResultViewController

- (instancetype)initWithType:(SHGBusinessSearchType)type
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

    if (self.searchType == SHGBusinessSearchTypeNormal) {
        [self searchNormalBusinessList:@"first" businessId:@"-1"];
    } else{
        [self searchAdvancedBusinessList:@"first" businessId:@"-1"];
    }
}

- (void)tableViewReloadData
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
        if (self.searchType == SHGBusinessSearchTypeNormal) {
            [self searchNormalBusinessList:@"load" businessId:[self minBusinessID]];
        } else{
            [self searchAdvancedBusinessList:@"load" businessId:[self minBusinessID]];
        }

    } else{
        if (self.searchType == SHGBusinessSearchTypeNormal) {
            [self searchNormalBusinessList:@"first" businessId:@"-1"];
        } else{
            [self searchAdvancedBusinessList:@"first" businessId:@"-1"];
        }
    }
}

- (NSString *)minBusinessID
{
    NSString *businessID = @"";
    for (SHGBusinessObject *object in self.dataArr) {
        if ([object.businessID compare:businessID options:NSNumericSearch] == NSOrderedAscending || [businessID isEqualToString:@""]) {
            businessID = object.businessID;
        }
    }
    return businessID;
}

- (void)searchNormalBusinessList:(NSString *)target businessId:(NSString *)businessId
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.param];
    [dictionary setObject:target forKey:@"target"];
    [dictionary setObject:businessId forKey:@"businessId"];

    [SHGBusinessManager getMyorSearchDataWithParam:dictionary block:^(NSArray *dataArray, NSString *total) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            weakSelf.sectionView.totalCount = total;
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

- (void)searchAdvancedBusinessList:(NSString *)target businessId:(NSString *)businessId
{

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
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGBusinessTableViewCell class] contentViewWidth:SCREENWIDTH];
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
    NSString *identifier = @"SHGBusinessTableViewCell";
    SHGBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessTableViewCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        SHGBusinessDetailViewController *controller = [[SHGBusinessDetailViewController alloc] init];
        SHGBusinessObject *object = [self.dataArr objectAtIndex:indexPath.row];
        controller.object = object;
        [self.navigationController pushViewController:controller animated:YES];
        [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", object.businessID, object.type] type:@"business_search"];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end


@interface SHGBusinssSearchResultHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SHGBusinssSearchResultHeaderView

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.leftLabel.font = FontFactor(15.0f);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftLabelClick:)];
    [self.leftLabel addGestureRecognizer:recognizer];
    self.leftLabel.userInteractionEnabled = YES;

    [self.arrowButton sizeToFit];
    self.rightLabel.font = FontFactor(14.0f);
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

- (void)setType:(SHGBusinessSearchType)type
{
    _type = type;
    if (type == SHGBusinessSearchTypeNormal) {
        self.leftLabel.text = @"更多搜索条件";
        self.arrowButton.hidden = YES;
    } else{
        self.leftLabel.text = @"显示搜索条件";
        self.arrowButton.hidden = NO;
    }
}

- (void)leftLabelClick:(UITapGestureRecognizer *)recognizer
{
}

@end
