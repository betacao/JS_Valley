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

#import "PublicGroupDetailViewController.h"

@interface PublicGroupDetailViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) EMGroup *group;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footerButton;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation PublicGroupDetailViewController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"PublicGroupDetailViewController" label:@"onClick"];
    
}

- (void)getGroupManagerName
{
    __weak typeof(self) weakSelf = self;
    NSString * uid = weakSelf.group.owner;
    if (!uid.length == 0) {
        [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (cell) {
                NSString *name = [response.dataDictionary valueForKey:@"name"];
                cell.detailTextLabel.text = name.length > 0 ? name : uid;
            }
        }failed:^(MOCHTTPResponse *response) {
            [weakSelf.tableView.header endRefreshing];
            
        }];

    }else{
        return;
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_backImage"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=rightItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    [self fetchGroupInfo];
}

- (void) returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        imageView.image = [UIImage imageNamed:@"群头像图标"];
        [_headerView addSubview:imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, _headerView.frame.size.width - 80 - 20, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = (_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId;
        [_headerView addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, SCREENWIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-150-64-10)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        [_footerView addSubview:line];
        
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(14.0f, _footerView.height-35, _footerView.frame.size.width - 28.0f, 35)];
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerButton setBackgroundColor:[UIColor colorWithHexString:@"F04241"]];
        _footerButton.enabled = NO;
        [_footerView addSubview:_footerButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"AFAFAF"];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.height-1, self.tableView.width-15, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [cell.contentView addSubview:lineView];
    }
    
    if (indexPath.row == 0){
        cell.textLabel.text = NSLocalizedString(@"group.owner", @"Owner");
       // cell.detailTextLabel.text = _group.owner;
        
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"群成员";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld人",(long)_group.groupOccupantsCount];
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = NSLocalizedString(@"group.describe", @"Describe");
        cell.detailTextLabel.text = _group.groupDescription;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 50;
    }
    else{
      // CGSize size = [_group.groupDescription sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [_group.groupDescription boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
        return size.height > 30 ? (20 + size.height) : 50;
    }
}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        if (messageTextField.text.length > 0) {
            messageStr = messageTextField.text;
        }
        [self applyJoinGroup:_groupId withGroupname:_group.groupSubject message:messageStr];
    }
}

#pragma mark - action

- (BOOL)isJoined:(EMGroup *)group
{
    if (group) {
        NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *tmpGroup in groupList) {
            if (tmpGroup.isPublic == group.isPublic && [group.groupId isEqualToString:tmpGroup.groupId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)fetchGroupInfo
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_groupId completion:^(EMGroup *group, EMError *error) {
        weakSelf.group = group;
        [weakSelf reloadSubviewsInfo];
        [weakSelf getGroupManagerName];
        [weakSelf hideHud];
    } onQueue:nil];
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nameLabel.text = (weakSelf.group.groupSubject && weakSelf.group.groupSubject.length) > 0 ? weakSelf.group.groupSubject : weakSelf.group.groupId;
        if ([weakSelf isJoined:weakSelf.group]) {
            weakSelf.footerButton.enabled = NO;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.joined", @"joined") forState:UIControlStateNormal | UIControlStateDisabled];
        }
        else{
            weakSelf.footerButton.enabled = YES;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        }
        [weakSelf.tableView reloadData];
    });
}

- (void)showMessageAlertView
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"saySomething", @"say somthing") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [alert show];
    //空信息
    [self applyJoinGroup:_groupId withGroupname:_group.groupSubject message:@""];
}

#pragma mark -加入群组
- (void)joinAction
{
    if (self.group.groupSetting.groupStyle == eGroupStyle_PublicJoinNeedApproval) {
        [self showMessageAlertView];
    }
    else if (self.group.groupSetting.groupStyle == eGroupStyle_PublicOpenJoin)
    {
        [self joinGroup:_groupId];
    }
}

- (void)joinGroup:(NSString *)groupId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.join.ongoing", @"join the group...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:groupId completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if(!error)
        {
            [MobClick endEvent:@"JoinGroupAction" label:@"onClick"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.join.fail", @"again failed to join the group, please")];
        }
    } onQueue:nil];
}

- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:groupId withGroupname:groupName message:message completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
        }
        else{
            [weakSelf showHint:error.description];
        }
    } onQueue:nil];
}

@end
