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

#import "CreateGroupViewController.h"

#import "ContactSelectionViewController.h"
#import "EMTextView.h"

@interface CreateGroupViewController ()<UITextFieldDelegate, UITextViewDelegate, EMChooseViewDelegate>

@property (strong, nonatomic) UIView *switchView;
@property (strong, nonatomic) UIBarButtonItem *rightItem;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) EMTextView *textView;

@property (nonatomic) BOOL isPublic;
@property (strong, nonatomic) UILabel *groupTypeLabel;//群组类型

@property (nonatomic) BOOL isMemberOn;
@property (strong, nonatomic) UILabel *groupMemberTitleLabel;
@property (strong, nonatomic) UISwitch *groupMemberSwitch;
@property (strong, nonatomic) UILabel *groupMemberLabel;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIView *mainFieldView;
@property (strong, nonatomic) UIView *mainTextView;
@property (strong, nonatomic) UIView *fieldTopLine;
@property (strong, nonatomic) UIView *fieldBottomLine;
@property (strong, nonatomic) UIView *viewTopLine;
@property (strong, nonatomic) UIView *viewBottomLine;
@property (strong, nonatomic) UIView *switchTopLine;
@property (strong, nonatomic) UIView *switchBottomLine;
@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPublic = NO;
        _isMemberOn = NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CreateGroupViewController" label:@"onClick"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.createGroup", @"Create a group");
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self loadInitView];
}

- (void)loadInitView
{
    self.mainFieldView.sd_layout
    .topSpaceToView(self.view, MarginFactor(10.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(45.0f));
    
    self.mainTextView.sd_layout
    .topSpaceToView(self.mainFieldView, MarginFactor(10.0f))
    .leftEqualToView(self.mainFieldView)
    .rightEqualToView(self.mainFieldView)
    .heightIs(MarginFactor(82.0f));
    
    self.switchView.sd_layout
    .topSpaceToView(self.mainTextView, MarginFactor(10.0f))
    .leftEqualToView(self.mainTextView)
    .rightEqualToView(self.mainTextView)
    .heightIs(MarginFactor(45.0f));
    
    self.addButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(15.0f))
    .bottomSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.textField.sd_layout
    .leftSpaceToView(self.mainFieldView, MarginFactor(12.0f))
    .topSpaceToView(self.mainFieldView, 0.0f)
    .rightSpaceToView(self.mainFieldView, MarginFactor(12.0f))
    .bottomSpaceToView(self.mainFieldView, 0.0f);
    
    self.textView.sd_layout
    .leftSpaceToView(self.mainTextView,MarginFactor(8.0f))
    .topSpaceToView(self.mainTextView, 0.0f)
    .rightSpaceToView(self.mainTextView, MarginFactor(12.0f))
    .bottomSpaceToView(self.mainTextView, 0.0f);
    
    self.groupMemberTitleLabel.sd_layout
    .leftSpaceToView(self.switchView, MarginFactor(12.0f))
    .topSpaceToView(self.switchView, 0.0f)
    .widthIs(MarginFactor(160.0f))
    .heightIs(45.0f);
    
    UIImage *image = [UIImage imageNamed:@"switchOn"];
    CGSize size = image.size;
    self.groupMemberSwitch.sd_layout
    .rightSpaceToView(self.switchView, MarginFactor(12.0f))
    .centerYEqualToView(self.groupMemberTitleLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.fieldTopLine.sd_layout
    .topSpaceToView(self.mainFieldView, 0.0f)
    .leftSpaceToView(self.mainFieldView, 0.0f)
    .rightSpaceToView(self.mainFieldView, 0.0f)
    .heightIs(0.5f);

    self.viewTopLine.sd_layout
    .topSpaceToView(self.mainTextView, 0.0f)
    .leftSpaceToView(self.mainTextView, 0.0f)
    .rightSpaceToView(self.mainTextView, 0.0f)
    .heightIs(0.5f);
    
    self.switchTopLine.sd_layout
    .topSpaceToView(self.switchView, 0.0f)
    .leftSpaceToView(self.switchView, 0.0f)
    .rightSpaceToView(self.switchView, 0.0f)
    .heightIs(0.5f);
    
    self.fieldBottomLine.sd_layout
    .bottomSpaceToView(self.mainFieldView, 0.0f)
    .leftSpaceToView(self.mainFieldView, 0.0f)
    .rightSpaceToView(self.mainFieldView, 0.0f)
    .heightIs(0.5f);

    self.viewBottomLine.sd_layout
    .bottomSpaceToView(self.mainTextView, 0.0f)
    .leftSpaceToView(self.mainTextView, 0.0f)
    .rightSpaceToView(self.mainTextView, 0.0f)
    .heightIs(0.5f);
    
    self.switchBottomLine.sd_layout
    .bottomSpaceToView(self.switchView, 0.0f)
    .leftSpaceToView(self.switchView, 0.0f)
    .rightSpaceToView(self.switchView, 0.0f)
    .heightIs(0.5f);
    
}
- (UIView *)mainFieldView
{
    if (!_mainFieldView) {
        _mainFieldView = [[UIView alloc]init];
        _mainFieldView.backgroundColor=[UIColor whiteColor];
        _fieldTopLine= [[UIView alloc]init];
        _fieldTopLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_mainFieldView addSubview:_fieldTopLine];
        _fieldBottomLine= [[UIView alloc]init];
        _fieldBottomLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_mainFieldView addSubview:_fieldBottomLine];
        
        [self.view addSubview:_mainFieldView];
    }
    return _mainFieldView;
}
- (UIView *)mainTextView
{
    if (!_mainTextView) {
        _mainTextView = [[UIView alloc]init];
        _mainTextView.backgroundColor=[UIColor whiteColor];
        _viewTopLine= [[UIView alloc]init];
        _viewTopLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_mainTextView addSubview:_viewTopLine];
        _viewBottomLine= [[UIView alloc]init];
        _viewBottomLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_mainTextView addSubview:_viewBottomLine];
        [self.view addSubview:_mainTextView];
    }
    return _mainTextView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor colorWithHexString:@"606060"];
        _textField.font = FontFactor(15.0f);
        _textField.backgroundColor = [UIColor clearColor];
        _textField.placeholder = NSLocalizedString(@"group.create.inputName", @"please enter the group name");
        [self.textField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self.mainFieldView addSubview:_textField];
    }
    return _textField;
}

