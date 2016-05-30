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

#import "ChatListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "GroupListViewController.h"
#import "BasePeopleObject.h"
#import "BasePeopleTableViewCell.h"
#import "ApplyViewController.h"
#import "MessageViewController.h"
#import "FriendsListViewController.h"
#import "HeadImage.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MLKMenuPopover.h"
#import "TabBarViewController.h"
#import "popObj.h"
#import "SHGPersonalViewController.h"

static NSString * const kUid				= @"uid";
static NSString * const kHeadImg			= @"headimg";
static NSString * const kNickName			= @"nickname";
static NSString * const kRela			= @"rela";
static NSString * const kCompany			= @"company";
static NSString * const kCommonFriend			= @"commonfriend";
static NSString * const kCommonFNum			= @"commonnum";

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,MLKMenuPopoverDelegate>
{
    NSInteger pageNum;
    NSString *area;
    BOOL hasMoreData;
    UIButton *rightButton;
}

@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) UIView                *networkStateView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong)  UIView *titleView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UILabel *unapplyCountLabel;
@property (nonatomic,strong) MLKMenuPopover *menuPopover;
@property (nonatomic,strong) MLKMenuPopover1 *menuPopover1;
@property (nonatomic,strong) NSArray *menuItems;
@property (nonatomic,strong) GroupListViewController *groupVC;
@property (nonatomic,strong) EMConversation * daNiuConversation;
@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _contactsSource = [NSMutableArray array];
        self.isResfresh = YES;
        pageNum = 1;
        area = @"";
    }
    return self;
}

-(GroupListViewController*)groupVC
{
    if (!_groupVC){
        _groupVC = [GroupListViewController shareGroupListController];
        _groupVC.parnetVC = self;
    }
    return _groupVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:NO];
    self.navigationItem.titleView = self.titleView;

    [self removeEmptyConversationsFromDB];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatList) name:@"refreshFriendList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:NOTIFI_CHANGE_UPDATE_FRIEND_LIST object:nil];
    [self networkStateView];
    [self refreshDataSource];
}

- (void)refreshHeader
{
    pageNum = 1;
    [self refreshDataSource];
    [self.tableView.mj_header endRefreshing];
}

- (void)refreshFooter
{
    if (hasMoreData) {
        pageNum ++;
        [self refreshDataSource];
    } else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)btnBackClick:(UIButton *)sender
{

    [self.groupVC.searchController setActive:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshChatList
{
    [self.tableView reloadData];
}

- (void)rightBarButtonItemClicked:(UIButton *)sender
{
    if(self.menuPopover.isshow)
    {
        [self.menuPopover dismissMenuPopover];
    } else{
        self.menuItems = [NSArray arrayWithObjects:@"发起对话", @"发起群聊", nil];
        self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(SCREENWIDTH-120, 0, 110, 88) menuItems:self.menuItems];
        self.menuPopover.menuPopoverDelegate = self;
        [self.menuPopover showInView:self.view];
    }
}

#pragma mark MLKMenuPopoverDelegate
- (void)menuPopover1:(MLKMenuPopover1 *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover1 dismissMenuPopover];
    popObj *obj = self.arrCityCode[selectedIndex];
    for (popObj *pObj in self.arrCityCode) {
        pObj.selected = NO;
    }
    pageNum = 1;
    obj.selected = YES;
    //[self.tableView reloadData];
    area = obj.code;
    [rightButton setTitle:obj.name forState:UIControlStateNormal];
    
    [self requestTwainContact];
}
#pragma mark -- sdc
#pragma mark -- 发起群聊.发起会话
- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
    if(selectedIndex == 0){
        FriendsListViewController *vc=[[FriendsListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(selectedIndex == 1){
        GroupListViewController *vc = [[GroupListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
    [self reloadDataSource];
    [self registerNotifications];
    self.isResfresh = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation.chatter];
        }
    }

    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations deleteMessages:YES append2Chat:NO];
    }
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = FontFactor(15.0f);
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation* obj2){
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];

    ret = [[NSMutableArray alloc] initWithArray:sorte];

    for (NSInteger i = 0; i < ret.count; i ++) {
        EMConversation * conversation = [ret objectAtIndex:i];
        if ([conversation.chatter isEqualToString:@"-2"]) {
            self.daNiuConversation = conversation;
            [ret removeObjectAtIndex:i];
        }
    }
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location:{
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

- (void)getMyselfMaterialWithUid:(NSString *)uid
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
        
        
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}


