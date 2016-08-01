/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "GroupListViewController.h"
#import "SRRefreshView.h"
#import "BaseTableViewCell.h"
#import "ChatViewController.h"
#import "CreateGroupViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "UIViewController+HUD.h"
#import "AppDelegate.h"
#import "ChatListViewController.h"
#import "PublicGroupDetailViewController.h"
#define kImageViewLeftMargin 15.0f

@interface GroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, IChatManagerDelegate, SRRefreshDelegate>
{
   BOOL isExpand[4];
}
@property (strong, nonatomic) NSMutableArray *dataSource; //推荐群组
@property (strong, nonatomic) NSMutableArray *commonArr; //我创建的群组
@property (strong, nonatomic) NSMutableArray *joinArr; // 我加入的群组
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupListViewController

+ (instancetype)shareGroupListController
{
    static GroupListViewController *shareGroupListController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareGroupListController = [[GroupListViewController alloc] init];
    });
    return shareGroupListController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroups];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = self.parnetVC.view.bounds;
    self.tableView.tableFooterView = [[UIView alloc] init];;
    self.tableView.tableHeaderView = self.searchBar;
    [self searchController];
    [MobClick event:@"GroupListViewController" label:@"onClick"];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)commonArr
{
    if (!_commonArr) {
        _commonArr = [NSMutableArray array];
    }
    return _commonArr;
}

- (NSMutableArray *)joinArr
{
    if (!_joinArr) {
        _joinArr = [NSMutableArray array];
    }
    return _joinArr;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {

        SHGGroupHeaderObject *object0 = [[SHGGroupHeaderObject alloc] init];
        object0.image = [UIImage imageNamed:@"message_arrowRight"];
        object0.text = @"推荐群组 (%ld)";

        SHGGroupHeaderObject *object1 = [[SHGGroupHeaderObject alloc] init];
        object1.image = [UIImage imageNamed:@"message_arrowRight"];
        object1.text = @"推荐群组 (%ld)";

        SHGGroupHeaderObject *object2 = [[SHGGroupHeaderObject alloc] init];
        object2.image = [UIImage imageNamed:@"message_arrowRight"];
        object2.text = @"我创建的群组 (%ld)";

        SHGGroupHeaderObject *object3 = [[SHGGroupHeaderObject alloc] init];
        object3.image = [UIImage imageNamed:@"message_arrowRight"];
        object3.text = @"我加入的群组 (%ld)";

        _titleArray = @[object0, object1, object2, object3];
    }
    return _titleArray;
}

