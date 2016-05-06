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

#import "ChatGroupDetailViewController.h"

#import "ContactSelectionViewController.h"
#import "GroupSettingViewController.h"
#import "EMGroup.h"
#import "ContactView.h"
#import "GroupBansViewController.h"
#import "GroupSubjectChangingViewController.h"
#import "HeadImage.h"
#import "UIKit+AFNetworking.h"
#import "SHGPersonalViewController.h"

#pragma mark - ChatGroupDetailViewController

#define kColOfRow 5
#define kContactSize 60 * XFACTOR
#define kScrollViewLeftMargin MarginFactor(12.0f)
#define kScrollViewTopMargin MarginFactor(5.0f)
@interface ChatGroupDetailViewController ()<IChatManagerDelegate, EMChooseViewDelegate, ChatListContactViewDelegate,CircleActionDelegate, UIActionSheetDelegate,UIAlertViewDelegate>

- (void)unregisterNotifications;
- (void)registerNotifications;
@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *dissolveButton;
@property (strong, nonatomic) UIButton *configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) ContactView *selectedContact;
@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UITableViewCell *firstCell;

- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;
- (void)configureAction;

@end

@implementation ChatGroupDetailViewController

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self){
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [[EMGroup alloc] initWithGroupId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群组管理";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_backImage"] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];

    self.firstCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    self.firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.firstCell.contentView addSubview:self.scrollView];

    [self fetchGroupInfo];
}

- (void) returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScrollViewLeftMargin, 0.0f, CGRectGetWidth(self.view.frame) - 2 * kScrollViewLeftMargin, kContactSize)];
        _scrollView.tag = 0;
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize, kContactSize)];
        [_addButton setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
        _longPress.minimumPressDuration = 0.1;
    }
    
    return _scrollView;
}

- (UIButton *)dissolveButton
{
    if (_dissolveButton == nil) {
        _dissolveButton = [[UIButton alloc] init];
        [_dissolveButton setTitle:NSLocalizedString(@"group.destroy", @"dissolution of the group") forState:UIControlStateNormal];
        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [_dissolveButton setBackgroundColor: [UIColor colorWithRed:245 / 255.0 green:93 / 255.0 blue:88 / 255.0 alpha:1.0]];
        _dissolveButton.titleLabel.font = FontFactor(16.0f);
    }
    
    return _dissolveButton;
}