#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];

    if (!cell){
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    if(indexPath.row == 0){
        ChatModel *model = [[ChatModel alloc] init];
        model.placeholderImage = [UIImage imageNamed:@"申请头像图标"];
        model.name = @"群申请与通知";
        model.imageURL = nil;
        model.detailMsg = @"";
        model.time = @"";
        cell.model = model;
        [cell.contentView addSubview:self.unapplyCountLabel];
    } else if(indexPath.row == 1){
        ChatModel *model = [[ChatModel alloc] init];
        model.placeholderImage = [UIImage imageNamed:@"消息通知"];
        model.imageURL = nil;
        model.name = @"通知";
        model.detailMsg = @"";
        model.time = @"";
        cell.model = model;
    } else if (indexPath.row == 2){
        ChatModel *model = [[ChatModel alloc] init];
            __weak typeof(self) weakSelf = self;
            [[SHGGloble sharedGloble] refreshFriendListWithUid:@"-2" finishBlock:^(BasePeopleObject *object) {
                [weakSelf.contactsSource addObject:object];
            }];
            cell.rightImage.hidden = YES;
            model.placeholderImage = [UIImage imageNamed:@"team_head"];
            model.imageURL = nil;
            model.name = @"大牛助手";
            model.detailMsg = @"";
            model.time = @"";
            model.unreadCount = [self unreadMessageCountByConversation:self.daNiuConversation];
            cell.model = model;
        
    } else{
        ChatModel *model = [[ChatModel alloc] init];
        cell.rightImage.hidden = YES;
        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
        for (BasePeopleObject *obj in self.contactsSource) {
            if ([obj.uid isEqualToString:conversation.chatter]){
                model.name =  obj.name;
                
            }
        }
        if (conversation.isGroup){
            NSString *imageName = @"message_defaultImage";
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray){
                if ([group.groupId isEqualToString:conversation.chatter]){
                    model.name = group.groupSubject;
                    break;
                }
            }
            model.imageURL = nil;
            model.placeholderImage = [UIImage imageNamed:imageName];
        } else{
            NSArray *headUrl = [HeadImage queryAll:conversation.chatter];
            if(headUrl.count > 0){
                HeadImage *hi = (HeadImage*)headUrl[0];
                if(![hi.headimg isEqual:@""]){
                    model.placeholderImage = [UIImage imageNamed:@"default_head"];
                    model.imageURL=[NSURL URLWithString:hi.headimg];
                } else{
                    model.imageURL = nil;
                    model.placeholderImage = [UIImage imageNamed:@"default_head"];
                }
                model.name = hi.nickname;
            } else{
                __weak typeof(self) weakSelf = self;
                [[SHGGloble sharedGloble] refreshFriendListWithUid:conversation.chatter finishBlock:^(BasePeopleObject *object) {
                    [weakSelf.contactsSource addObject:object];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                }];
                model.name = @"";
                model.imageURL = nil;
                model.placeholderImage = [UIImage imageNamed:@"default_head"];
            }

        }
        model.detailMsg = [self subTitleMessageByConversation:conversation];
        model.time = [self lastMessageTimeByConversation:conversation];
        model.unreadCount = [self unreadMessageCountByConversation:conversation];
        cell.model = model;
    }

    return cell;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if ([UID isEqualToString:@"-2"] && indexPath.row == 2) {
        height = 0.0f;
    } else{
        height = MarginFactor(55.0f);
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"msg_groupApply"];
        ApplyViewController *vc=[ApplyViewController shareController];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(indexPath.row == 1){
        MessageViewController *mViewController=[[MessageViewController alloc] init];
        [self.navigationController pushViewController:mViewController animated:YES];
    }
//    else if (indexPath.row == 2){
//        ChatViewController *chatController;
//        NSString *chatter = self.daNiuConversation.chatter;
//        NSString *titleName = @"";
//        for (BasePeopleObject *obj in self.contactsSource) {
//            if ([obj.uid isEqualToString:self.daNiuConversation.chatter]) {
//                titleName = obj.name;
//            }
//        }
//
//        chatController.title = titleName;
//        chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:self.daNiuConversation.isGroup];
//        [self.navigationController pushViewController:chatController animated:YES];
//    }
    else{
        
        EMConversation *conversation;
        if (indexPath.row == 2) {
            if (self.daNiuConversation) {
                conversation = self.daNiuConversation;
            } else{
                [conversation setValue:@"-2" forKey:@"chatter"];
                [conversation setValue:@"NO" forKey:@"isGroup"];
        
            }
            
        } else{
            conversation = [self.dataSource objectAtIndex:indexPath.row];
        }
        
        ChatViewController *chatController;
        NSString *title = conversation.chatter;
        if (conversation.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
        NSString *chatter = conversation.chatter;
        NSString *titleName = @"";
        chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.isGroup];
        for (BasePeopleObject *obj in self.contactsSource) {
            if ([obj.uid isEqualToString:conversation.chatter]) {
                titleName = obj.name;
            }
        }
        if (conversation.isGroup){
            chatController.title = title;
        } else{
            chatController.title=titleName;
        }
        [self.navigationController pushViewController:chatController animated:YES];
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = indexPath.row;
    if(indexRow == 0 || indexRow == 1)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}
