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
@property (nonatomic, strong) UIView *firstView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *nameDetailLabel;
@property (nonatomic, strong) UIView *secondView;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *numDetailLabel;
@property (nonatomic, strong) UIView *thirdView;
@property (strong, nonatomic) UILabel *introductionLabel;
@property (strong, nonatomic) UILabel *introductionDetailLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *addButton;
@end


@implementation PublicGroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_backImage"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    [self initView];
    [self fetchGroupInfo];
}

- (void)initView
{
    self.firstView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.secondView.sd_layout
    .topSpaceToView(self.firstView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, MarginFactor(0.0f))
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.thirdView.sd_layout
    .topSpaceToView(self.secondView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, 0.0)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.firstView, 0.0f)
    .bottomSpaceToView(self.firstView, 0.0f)
    .leftSpaceToView(self.firstView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH / 2.0f);
    
    self.nameDetailLabel.sd_layout
    .topSpaceToView(self.firstView, 0.0f)
    .bottomSpaceToView(self.firstView, 0.0f)
    .rightSpaceToView(self.firstView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH / 2.0f);
    
    self.numLabel.sd_layout
    .topSpaceToView(self.secondView, 0.0f)
    .bottomSpaceToView(self.secondView, 0.0f)
    .leftSpaceToView(self.secondView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH / 2.0f);
    
    self.numDetailLabel.sd_layout
    .topSpaceToView(self.secondView, 0.0f)
    .bottomSpaceToView(self.secondView, 0.0f)
    .rightSpaceToView(self.secondView, MarginFactor(12.0f))
    .widthIs(SCREENWIDTH / 2.0f);
    
    self.introductionLabel.sd_layout
    .topSpaceToView(self.thirdView, 0.0f)
    .leftSpaceToView(self.thirdView, MarginFactor(12.0f))
    .heightIs(MarginFactor(55.0f))
    .widthIs(SCREENWIDTH);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.thirdView, MarginFactor(12.0f))
    .topSpaceToView(self.introductionLabel, 0.0f)
    .rightSpaceToView(self.thirdView, 0.0f)
    .heightIs(0.5f);
    
    self.addButton.sd_layout
    .leftSpaceToView(self.thirdView, MarginFactor(12.0f))
    .rightSpaceToView(self.thirdView, MarginFactor(12.0f))
    .bottomSpaceToView(self.thirdView, MarginFactor(19.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.introductionDetailLabel.sd_layout
    .topSpaceToView(self.lineView, MarginFactor(17.0f))
    .leftSpaceToView(self.thirdView, MarginFactor(12.0f))
    .rightSpaceToView(self.thirdView, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    self.introductionDetailLabel.isAttributedContent = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"PublicGroupDetailViewController" label:@"onClick"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)getGroupManagerName
{
    __weak typeof(self) weakSelf = self;
    NSString * uid = weakSelf.group.owner;
    if (uid.length > 0) {
        [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"personaluser"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
            self.nameDetailLabel.text = [response.dataDictionary objectForKey:@"name"];
        }failed:^(MOCHTTPResponse *response) {
            
        }];
        
    } else{
        return;
    }
    
}


- (UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.backgroundColor = [UIColor whiteColor];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = @"群主";
        _nameLabel.font = FontFactor(16.0f);
        _nameLabel.textColor = [UIColor colorWithHexString:@"161616"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_firstView addSubview:_nameLabel];
        
        _nameDetailLabel = [[UILabel alloc] init];
        _nameDetailLabel.backgroundColor = [UIColor clearColor];
        _nameDetailLabel.font = FontFactor(15.0f);
        _nameDetailLabel.textColor = [UIColor colorWithHexString:@"565656"];
        _nameDetailLabel.textAlignment = NSTextAlignmentRight;
        [_firstView addSubview:_nameDetailLabel];
        [self.view addSubview:_firstView];
    }
    return _firstView;
}

- (UIView *)secondView
{
    if (!_secondView) {
        _secondView = [[UIView alloc] init];
        _secondView.backgroundColor = [UIColor whiteColor];
        _numLabel = [[UILabel alloc] init];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.text = @"群成员";
        _numLabel.font = FontFactor(16.0f);
        _numLabel.textColor = [UIColor colorWithHexString:@"161616"];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        [_secondView addSubview:_numLabel];
        
        _numDetailLabel = [[UILabel alloc] init];
        _numDetailLabel.backgroundColor = [UIColor clearColor];
        _numDetailLabel.font = FontFactor(15.0f);
        _numDetailLabel.textColor = [UIColor colorWithHexString:@"565656"];
        _numDetailLabel.textAlignment = NSTextAlignmentRight;
        [_secondView addSubview:_numDetailLabel];
        [self.view addSubview:_secondView];
    }
    return _secondView;
}

- (UIView *)thirdView
{
    if (!_thirdView) {
        _thirdView = [[UIView alloc] init];
        _thirdView.backgroundColor = [UIColor whiteColor];
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.backgroundColor = [UIColor clearColor];
        _introductionLabel.text = @"群组简介";
        _introductionLabel.font = FontFactor(16.0f);
        _introductionLabel.textColor = [UIColor colorWithHexString:@"161616"];
        _introductionLabel.textAlignment = NSTextAlignmentLeft;
        [_thirdView addSubview:_introductionLabel];
        
        _introductionDetailLabel = [[UILabel alloc] init];
        _introductionDetailLabel.backgroundColor = [UIColor clearColor];
        _introductionDetailLabel.font = FontFactor(15.0f);
        _introductionDetailLabel.textColor = [UIColor colorWithHexString:@"565656"];
        _introductionDetailLabel.textAlignment = NSTextAlignmentLeft;
        _introductionDetailLabel.numberOfLines = 0;
        [_thirdView addSubview:_introductionDetailLabel];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
        [self.thirdView addSubview:_lineView];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.titleLabel.font = FontFactor(15.0f);
        [_addButton setTitle:@"加入群组" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setBackgroundColor:[UIColor colorWithHexString:@"F04241"]];
        _addButton.enabled = NO;
        [_thirdView addSubview:_addButton];
        [self.view addSubview:_thirdView];
    }
    return _thirdView;
}

- (void) returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [Hud showWait];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_groupId completion:^(EMGroup *group, EMError *error) {
        weakSelf.group = group;
        self.numDetailLabel.text = [NSString stringWithFormat:@"%ld人",(long)_group.groupOccupantsCount];
        self.introductionDetailLabel.text = weakSelf.group.groupDescription;
        [self.introductionDetailLabel sizeToFit];
        [weakSelf reloadSubviewsInfo];
        [weakSelf getGroupManagerName];
        [Hud hideHud];
    } onQueue:nil];
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf isJoined:weakSelf.group]) {
            weakSelf.addButton.enabled = NO;
            [weakSelf.addButton setTitle:NSLocalizedString(@"group.joined", @"joined") forState:UIControlStateNormal | UIControlStateDisabled];
        } else{
            weakSelf.addButton.enabled = YES;
            [weakSelf.addButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        }
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
    } else if (self.group.groupSetting.groupStyle == eGroupStyle_PublicOpenJoin)
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
        if(!error){
            [MobClick endEvent:@"JoinGroupAction" label:@"onClick"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else{
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
        } else{
            [weakSelf showHint:error.description];
        }
    } onQueue:nil];
}

@end