- (UIButton *)exitButton
{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:NSLocalizedString(@"group.leave", @"quit the group") forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:[UIColor colorWithRed:245 / 255.0 green:93 / 255.0 blue:88 / 255.0 alpha:1.0]];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    
    return _exitButton;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, MarginFactor(350.0f))];
        _footerView.backgroundColor = [UIColor clearColor];
        
        self.dissolveButton.frame = CGRectMake(kScrollViewLeftMargin, self.footerView.height - MarginFactor(15.0f + 35.0f), _footerView.frame.size.width - 2 * kScrollViewLeftMargin, MarginFactor(35.0f));
        
        self.exitButton.frame = CGRectMake(kScrollViewLeftMargin, self.footerView.height - MarginFactor(15.0f + 35.0f), _footerView.frame.size.width - 2 * kScrollViewLeftMargin, MarginFactor(35.0f));
    }
    
    return _footerView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.occupantType == GroupOccupantTypeOwner){
        return 4;
    } else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = FontFactor(15.0f);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"111111"];
        UIView * lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(kScrollViewLeftMargin, MarginFactor(55.0f) - 1.0f, SCREENWIDTH - kScrollViewLeftMargin, 0.5f);
        lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
        [cell addSubview:lineView];
        self.topLineView = [[UIView alloc]init];
        self.topLineView.frame = CGRectMake(kScrollViewLeftMargin,0.0f, SCREENWIDTH - kScrollViewLeftMargin, 0.5f);
        self.topLineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
        self.topLineView.hidden = YES;
        [cell addSubview:self.topLineView];

    }
    UIImage * image = [UIImage imageNamed:@"rightArrowImage"];
    CGSize size = image.size;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:image forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(SCREENWIDTH - size.width - kScrollViewLeftMargin, (MarginFactor(50.0f) - size.height) / 2.0f , size.width, size.height);
    [cell addSubview:rightButton];
    if (indexPath.row == 0) {
        return self.firstCell;
    } else if (indexPath.row == 1){
        self.topLineView.hidden = NO;
        cell.textLabel.text = NSLocalizedString(@"title.groupSetting", @"Group Setting");
    } else if (indexPath.row == 2){
         if (self.occupantType == GroupOccupantTypeOwner) {
            cell.textLabel.text = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");
         } else{
             cell.textLabel.text = @"清空聊天记录";
             rightButton.hidden = YES;
         }
        

    } else if(indexPath.row==3){
        cell.textLabel.text = @"清空聊天记录";
        rightButton.hidden = YES;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + MarginFactor(10.0f);
    } else {
        return MarginFactor(55.0f);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        GroupSettingViewController *settingController = [[GroupSettingViewController alloc] initWithGroup:_chatGroup];
        [self.navigationController pushViewController:settingController animated:YES];
    } else if (indexPath.row == 2)
    {
        if (self.occupantType == GroupOccupantTypeOwner){
            GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:_chatGroup];
            [self.navigationController pushViewController:changingController animated:YES];
        } else{
            [self clearAction];
        }
    } else if(indexPath.row==3){
        [self clearAction];
    }
}

#pragma mark - EMChooseViewDelegate
- (void)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (EMBuddy *buddy in selectedSources) {
            [source addObject:buddy.username];
        }
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.groupSubject];
        EMError *error = nil;
        weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        if (!error) {
            [weakSelf reloadDataSource];
        }
    });
}

- (void)groupBansChanged
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    [self refreshScrollView];
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [Hud showWait];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Hud hideHud];
            if (!error) {
                weakSelf.chatGroup = group;
                [weakSelf reloadDataSource];
            } else{
                [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
            }
        });
    } onQueue:nil];
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    self.occupantType = GroupOccupantTypeMember;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshScrollView];
        [self refreshFooterView];
        [self hideHud];
    });
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeGestureRecognizer:_longPress];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.occupantType == GroupOccupantTypeOwner) {
        [self.scrollView addGestureRecognizer:_longPress];
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    } else if (self.chatGroup.groupSetting.groupStyle == eGroupStyle_PrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }

    [self configUser:showAddButton];
}