#pragma mark -- 检索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText firstSel:@selector(name) secondSel:@selector(company) thirdSel:@selector(position) resultBlock:^(NSArray *results) {
//        if (results){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.searchController.resultsSource removeAllObjects];
//                [self.searchController.resultsSource addObjectsFromArray:results];
//                [self.searchController.searchResultsTableView reloadData];
//            });
//        }
//
//    }];
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
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self reloadDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
    //    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    //    self.chatListType=ChatListView;
    [self.dataSource removeAllObjects];
    for(unsigned int i=0;i<3;i++)
    {
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    NSArray *dSource=[self loadDataSource];
    for(unsigned int i=0;i<dSource.count;i++)
    {
        EMConversation *emc=dSource[i];
        NSArray *arr = [emc loadAllMessages];
        if (!IsArrEmpty(arr)) {
            [self.dataSource addObject:emc];
        }
    }
    [self.tableView reloadData];
}
#pragma mark - public
#pragma mark -- 我的好友

- (void)refreshFriendShip
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"refresh"] parameters:nil success:^(MOCHTTPResponse *response) {
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}
-(void)requestContact
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    NSDictionary *param = @{@"uid":uid, @"pagenum":[NSNumber numberWithInteger:pageNum], @"pagesize":@15};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends/level/one"] parameters:param success:^(MOCHTTPResponse *response) {
        if(response.dataArray.count == 0){
            hasMoreData = NO;
        } else{
            hasMoreData = YES;
        }

        if(response.dataArray.count>0){
            if (pageNum == 1) {
                [self.contactsSource removeAllObjects];
            }
        }

        for (int i = 0; i < response.dataArray.count; i++){
            NSDictionary *dic = response.dataArray[i];
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nick"];
            obj.headImageUrl = [dic valueForKey:@"avatar"];
            obj.uid = [dic valueForKey:@"username"];
            obj.rela = [dic valueForKey:@"rela"];
            obj.company = [dic valueForKey:@"company"];
            obj.commonfriend = @"";
            obj.commonfriendnum = @"";
            obj.position = [dic valueForKey:@"position"];
            obj.userstatus = [dic objectForKey:@"userstatus"];
            [self.contactsSource addObject:obj];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [HeadImage inertWithArr:self.contactsSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Hud hideHud];
                if(response.dataArray.count > 0){
                    _tableView.hidden=NO;
                    [self.tableView reloadData];
                } else{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
        });

    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark -- 我的好友的好友
-(void)requestTwainContact
{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid, @"pagenum":[NSNumber numberWithInteger:pageNum], @"pagesize":@15};
    if (!IsStrEmpty(area)){
        param = @{@"uid":uid, @"area":area, @"pagenum":[NSNumber numberWithInteger:pageNum], @"pagesize":@15};
    }
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends/level/two"] parameters:param success:^(MOCHTTPResponse *response){
        NSLog(@"%@",response.dataArray);
        if(response.dataArray.count == 0){
            hasMoreData = NO;
        } else{
            hasMoreData = YES;
        }
        if (pageNum == 1) {
            [self.contactsSource removeAllObjects];
            [TwainContactInfo deleteAll];
        }
        for (int i = 0; i<response.dataArray.count; i++){
            NSLog(@"%@",response.dataArray);
            NSDictionary *dic = response.dataArray[i];
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.name = [dic valueForKey:@"nickname"];
            obj.headImageUrl = [dic valueForKey:@"avatar"];
            obj.uid = [dic valueForKey:@"username"];
            obj.rela = @"";
            obj.company = [dic valueForKey:@"company"];
            obj.commonfriend = [dic valueForKey:@"commonfriend"];
            obj.commonfriendnum = [dic valueForKey:@"commonfriendnum"];
            obj.poststring = [dic valueForKey:@"poststring"];
            obj.position = [dic valueForKey:@"position"];
            obj.userstatus = [dic valueForKey:@"userstatus"];
            [TwainContactInfo insertAll:obj];
            [self.contactsSource addObject:obj];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Hud hideHud];
            if(response.dataArray.count > 0){
                _tableView.hidden=NO;
            } else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)refreshDataSource
{
    [self.dataSource removeAllObjects];
    for(NSInteger i = 0; i < 3; i++){
        [self.dataSource addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    NSArray *dSource = [self loadDataSource];
    for(NSInteger i = 0;i < dSource.count; i++){
        EMConversation *emc = dSource[i];
        if ([emc loadAllMessages].count > 0){
            [self.dataSource addObject:emc];
        }
    }

    if(IsArrEmpty(self.contactsSource)){
        NSArray *arr = [HeadImage queryAll] ;
        for (NSManagedObject *object in arr) {
            BasePeopleObject *obj = [[BasePeopleObject alloc] init];
            obj.uid = [object valueForKey:kUid];
            obj.name = [object valueForKey:kNickName];
            obj.headImageUrl = [object valueForKey:kHeadImg];
            [self.contactsSource addObject:obj];
        }
    }
    [self.tableView reloadData];

}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
    [self reloadDataSource];
}

#pragma mark - action
- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    
    if (count == 0) {
        self.unapplyCountLabel.hidden = YES;
    } else{
        NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)count];
