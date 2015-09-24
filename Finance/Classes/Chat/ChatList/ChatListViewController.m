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
#import "RealtimeSearchUtil.h"
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
#import "ChatListTableViewCell.h"
#import "popObj.h"

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
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong)  UIView *titleView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UILabel *unapplyCountLabel;
@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,strong) MLKMenuPopover1 *menuPopover1;
@property(nonatomic,strong) NSArray *menuItems;
@property (nonatomic,strong) GroupListViewController *groupVC;
@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
        _contactsSource = [NSMutableArray array];
        self.isResfresh=YES;
        // self.chatListType = ChatListView;
        pageNum = 1;
        area = @"";
        self.shouldRefresh = NO;
        
        //        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    }
    return self;
}
-(GroupListViewController*)groupVC
{
    if (!_groupVC){
        _groupVC = [[GroupListViewController alloc] init];
        _groupVC.parnetVC = self;
    }
    return _groupVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //处理tableView左边空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadUI];
    // self.tableView.separatorStyle = 1;
    [TabBarViewController tabBar].tabBar.backgroundColor=[UIColor whiteColor];
    [self removeEmptyConversationsFromDB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionInvite:) name:NOTIFI_CHANGE_ACTION_INVITE_FRIEND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatList) name:@"refreshFriendList" object:nil];
    if (self.chatListType != ChatListView)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:NOTIFI_CHANGE_UPDATE_FRIEND_LIST
                                                   object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:NOTIFI_CHANGE_SHOULD_UPDATE
                                               object:nil];
    //[self.view addSubview:self.segmentControl];
    [self networkStateView];
    [self searchController];
    [self refreshDataSource];
    

}
-(void)changeState
{
    self.shouldRefresh = YES;
}
-(void)refreshHeader
{
    pageNum = 1;
    [self refreshDataSource];
}
-(void)refreshFooter
{
    if (hasMoreData) {
        pageNum ++;
        [self refreshDataSource];
    }
    else
    {
        [self.tableView.footer noticeNoMoreData];
    }
}

-(void)btnBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshChatList
{
    [self.tableView reloadData];
}

-(void)searchTwainFriend
{
    if(self.menuPopover1.isshow)
    {
        [self.menuPopover1 dismissMenuPopover];
    } else{
        self.menuPopover1 = [[MLKMenuPopover1 alloc] initWithFrame:CGRectMake(SCREENWIDTH-150, 0, 150, 280) menuItems:self.arrCityCode];
        self.menuPopover1.menuPopoverDelegate = self;
        [self.menuPopover1 showInView:self.view];
    }
}