- (void)configUser:(BOOL)showAddButton
{
    __block NSString *param = @"";
    __weak typeof(self)weakSelf = self;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        param = [param stringByAppendingFormat:@"%@,",obj];
    }];
    param = [param substringToIndex:param.length - 1];
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"groupUserInfo"] parameters:@{@"userIDArray":param} success:^(MOCHTTPResponse *response) {
        NSArray *array = response.dataArray;
        NSInteger tmp = (array.count + 1) % kColOfRow;
        NSInteger row = (NSInteger)(array.count + 1) / kColOfRow;
        row += tmp == 0 ? 0 : 1;
        weakSelf.scrollView.tag = row;
        weakSelf.scrollView.frame = CGRectMake(8, kScrollViewTopMargin, weakSelf.tableView.frame.size.width - 16, row * kContactSize + 10);
        weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.frame.size.width, row * kContactSize);
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        
        NSInteger i = 0;
        NSInteger j = 0;
        BOOL isEditing = weakSelf.addButton.hidden ? YES : NO;
        BOOL isEnd = NO;
        BOOL isStatus = YES;
        for (i = 0; i < row; i++) {
            for (j = 0; j < kColOfRow; j++) {
                NSInteger index = i * kColOfRow + j;
                if (index < array.count){
                    NSDictionary *dictionary = [array objectAtIndex:index];
                    ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                    contactView.delegate = weakSelf;
                    contactView.userID = [dictionary objectForKey:@"userid"];
                    contactView.index = i * kColOfRow + j;
                    //如果是自己
                    isStatus= [[dictionary objectForKey:@"userstatus"] boolValue];
                    if (isStatus == YES) {
                        contactView.VImageView.hidden=NO;
                    }
                    
                    contactView.remark = [dictionary objectForKey:@"realname"];
                    NSString *url = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,[dictionary valueForKey:@"headimageurl"]];

                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
                    [contactView.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"default_head"] success:nil failure:nil];

                    if (![[dictionary objectForKey:@"userid"] isEqualToString:loginUsername]) {
                        contactView.editing = isEditing;
                    }
                    [contactView setDeleteContact:^(NSInteger index) {
                        [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
                        NSArray *occupants = [NSArray arrayWithObject:[weakSelf.dataSource objectAtIndex:index]];
                        [[EaseMob sharedInstance].chatManager asyncRemoveOccupants:occupants fromGroup:weakSelf.chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
                            [weakSelf hideHud];
                            if (!error) {
                                weakSelf.chatGroup = group;
                                [weakSelf.dataSource removeObjectAtIndex:index];
                                [weakSelf refreshScrollView];
                            } else{
                                [weakSelf showHint:error.description];
                            }
                        } onQueue:nil];
                    }];

                    [weakSelf.scrollView addSubview:contactView];
                } else{
                    if(showAddButton && index <= self.dataSource.count){
                        weakSelf.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize -10, kContactSize - 10);
                    }
                    isEnd = YES;
                    break;
                }
            }
            if (isEnd) {
                break;
            }
        }
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {

    }];
}

- (void)refreshFooterView
{
    if (self.occupantType == GroupOccupantTypeOwner) {
        [_exitButton removeFromSuperview];
        [_footerView addSubview:self.dissolveButton];
    }
    else{
        [_dissolveButton removeFromSuperview];
        [_footerView addSubview:self.exitButton];
    }
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)didSelecedView:(ContactView *)view
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = view.userID;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        for (ContactView *contactView in self.scrollView.subviews)
        {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton))
            {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), nil];
                    [sheet showInView:self.view];
                }
            }
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    
    for (ContactView *contactView in self.scrollView.subviews)
    {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            
            [contactView setEditing:isEditing];
        }
    }
    
    self.addButton.hidden = isEditing;
}

- (void)addContact:(id)sender
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

//清空聊天记录
- (void)clearAction
{
    __weak typeof(self) weakSelf = self;
    
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") contentText:NSLocalizedString(@"sureToDelete", @"please make sure to delete") leftButtonTitle:NSLocalizedString(@"cancel", @"Cancel") rightButtonTitle:NSLocalizedString(@"ok", @"OK")];
    alert.rightBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.chatGroup.groupId];
    };
    [alert show];
}

//解散群组
- (void)dissolveAction
{
    //提示
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") contentText:@"确定解散该群组?" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    __weak typeof(self)weakSelf = self;
    alert.rightBlock = ^{
        [weakSelf dissolveActionOperator];
    };
    [alert show];
}

-(void) dissolveActionOperator
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
        }
    } onQueue:nil];
}

//设置群组
- (void)configureAction {
// todo
    [[[EaseMob sharedInstance] chatManager] asyncIgnoreGroupPushNotification:_chatGroup.groupId isIgnore:_chatGroup.isPushNotificationEnabled];

    return;
}

//退出群组
- (void)exitAction
{
    __weak typeof(self) weakSelf = self;
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"确定退出该群组?" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.rightBlock = ^{
        [weakSelf showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
        [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        } onQueue:nil];
        
    };
    [alert show];
    
}

- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList error:(EMError *)error {
// todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0)
    {
        _selectedContact.deleteContact(index);
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    _selectedContact = nil;
}
@end