//        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize size = [tmpStr boundingRectWithSize:CGSizeMake(50, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.unapplyCountLabel.font} context:nil].size;
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 20 ? size.width : 20;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
    
    //刷新badgeValue值
    [[TabBarViewController tabBar] setupUntreatedApplyCount];
}


- (UILabel *)unapplyCountLabel
{
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 3, 20, 20)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = FontFactor(11.0f);
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.height / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    
    return _unapplyCountLabel;
}

-(NSMutableArray *)arrCityCode
{
    if (!_arrCityCode) {
        _arrCityCode = [NSMutableArray array];
        NSArray *arr = [self loadCityCode];
        NSString *code = @"";
        NSString *name = @"不限";
        popObj *nObj = [[popObj alloc] init];
        nObj.code = code;
        nObj.name = name;
        [_arrCityCode addObject:nObj];
        for (NSString *str in arr) {
            popObj *obj = [[popObj alloc] init];
            NSArray *strArr = [str componentsSeparatedByString:@"		"];
            obj.code = strArr[0];
            obj.name = strArr[1];
            [_arrCityCode addObject:obj];
        }
    }
    return _arrCityCode;
}
-(NSArray *)loadCityCode
{
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_code" ofType:@"txt"];
    NSString *textFileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray *lines = [textFileContents componentsSeparatedByString:@"\n"];
    return lines;
}
- (UIView *)titleView
{
    if (!_titleView) {
        self.titleView = self.segmentControl;
    }
    return _titleView;
}

#pragma mark -- sdc 
#pragma mark -- 加号按钮
- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setFrame:CGRectMake(0, 0, 24, 24)];
        [customButton setBackgroundImage:[UIImage imageNamed:@"right_add"] forState:UIControlStateNormal];
        [customButton addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        customButton.hidden = YES;
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
        
    }
    return _rightBarButtonItem;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
    }
    
    return _leftBarButtonItem;
}
#pragma mark -- sdc
#pragma mark -- UISegmentedControl
- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        
        _segmentControl = [[UISegmentedControl alloc] initWithItems:
                           [NSArray arrayWithObjects:
                            @"消息", @"群组", nil]];
        _segmentControl.frame = CGRectMake(0, 50, 170, 26);
        _segmentControl.enabled = YES;
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.layer.cornerRadius = 4;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"d53432"],NSForegroundColorAttributeName,FontFactor(15.0f),NSFontAttributeName ,nil];

        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,FontFactor(15.0f),NSFontAttributeName ,nil];
        //设置标题的颜色 字体和大小 阴影和阴影颜色
        [_segmentControl setTitleTextAttributes:dic1 forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        _segmentControl.tintColor = [UIColor clearColor];
        _segmentControl.layer.borderColor =  [UIColor whiteColor].CGColor;
        _segmentControl.layer.borderWidth = 1.0;
        UIImage *segImage = [CommonMethod imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)];
        UIImage *selectImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
        [_segmentControl setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        [_segmentControl setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

        [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        [_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.selected = NO;
        _segmentControl.selectedSegmentIndex = 0;
        
    }
    return _segmentControl;
}

- (void)selected:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:{
            self.tableView.hidden = NO;
            self.tableView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view bringSubviewToFront:self.tableView];
            
        }
            break;
        case 1:{
            self.tableView.hidden = YES;
            [self.view addSubview:self.groupVC.view];
        }
            break;
        default:
            break;
    }
    [self refreshDataSource];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
}

@end
