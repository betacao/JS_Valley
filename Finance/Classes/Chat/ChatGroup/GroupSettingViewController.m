//
//  GroupSettingViewController.m
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-8-18.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import "GroupSettingViewController.h"

@interface GroupSettingViewController ()
{
    EMGroup *_group;
    BOOL _isOwner;
    UISwitch *_pushSwitch;
    UISwitch *_blockSwitch;
}
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation GroupSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithGroup:(EMGroup *)group
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _group = group;
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        _isOwner = [_group.owner isEqualToString:loginUsername];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.groupSetting", @"Group Setting");
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_backImage"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!_isOwner) {
        self.saveButton.hidden = NO;
    } else{
        self.saveButton.hidden = YES;
    }
    
    UIImage * image = [UIImage imageNamed:@"switchOf"];
    CGSize size = image.size;
    _pushSwitch = [[UISwitch alloc] init];
    [_pushSwitch setOffImage:[UIImage imageNamed:@"switchOf"]];
    [_pushSwitch setOnImage:[UIImage imageNamed:@"switchOn"]];
    _pushSwitch.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
    [_pushSwitch addTarget:self action:@selector(pushSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [_pushSwitch setOn:_group.isPushNotificationEnabled animated:YES];
    
    _blockSwitch = [[UISwitch alloc] init];
    [_blockSwitch setOffImage:[UIImage imageNamed:@"switchOf"]];
    [_blockSwitch setOnImage:[UIImage imageNamed:@"switchOn"]];
    _blockSwitch.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
    [_blockSwitch addTarget:self action:@selector(blockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [_blockSwitch setOn:_group.isBlocked animated:YES];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
}


- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(MarginFactor(14.0f), self.view.frame.size.height - MarginFactor(15.0f + 35.0f) - 44.0f , SCREENWIDTH - 2 *MarginFactor(14.0f), MarginFactor(35.0f));
        _saveButton.hidden = YES;
        _saveButton.titleLabel.font = FontFactor(17.0f);
        _saveButton.backgroundColor = [UIColor colorWithHexString:@"f04241"];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];

    }
    return _saveButton;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideHud];
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
    if (_isOwner) {
        return 1;
    }
    else{
        if (_blockSwitch.isOn) {
            return 1;
        }
        else{
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(MarginFactor(15.0f), MarginFactor(54.0f), SCREENWIDTH - CGRectGetMidX(cell.textLabel.frame) , 0.5f)];
       lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
        [cell.contentView addSubview:lineView];
    }
    
    cell.textLabel.font = FontFactor(15.0f);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"111111"];
    if ((_isOwner && indexPath.row == 0) || (!_isOwner && indexPath.row == 1)) {
        _pushSwitch.frame = CGRectMake(self.tableView.frame.size.width - (_pushSwitch.frame.size.width + MarginFactor(12.0f)), (cell.contentView.frame.size.height - _pushSwitch.frame.size.height) / 2, _pushSwitch.frame.size.width, _pushSwitch.frame.size.height);
        
        if (_pushSwitch.isOn) {
            cell.textLabel.text = NSLocalizedString(@"group.setting.receiveAndPrompt", @"receive and prompt group of messages");
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"group.setting.receiveAndUnprompt", @"receive not only hint of messages");
        }
        
        [cell.contentView addSubview:_pushSwitch];
        [cell.contentView bringSubviewToFront:_pushSwitch];
    }
    else if(!_isOwner && indexPath.row == 0){
        _blockSwitch.frame = CGRectMake(self.tableView.frame.size.width - (_blockSwitch.frame.size.width + MarginFactor(12.0f)), (cell.contentView.frame.size.height - _blockSwitch.frame.size.height) / 2, _blockSwitch.frame.size.width, _blockSwitch.frame.size.height);
        
        cell.textLabel.text = NSLocalizedString(@"group.setting.blockMessage", @"shielding of the message");
        [cell.contentView addSubview:_blockSwitch];
        [cell.contentView bringSubviewToFront:_blockSwitch];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(55.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private

- (void)isIgnoreGroup:(BOOL)isIgnore
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.setting.save", @"set properties")];
    
    __weak GroupSettingViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncIgnoreGroupPushNotification:_group.groupId isIgnore:isIgnore completion:^(NSArray *ignoreGroupsList, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
        }
    } onQueue:nil];
}

#pragma mark - action

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushSwitchChanged:(id)sender
{
    if (_isOwner) {
        BOOL toOn = _pushSwitch.isOn;
        [self isIgnoreGroup:!toOn];
    }
    [self.tableView reloadData];
}

- (void)blockSwitchChanged:(id)sender
{
    [self.tableView reloadData];
}

- (void)saveAction:(id)sender
{
    if (_blockSwitch.isOn != _group.isBlocked) {
        WEAK(self, weakSelf);
        [self showHudInView:self.view hint:NSLocalizedString(@"group.setting.save", @"set properties")];
        if (_blockSwitch.isOn) {
            [[EaseMob sharedInstance].chatManager asyncBlockGroup:_group.groupId completion:^(EMGroup *group, EMError *error) {
                [weakSelf hideHud];
                [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
            } onQueue:nil];
        }
        else{
            [[EaseMob sharedInstance].chatManager asyncUnblockGroup:_group.groupId completion:^(EMGroup *group, EMError *error) {
                [weakSelf hideHud];
                [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
            } onQueue:nil];
        }
    }
    
    if (_pushSwitch.isOn != _group.isPushNotificationEnabled) {
        [self isIgnoreGroup:!_pushSwitch.isOn];
    }
}

@end