- (void)refreshHeader
{
    [self reloadDataSource];

    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroups];
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.cancelButtonTitleColor = Color(@"bebebe");
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak GroupListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if(group!=nil && ![@"-1" isEqualToString:group.groupId]){
                cell.imageView.image = [UIImage imageNamed:@"message_defaultImage"];
                cell.textLabel.text = group.groupSubject;
            }
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath)
        {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMGroup *group = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
            detailController.title = group.groupSubject;
            BaseViewController *viewController =(BaseViewController*)weakSelf.parnetVC;
            [viewController.navigationController pushViewController:detailController animated:YES];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (isExpand[section] == YES){
        if  (section == 1){
            return [self.dataSource count];
        } else if (section == 2){
            return [self.commonArr count];
        } else if (section == 3){
            return [self.joinArr count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    SHGGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SHGGroupObject *object = [[SHGGroupObject alloc] init];
    switch (indexPath.section) {
        case 0:{
            object.text = @"新建群组";
            object.rightViewHidden = NO;
            object.lineViewHidden = NO;
            object.imageViewHidden = YES;
        }break;
        case 1:{
            EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
            if (group.groupSubject && group.groupSubject.length > 0){
                object.text = group.groupSubject;

            } else {
                object.text = group.groupId;
            }
            object.rightViewHidden = YES;
            object.lineViewHidden = NO;
            object.imageViewHidden = NO;
        }break;
        case 2:{
            EMGroup *group = [self.commonArr objectAtIndex:indexPath.row];
            if (group.groupSubject && group.groupSubject.length > 0){
                object.text = group.groupSubject;

            } else {
                object.text = group.groupId;
            }
            object.rightViewHidden = YES;
            object.lineViewHidden = NO;
            object.imageViewHidden = NO;
        }break;
        case 3:{
            EMGroup *group = [self.joinArr objectAtIndex:indexPath.row];
            if (group.groupSubject && group.groupSubject.length > 0){
                object.text = group.groupSubject;

            } else {
                object.text = group.groupId;
            }
            object.rightViewHidden = YES;
            object.lineViewHidden = NO;
            object.imageViewHidden = NO;
        }break;
        default:{

        }
    }
    if (!cell){
        cell = [[SHGGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.object = object;
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    SHGGroupHeaderView *view = [[SHGGroupHeaderView alloc] init];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SHGGroupHeaderViewClick:)];
    [view addGestureRecognizer:recognizer];

    SHGGroupHeaderObject *object = [self.titleArray objectAtIndex:section];
    if (isExpand[section] == YES){
        object.image = [UIImage imageNamed:@"message_arrowDown"];
    } else{
        object.image = [UIImage imageNamed:@"message_arrowRight"];
    }
    if (section == 1) {
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"msg_recommendGroup"];
        object.count = self.dataSource.count;
    } else if (section == 2){
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"msg_createGroup"];
        object.count = self.commonArr.count;
    } else{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"msg_joinGroup"];
        object.count = self.joinArr.count;
    }
    view.object = object;
    return view;
}

- (void)SHGGroupHeaderViewClick:(UITapGestureRecognizer *)recognizer
{
    SHGGroupHeaderView *view = (SHGGroupHeaderView *)recognizer.view;
    SHGGroupHeaderObject *object = view.object;
    NSInteger index = [self.titleArray indexOfObject:object];
    isExpand[index] = !isExpand[index];
    NSIndexSet *set =[NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = MarginFactor(55.0f);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else{
        return MarginFactor(55.0f);
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if(indexPath.row == 0){
            [self createGroup];
        }
    } else if (indexPath.section == 1){
        
        EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        PublicGroupDetailViewController *detailController = [[PublicGroupDetailViewController alloc] initWithGroupId:group.groupId];
        detailController.title = group.groupSubject;
        if ([self.parnetVC isKindOfClass:[ChatListViewController class]]){
            [self.parnetVC.navigationController pushViewController:detailController animated:YES];
        } else{
            [self.navigationController pushViewController:detailController animated:YES];
        }
        
    } else if (indexPath.section == 2){
        EMGroup *group = [self.commonArr objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
        if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
        {
            BaseViewController *viewController =(BaseViewController*)self.parnetVC;
            [viewController.navigationController pushViewController:chatController animated:YES];
        }else
        {
            [self.navigationController pushViewController:chatController animated:YES];
        }
    } else if (indexPath.section == 3){
        EMGroup *group = [self.joinArr objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
        if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
        {
            BaseViewController *viewController =(BaseViewController*)self.parnetVC;
            [viewController.navigationController pushViewController:chatController animated:YES];
        } else{
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
    
}

#pragma mark - UISearchBarDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *array = [NSMutableArray array];
    [array appendUniqueObjectsFromArray:self.dataSource];
    [array appendUniqueObjectsFromArray:self.commonArr];
    [array appendUniqueObjectsFromArray:self.joinArr];
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:array searchText:(NSString *)searchText collationStringSelector:@selector(groupSubject) resultBlock:^(NSArray *results){
        if (results){
            dispatch_async(dispatch_get_main_queue(),^{
                [self.searchController.resultsSource removeAllObjects];
                EMGroup *grp = [EMGroup groupWithId:@"-1"];
                NSMutableArray *resultArr = [[NSMutableArray alloc] initWithArray:results];
                [resultArr removeObject:grp];
                [self.searchController.resultsSource addObjectsFromArray:resultArr];
                [self.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error){
        [self reloadDataSource];
        [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroups];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
    [[EaseMob sharedInstance].chatManager asyncFetchAllPublicGroups];
}

#pragma mark - data
#pragma mark -获取公开群组
-(void)didFetchAllPublicGroups:(NSArray *)groups error:(EMError*)error
{
    [self hideHud];
    [self.dataSource addObjectsFromArray:groups];
    [self.tableView reloadData];
}

- (void)reloadDataSource
{
    //增加点击进入增加群组
    [self.dataSource removeAllObjects];
    [self.joinArr removeAllObjects];
    [self.commonArr removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error){
        for (EMGroup *group in groups){
            if (![group.owner isEqualToString:loginInfo[@"username"]]){
                [self.joinArr addObject:group];
            }else{
                [self.commonArr addObject:group];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView reloadData];
        });
        [self.tableView.mj_header endRefreshing];
    }
    onQueue:nil];
}

#pragma mark - action

- (void)showPublicGroupList
{
    PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] init];
    [self.navigationController pushViewController:publicController animated:YES];
}

- (void)createGroup
{
    CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
    if ([self.parnetVC isKindOfClass:[ChatListViewController class]])
    {
        BaseViewController *viewController =(BaseViewController*)self.parnetVC;
        [viewController.navigationController pushViewController:createChatroom animated:YES];
    }else{
        [self.navigationController pushViewController:createChatroom animated:YES];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchBar.text = @"";
}

@end

#pragma mark ------SHGGroupObject
@interface SHGGroupObject()

@end

@implementation SHGGroupObject



@end

#pragma mark ------SHGGroupTableViewCell

@interface SHGGroupTableViewCell()
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *rightArrowView;
@end

@implementation SHGGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"message_defaultImage"] forState:UIControlStateNormal];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FontFactor(15.0f);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"161616"];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    self.rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrowImage"]];

    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightArrowView];
}

- (void)addAutoLayout
{
    CGSize size = [UIImage imageNamed:@"message_defaultImage"].size;
    self.leftButton.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .widthIs(size.width)
    .heightIs(size.height);

    self.titleLabel.sd_layout
    .leftSpaceToView(self.leftButton, MarginFactor(10.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .leftEqualToView(self.leftButton)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f)
    .bottomSpaceToView(self.contentView, 0.0f);

    size = [UIImage imageNamed:@"rightArrowImage"].size;
    self.rightArrowView.sd_layout
    .widthIs(size.width)
    .heightIs(size.height)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, MarginFactor(11.0f));

}

- (void)setObject:(SHGGroupObject *)object
{
    _object = object;
    self.titleLabel.frame = CGRectZero;
    self.titleLabel.text = object.text;
    self.lineView.hidden = object.lineViewHidden;
    self.rightArrowView.hidden = object.rightViewHidden;
    if (object.imageViewHidden) {
        [self.leftButton setImage:nil forState:UIControlStateNormal];
        self.titleLabel.sd_resetLayout
        .leftSpaceToView(self.contentView, MarginFactor(28.0f))
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0.0f);
    } else{
        [self.leftButton setImage:[UIImage imageNamed:@"message_defaultImage"] forState:UIControlStateNormal];
        self.titleLabel.sd_resetLayout
        .leftSpaceToView(self.leftButton, MarginFactor(10.0f))
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0.0f);
    }
}