- (EMTextView *)textView
{
    if (!_textView ) {
        _textView = [[EMTextView alloc] init];
        _textView.textColor = [UIColor colorWithHexString:@"606060"];
        _textView.font = FontFactor(15.0f);
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholder = @"请输入群组简介（150字）";
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        [self.mainTextView addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
        [_addButton setTitle:NSLocalizedString(@"group.create.addOccupant", @"add members") forState:UIControlStateNormal];
        [_addButton sizeToFit];
        [_addButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addContacts:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}
- (UIView *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UIView alloc] init];
        _switchView.backgroundColor = [UIColor whiteColor];
        _switchTopLine= [[UIView alloc]init];
        _switchTopLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_switchView addSubview:_switchTopLine];
         _switchBottomLine= [[UIView alloc]init];
        _switchBottomLine.backgroundColor = [UIColor colorWithHexString:@"e7e5e7"];
        [_switchView addSubview:_switchBottomLine];
        [self.view addSubview:_switchView];
    }
    
    return _switchView;
}

- (UILabel *)groupMemberTitleLabel
{
    if (!_groupMemberTitleLabel) {
        _groupMemberTitleLabel = [[UILabel alloc] init];
        _groupMemberTitleLabel.font = FontFactor(15.0f);
        _groupMemberTitleLabel.backgroundColor = [UIColor clearColor];
        _groupMemberTitleLabel.text = @"开放群成员邀请";
        _groupMemberTitleLabel.textColor = [UIColor colorWithHexString:@"606060"];
        [self.switchView addSubview:_groupMemberTitleLabel];
    }
    return _groupMemberTitleLabel;
}

- (UISwitch *)groupMemberSwitch
{
    if (!_groupMemberSwitch) {
         _groupMemberSwitch = [[UISwitch alloc] init];
        [_groupMemberSwitch addTarget:self action:@selector(groupMemberChange:) forControlEvents:UIControlEventValueChanged];
        [self.groupMemberSwitch setOnImage:[UIImage imageNamed:@"switchOn"]];
        [self.groupMemberSwitch setOffImage:[UIImage imageNamed:@"switchOf"]];
        [self.switchView addSubview:_groupMemberSwitch];
    }
    return _groupMemberSwitch;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    #define MY_MAX 150
    if ((textView.text.length - range.length + text.length) > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - EMChooseViewDelegate

- (void)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
    
    NSMutableArray *source = [NSMutableArray array];
    for (EMBuddy *buddy in selectedSources) {
        [source addObject:buddy.username];
    }
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    if (_isPublic) {
        if(_isMemberOn)
        {
            setting.groupStyle = eGroupStyle_PublicOpenJoin;
        }
        else{
            setting.groupStyle = eGroupStyle_PublicJoinNeedApproval;
        }
    }
    else{
        if(_isMemberOn)
        {
            setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
        }
        else{
            setting.groupStyle = eGroupStyle_PrivateOnlyOwnerInvite;
        }
    }
    
//    setting.groupMaxUsersCount = 4;
    __weak CreateGroupViewController *weakSelf = self;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *username = [loginInfo objectForKey:kSDKUsername];
    NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join groups \'%@\'"), username, self.textField.text];
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:self.textField.text description:self.textView.text invitees:source initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (group && !error) {
            [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
        }
    } onQueue:nil];
}

#pragma mark - action

- (void)groupTypeChange:(UISwitch *)control
{
    _isPublic = control.isOn;
    
    [_groupMemberSwitch setOn:NO animated:NO];
    [self groupMemberChange:_groupMemberSwitch];
    
    if (control.isOn) {
        _groupTypeLabel.text = NSLocalizedString(@"group.create.public", @"public group");
    }
    else{
        _groupTypeLabel.text = NSLocalizedString(@"group.create.private", @"private group");
    }
}

- (void)groupMemberChange:(UISwitch *)control
{
//    if (_isPublic) {
//        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantJoinPermissions", @"members join permissions");
//        if(control.isOn)
//        {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.open", @"random join");
//        }
//        else{
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.needApply", @"you need administrator agreed to join the group");
//        }
//    }
//    else{
//        _groupMemberTitleLabel.text = NSLocalizedString(@"group.create.occupantPermissions", @"members invite permissions");
//        if(control.isOn)
//        {
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.allowedOccupantInvite", @"allows group members to invite others");
//        }
//        else{
//            _groupMemberLabel.text = NSLocalizedString(@"group.create.unallowedOccupantInvite", @"don't allow group members to invite others");
//        }
//    }
    
    _isMemberOn = control.isOn;
}

- (void)addContacts:(id)sender
{
    if (self.textField.text.length == 0) {
        [Hud showMessageWithText:NSLocalizedString(@"group.create.inputName", @"please enter the group name")];
        return;
    }
    
    [self.view endEditing:YES];
    
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] init];
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

@end
