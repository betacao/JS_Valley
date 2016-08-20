//
//  SHGHomeCategoryView.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGHomeCategoryView.h"
#import "SHGMainPageTableViewCell.h"
#import "SHGUnifiedTreatment.h"
#import "SHGCircleManager.h"
#import "SHGNoticeView.h"
#import "SHGEmptyDataView.h"
#import "UITableView+MJRefresh.h"

@interface SHGHomeCategoryView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SHGNoticeView *newMessageNoticeView;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) BOOL isRefreshing;
@property (assign, nonatomic) BOOL needRefreshTableView;

@end

@implementation SHGHomeCategoryView

+ (instancetype)shareCategoryView
{
    static SHGHomeCategoryView *shareView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareView = [[self alloc] init];
    });
    return shareView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.dataArray = [NSMutableArray array];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = SCREENWIDTH;
    [self.tableView addRefreshFooterWithTarget:self];
    [self.tableView addRefreshHeaderWithTarget:self];
    [self addSubview:self.tableView];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.emptyView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (SHGNoticeView *)newMessageNoticeView
{
    if(!_newMessageNoticeView){
        _newMessageNoticeView = [[SHGNoticeView alloc] initWithFrame:CGRectZero type:SHGNoticeTypeNewMessage];
        _newMessageNoticeView.superView = self;
    }
    return _newMessageNoticeView;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        [self insertSubview:_emptyView belowSubview:self.tableView];
    }
    return _emptyView;
}

- (void)setNeedRefreshTableView:(BOOL)needRefreshTableView
{
    WEAK(self, weakSelf);
    self.tableView.hidden = !(self.dataArray.count > 0);
    if (needRefreshTableView && !_needRefreshTableView) {
        _needRefreshTableView = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            _needRefreshTableView = NO;
        });
    }
}

- (void)setCategory:(NSString *)category
{
    NSDictionary *dictionary = [[SHGGloble sharedGloble] getBusinessKeysAndValues];
    _category = [dictionary objectForKey:category];
    if (!_category) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        [self.dataArray removeAllObjects];
        [self requestDataWithTarget:@"first" time:@""];
    }
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CircleListObj *listObject = (CircleListObj *)obj;
        if ([listObject.userid isEqualToString:targetUserID]) {
            listObject.isAttention = [attationState boolValue];
        }
    }];
    self.needRefreshTableView = YES;
}

- (void)loadPraiseState:(NSString *)targetID praiseState:(NSNumber *)praiseState
{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CircleListObj *listObject = (CircleListObj *)obj;
        if ([listObject.rid isEqualToString:targetID]) {
            listObject.ispraise = [praiseState boolValue] ? @"Y" : @"N";
            if ([praiseState boolValue]) {
                listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] + 1];
            } else {
                listObject.praisenum = [NSString stringWithFormat:@"%ld", (long)[listObject.praisenum integerValue] - 1];
            }
        }
    }];
    self.needRefreshTableView = YES;
}

- (void)refreshHeader
{
    NSLog(@"refreshHeader");
    if(self.isRefreshing){
        return;
    }
    if (self.dataArray.count > 0){
        [self requestDataWithTarget:@"refresh" time:[self refreshMaxRid]];
    } else{
        [self requestDataWithTarget:@"first" time:@""];
    }

}

- (void)refreshFooter
{
    NSLog(@"refreshFooter");
    if (self.dataArray.count > 0){
        [self requestDataWithTarget:@"load" time:[self refreshMinRid]];
    } else{
        [self requestDataWithTarget:@"first" time:@""];
    }
}

- (NSString *)refreshMaxRid
{
    NSString *rid = @"";
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        CircleListObj *obj = [self.dataArray objectAtIndex:i];
        if([obj isKindOfClass:[CircleListObj class]]){
            if([obj.postType isEqualToString:@"normal"] || [obj.postType isEqualToString:@"normalpc"] || [obj.postType isEqualToString:@"business"]){
                rid = obj.rid;
                break;
            }
        }
    }
    return rid;
}

- (NSString *)refreshMinRid
{
    NSString *rid = @"";
    for(NSInteger i = self.dataArray.count - 1; i >= 0; i--){
        CircleListObj *obj = [self.dataArray objectAtIndex:i];
        if([obj isKindOfClass:[CircleListObj class]]){
            if([obj.postType isEqualToString:@"normal"] || [obj.postType isEqualToString:@"normalpc"] || [obj.postType isEqualToString:@"business"]){
                rid = obj.rid;
                break;
            }
        }
    }
    return rid;
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    self.isRefreshing = YES;
    NSInteger rid = [time integerValue];
    NSDictionary *param = @{@"uid":UID, @"busType":self.category, @"target":target, @"rid":@(rid), @"pageSize":@(10)};

    WEAK(self, weakSelf);
    if ([target isEqualToString:@"first"]) {
        [Hud showWait];
    }
    [SHGCircleManager getListDataWithCategory:param block:^(NSArray *array) {
        [Hud hideHud];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.isRefreshing = NO;
        if (array) {
            [weakSelf assembleArray:array target:target];
            weakSelf.needRefreshTableView = YES;
            if (array.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)assembleArray:(NSArray *)array target:(NSString *)target
{
    if ([target isEqualToString:@"first"]){
        [self.dataArray addObjectsFromArray:array];
        [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)self.dataArray.count]];
    } else if ([target isEqualToString:@"refresh"]){
        if (array.count > 0){
            for (NSInteger i = array.count - 1; i >= 0; i--){
                CircleListObj *obj = [array objectAtIndex:i];
                NSLog(@"%@",obj.rid);
                [self.dataArray insertObject:obj atIndex:0];
            }
            [self.newMessageNoticeView showWithText:[NSString stringWithFormat:@"为您加载了%ld条新动态",(long)array.count]];
        } else{
            [self.newMessageNoticeView showWithText:@"暂无新动态，休息一会儿"];
        }
    } else if ([target isEqualToString:@"load"]){
        [self.dataArray addObjectsFromArray:array];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:[self.dataArray objectAtIndex:indexPath.row] keyPath:@"object" cellClass:[SHGMainPageTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGMainPageTableViewCell"];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMainPageTableViewCell" owner:self options:nil] lastObject];
    }
    cell.index = indexPath.row;
    cell.object = [self.dataArray objectAtIndex:indexPath.row];
    cell.delegate = [SHGUnifiedTreatment sharedTreatment];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *object = [self.dataArray objectAtIndex:indexPath.row];

    [[SHGGloble sharedGloble] recordUserAction:object.rid type:@"dynamic_viewAllComment"];
    CircleDetailViewController *controller = [[CircleDetailViewController alloc] init];
    controller.delegate = [SHGUnifiedTreatment sharedTreatment];
    controller.rid = object.rid;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:object.praisenum, kPraiseNum,object.sharenum,kShareNum,object.cmmtnum,kCommentNum, nil];
    controller.itemInfoDictionary = dictionary;
    [[SHGHomeViewController sharedController].navigationController pushViewController:controller animated:YES];
}

@end