@end


#pragma mark ------SHGGroupHeaderView
@interface SHGGroupHeaderView()
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation SHGGroupHeaderView
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
    self.backgroundColor = [UIColor whiteColor];

    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FontFactor(15.0f);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"161616"];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    [self addSubview:self.leftButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
}

- (void)addAutoLayout
{
    self.sd_layout
    .widthIs(SCREENWIDTH)
    .heightIs(MarginFactor(55.0f));

    UIImage *image = [UIImage imageNamed:@"message_arrowRight"];
    self.leftButton.sd_layout
    .leftSpaceToView(self, MarginFactor(12.0f))
    .centerYEqualToView(self)
    .widthIs(image.size.width)
    .heightIs(image.size.height);

    self.titleLabel.sd_layout
    .leftSpaceToView(self.leftButton, MarginFactor(9.0f))
    .centerYEqualToView(self)
    .autoHeightRatio(0.0f);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lineView.sd_layout
    .leftEqualToView(self.leftButton)
    .rightSpaceToView(self, 0.0f)
    .heightIs(0.5f)
    .bottomSpaceToView(self, 0.5f);

}

- (void)setObject:(SHGGroupHeaderObject *)object
{
    _object = object;
    [self.leftButton setImage:object.image forState:UIControlStateNormal];

    self.titleLabel.text = [NSString stringWithFormat:object.text, (long)object.count];

}

@end

#pragma mark ------SHGGroupHeaderObject
@interface SHGGroupHeaderObject()

@end

@implementation SHGGroupHeaderObject



@end