- (void)rightBarButtonItemClicked:(UIButton *)sender
{
    if(self.menuPopover.isshow)
    {
        [self.menuPopover dismissMenuPopover];
    }else
    {
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
    
    if(selectedIndex==0)
    {
        FriendsListViewController *vc=[[FriendsListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(selectedIndex==1)
    {
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
    if (self.shouldRefresh && self.chatListType == ContactListView)
    {
        [self refreshDataSource];
    }
    self.isResfresh=NO;
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
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        if (self.chatListType == ContactListView)
        {
            _searchBar.placeholder = @"请输入姓名/公司/职位";
        }else{
            _searchBar.placeholder = @"请输入姓名/公司/职位";
        }
        _searchBar.hidden=YES;
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak UISearchBar *weakSBar=self.searchBar;
        __weak ChatListViewController *weakSelf = self;
        
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListTableViewCell";
            ChatListTableViewCell *cell = (ChatListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
                //			cell.delegate = self;
            }
            
            BasePeopleObject *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            if (self.chatListType == ContactListView) {
                cell.type = contactTypeFriend;
            }else{
                cell.type = contactTypeFriendTwain
                ;
            }
            [cell loadDataWithobj:buddy];
            
            return cell;
            
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 72;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            BasePeopleObject *buddy = [weakSelf.searchController.resultsSource  objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.uid]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            [weakSBar resignFirstResponder];
            //			ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.uid isGroup:NO];
            //			chatVC.title = buddy.name;
            //			chatVC.hidesBottomBarWhenPushed = YES;
            //			[weakSelf.navigationController pushViewController:chatVC animated:YES];
            if ([buddy.rela isEqualToString:@"2"])
            {
                return;
            }
            CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] init];
            vc.userId = buddy.uid;
            vc.userName = buddy.name;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    
    return _searchController;
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
        label.font = [UIFont systemFontOfSize:15.0];
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
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
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
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
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
        //        NSString *nickName = [response.dataDictionary valueForKey:@"name"];
        //        NSString *headImageUrl = [response.dataDictionary valueForKey:@"head_img"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}


#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.chatListType == ChatListView){
        static NSString *identify = @"chatListCell";
        ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell){
            cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        if(indexPath.row==0){
            cell.placeholderImage=[UIImage imageNamed:@"申请头像图标"];
            cell.name=@"群申请与通知";
            cell.imageURL=nil;
            cell.detailMsg=@"";
            cell.time=@"";
            [cell addSubview:self.unapplyCountLabel];
        } else if(indexPath.row==1){
            cell.placeholderImage=[UIImage imageNamed:@"消息通知"];
            cell.imageURL=nil;
            cell.name =@"通知";
            cell.detailMsg=@"";
            cell.time=@"";
        } else{
            EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
            for (BasePeopleObject *obj in self.contactsSource) {
                if ([obj.uid isEqualToString:conversation.chatter])
                {
                    cell.name =  obj.name;
                }
            }
            if (conversation.isGroup)
            {
                NSString *imageName = @"群头像图标";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray)
                {
                    if ([group.groupId isEqualToString:conversation.chatter])
                    {
                        cell.name = group.groupSubject;
                        break;
                    }
                }
                cell.imageURL=nil;
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }
            else{
                NSArray *headUrl=[HeadImage queryAll:conversation.chatter];
                if(headUrl.count>0)
                {
                    HeadImage *hi=(HeadImage*)headUrl[0];
                    if(![hi.headimg isEqual:@""])
                    {
                        cell.placeholderImage = [UIImage imageNamed:@"默认头像"];
                        cell.imageURL=[NSURL URLWithString:hi.headimg];
                    }else
                    {
                        cell.imageURL=nil;
                        cell.placeholderImage = [UIImage imageNamed:@"默认头像"];
                    }
                    cell.name=hi.nickname;
                } else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        //  [self getMyselfMaterial];
                        [self refreshFriendListWithUid:conversation.chatter];
                    });
                    
                    cell.name=@"";
                    cell.imageURL=nil;
                    cell.placeholderImage = [UIImage imageNamed:@"默认头像"];
                }
                
            }
            cell.detailMsg = [self subTitleMessageByConversation:conversation];
            cell.time = [self lastMessageTimeByConversation:conversation];
            cell.unreadCount = [self unreadMessageCountByConversation:conversation];
        }
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"ChatListTableViewCell";
        ChatListTableViewCell *cell = (ChatListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        BasePeopleObject *buddy = [self.contactsSource objectAtIndex:indexPath.row];
        if (self.chatListType == ContactListView){
            cell.type = contactTypeFriend;
        }else{
            cell.type = contactTypeFriendTwain
            ;
        }
        
        [cell loadDataWithobj:buddy];
        
        return cell;
    }
}
-(void)refreshFriendListWithUid:(NSString *)userId
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/%@",rBaseAddressForHttp,userId] parameters:nil success:^(MOCHTTPResponse *response) {
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic = response.dataDictionary;
        
        BasePeopleObject *obj = [[BasePeopleObject alloc] init];
        obj.name = [dic valueForKey:@"nick"];
        obj.headImageUrl = [dic valueForKey:@"avatar"];
        obj.uid = [dic valueForKey:@"username"];
        obj.rela = [dic valueForKey:@"rela"];
        obj.company = [dic valueForKey:@"company"];
        obj.commonfriend = @"";
        obj.commonfriendnum = @"";
        [self.contactsSource addObject:obj];
        [arr addObject:obj];
        [HeadImage inertWithArr:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.chatListType == ChatListView) {
        return  self.dataSource.count;
    }else if (self.chatListType == ContactListView){
        return self.contactsSource.count;
    }else{
        return self.contactsSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.chatListType == ContactListView || self.chatListType == ContactTwainListView) {
        return 72;
    }
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.chatListType == ChatListView){
        if(indexPath.row==0){
            ApplyViewController *vc=[ApplyViewController shareController];
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row==1){
            MessageViewController *mViewController=[[MessageViewController alloc] init];
            [self.tabBarController.navigationController pushViewController:mViewController animated:YES];
        } else{
            EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
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
            [self.tabBarController.navigationController pushViewController:chatController animated:YES];
        }
    } else if (self.chatListType == ContactListView || self.chatListType == ContactTwainListView){
        BasePeopleObject *buddy = [self.contactsSource  objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0){
            if ([loginUsername isEqualToString:buddy.uid]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        if ([buddy.rela isEqualToString:@"2"]){
            return;
        }
        CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
        vc.userId = buddy.uid;
        vc.userName = buddy.name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.chatListType == ContactListView)
    {
        return NO;
    }
    NSInteger indexRow=indexPath.row;
    if(indexRow==0||indexRow==1)
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
//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:searchText firstSel:@selector(name) secondSel:@selector(company) thirdSel:@selector(position) resultBlock:^(NSArray *results) {
        if (results){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
                [self.searchController.searchResultsTableView reloadData];
            });
        }

    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (self.chatListType == ChatListView) {
        [self refreshDataSource];
        
    }
    [_slimeView endRefresh];
    
    
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
    for(unsigned int i=0;i<2;i++)
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
    
    NSDictionary *param = @{@"uid":uid,
                            @"pagenum":[NSNumber numberWithInteger:pageNum],
                            @"pagesize":@15};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends/level/one"] parameters:param success:^(MOCHTTPResponse *response) {
        if(!response.dataArray.count>0)
        {
            hasMoreData = NO;
        }
        else
        {
            hasMoreData = YES;
        }
        
        if(response.dataArray.count>0)
        {
            if (pageNum == 1) {
                [self.contactsSource removeAllObjects];
                // [HeadImage deleteAll];
            }
            NSString *needentUpdateSql = @"1";
            [[NSUserDefaults standardUserDefaults] setValue:needentUpdateSql forKey:KEY_UPDATE_SQL];
        }
        for (int i = 0; i<response.dataArray.count; i++)
        {
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
            obj.userStatus = [dic objectForKey:@"userstatus"];
            [self.contactsSource addObject:obj];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [HeadImage inertWithArr:self.contactsSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Hud hideHud];
                if(response.dataArray.count>0)
                {
                    _tableView.hidden=NO;
                    [self.tableView reloadData];
                }
                else
                {
                    [_tableView.footer noticeNoMoreData];
                    
                }
                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
            });
        });
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}
#pragma mark -- 我的好友的好友
-(void)requestTwainContact
{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"uid":uid,
                            @"pagenum":[NSNumber numberWithInteger:pageNum],
                            @"pagesize":@15};
    if (!IsStrEmpty(area))
    {
        param = @{@"uid":uid,
                  @"area":area,
                  @"pagenum":[NSNumber numberWithInteger:pageNum],
                  @"pagesize":@15};
    }
    
    // [Hud showLoadingWithMessage:@"正在加载"];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends/level/two"] parameters:param success:^(MOCHTTPResponse *response)
    {
        NSLog(@"%@",response.dataArray);
        if(!response.dataArray.count>0)
        {
            hasMoreData = NO;
        }
        else
        {
            hasMoreData = YES;
        }
        if (pageNum == 1) {
            [self.contactsSource removeAllObjects];
            [TwainContactInfo deleteAll];
        }
        for (int i = 0; i<response.dataArray.count; i++)
        {
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
            obj.userStatus = [dic valueForKey:@"userstatus"];
            [TwainContactInfo insertAll:obj];
            [self.contactsSource addObject:obj];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Hud hideHud];
            if(response.dataArray.count>0)
            {
                _tableView.hidden=NO;
            }
            else
            {
                [_tableView.footer noticeNoMoreData];
                
            }
            [self.tableView reloadData];
            
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        });
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [Hud showMessageWithText:response.errorMessage];
    }];
}
-(void)refreshDataSource
{
    if(self.chatListType == ContactListView)
    {
//        [self refreshFriendShip];
        [self requestContact];
        
    }
    else if (self.chatListType == ContactTwainListView){
        [self requestTwainContact];
    }
    else
    {
        [self.dataSource removeAllObjects];
        for(unsigned int i=0;i<2;i++)
        {
            [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NSArray *dSource=[self loadDataSource];
        for(unsigned int i=0;i<dSource.count;i++)
        {
            EMConversation *emc=dSource[i];
            if ([emc loadAllMessages].count > 0)
            {
                [self.dataSource addObject:emc];
                
            }
        }
        
        if(IsArrEmpty(self.contactsSource))
        {
            //[self requestContact];
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
    }
    else
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)count];
        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
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
        _unapplyCountLabel.font = [UIFont systemFontOfSize:11];
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
        //self.titleView =self.titleLabel;
        self.titleView = self.segmentControl;
    }
    
    return _titleView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.font = [UIFont fontWithName:@"Palatino" size:17];
        _titleLabel.textColor = TEXT_COLOR;
        if (self.chatListType == ChatListView) {
            _titleLabel.text = @"我的消息";
        }
        else if(self.chatListType == ContactListView)
        {
            _titleLabel.text = @"我的好友";
            
        }else
        {
            _titleLabel.text = @"我好友的好友";
        }
    }
    return _titleLabel;
}
#pragma mark -- sdc 
#pragma mark -- 加号按钮
- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setFrame:CGRectMake(0, 0, 24, 24)];
        [customButton setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
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
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 57, 67),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
        //设置标题的颜色 字体和大小 阴影和阴影颜色
        [_segmentControl setTitleTextAttributes:dic1 forState:UIControlStateSelected];
        //        [_segmentControl setTitleTextAttributes:dic1 forState:UIControlStateHighlighted];
        [_segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        _segmentControl.tintColor = [UIColor clearColor];
        _segmentControl.layer.borderColor =  [RGB(255, 56, 67) CGColor];
        _segmentControl.layer.borderWidth = 1.0;
        UIImage *segImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
        UIImage *selectImage = [CommonMethod imageWithColor:RGB(255, 56, 67) andSize:CGSizeMake(85, 26)];
        [_segmentControl setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [_segmentControl setBackgroundImage:selectImage forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        [_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.selected = NO;
        _segmentControl.selectedSegmentIndex = 0;
        
    }
    return _segmentControl;
}

- (void)selected:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    [_searchBar resignFirstResponder];
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.chatListType = ChatListView;
            self.tableView.hidden = NO;
            self.searchBar.hidden = YES;
            self.tableView.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view bringSubviewToFront:self.tableView];
            
        }
            break;
        case 1:
        {
            self.searchBar.hidden = NO;
            self.tableView.hidden = YES;
            
            //groupVC.hidesBottomBarWhenPushed = YES;
            [self.view addSubview:self.groupVC.view];
        }
            break;
        default:
            break;
    }
    [self refreshDataSource];
}

-(void)loadUI
{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    self.searchBar.frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.tableView addSubview:self.slimeView];
    if (self.chatListType != ChatListView) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 24, 24)];
        NSString *imageName ;
        imageName = @"返回";
        [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        self.navigationItem.titleView = self.titleLabel;
        [self.view sendSubviewToBack:self.tableView];
        
        _searchBar.hidden=NO;
        //_tableView.hidden=YES;
        _tableView.frame =CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
        [self.view sendSubviewToBack:self.tableView];
        [self addHeaderRefresh:self.tableView headerRefesh:YES andFooter:YES];
        
        if (self.chatListType == ContactTwainListView) {
            rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setFrame:CGRectMake(0, 0, 60, 40)];
            [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
            [rightButton setTitle:@"地域" forState:UIControlStateNormal];
            [rightButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
            [rightButton.titleLabel setFont:[UIFont systemFontOfSize:17] ];
            [rightButton addTarget:self action:@selector(searchTwainFriend) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        //self.tableView
    }
}

-(void)actionInvite:(NSNotification *)noti
{
    NSString *uid = noti.object;
    NSString *content =[NSString stringWithFormat:@"%@%@",@"诚邀您加入大牛圈APP！金融从业人员的家！这里有干货资讯、人脉嫁接、业务互助！赶快加入吧！",[NSString stringWithFormat:@"%@?uid=%@",SHARE_YAOQING_URL,[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]];
    [self shareToSMS:content rid:uid];
}
-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}
- (void)reloadGroupView
{
    [self reloadApplyView];
}

@end
