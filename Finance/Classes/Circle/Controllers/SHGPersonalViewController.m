//
//  SHGPersonalViewController.m
//  Finance
//
//  Created by changxicao on 15/11/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonalViewController.h"
#import "SHGUserTagModel.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "SHGPersonFriendsViewController.h"
#import "SDPhotoBrowser.h"
#import "SHGPersonalTableViewCell.h"
#import "SHGBusinessMineViewController.h"
#import "SHGAuthenticationView.h"

#define kTagViewWidth 45.0f * XFACTOR
#define kTagViewHeight 16.0f * XFACTOR
#define kBottomViewLeftMargin 14.0f
#define kHeaderViewHeight MarginFactor(82.0f)

typedef NS_ENUM(NSInteger, SHGUserType) {
    //马甲号类型
    SHGUserTypeVest = 0,
    //真实用户
    SHGUserTypeRegister = 1,
    //管理员(类似大牛圈)
    SHGUserTypeOperator = 2,
    //聚合账号（类似领今）
    SHGUserTypeBusinessAccount = 3,
    //其他
    SHGUserTypeOther
};


@interface SHGPersonalViewController ()<UITableViewDataSource, UITableViewDelegate, CircleActionDelegate, SDPhotoBrowserDelegate>
//界面
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;

//数据
@property (strong, nonatomic) NSString *department;//职称
@property (strong, nonatomic) NSString *relationShip;//关注
@property (assign, nonatomic) BOOL isCollected;
@property (strong, nonatomic) NSString *potName;
@property (strong, nonatomic) NSString *dynamicNumber;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *userStatus;
@property (assign, nonatomic) BOOL businessStatus;
@property (strong, nonatomic) NSString *friendNumber;
@property (strong, nonatomic) NSString *friendShip;
@property (assign, nonatomic) SHGUserType userType;
@property (strong, nonatomic) NSString * position;
@property (strong, nonatomic) NSString * tags;
@property (strong, nonatomic) NSString * commonfriends;
@property (strong, nonatomic) NSString * businessTotal;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (assign, nonatomic) BOOL isCardChange;
@end

@implementation SHGPersonalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人动态";
    self.isCardChange = YES;
    [self initView];
    [self addSdLayout];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self requestDataWithTarget:@"first" time:@"-1"];
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    if (attationState) {
        self.relationShip = @"1";
    } else {
        self.relationShip = @"0";
    }
    [self refreshFriendShip];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isCardChange) {
        [self.controller changeCardCollection];
    }
}

- (void)initView
{
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
    [self.headerImageView addGestureRecognizer:recognizer];
    
    self.userNameLabel.font = FontFactor(16.0f);
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"1d5798"];
    self.departmentLabel.font = FontFactor(14.0f);
    self.departmentLabel.textColor = [UIColor colorWithHexString:@"565656"];
    self.companyLabel.font = FontFactor(14.0f);
    self.companyLabel.textColor = [UIColor colorWithHexString:@"565656"];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    self.sendMessageButton.titleLabel.font = FontFactor(15.0f);
    self.collectButton.titleLabel.font = FontFactor(15.0f);
    self.grayView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
}

- (void)addSdLayout
{
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.headerView, MarginFactor(15.0f))
    .leftSpaceToView(self.headerView, MarginFactor(12.0f))
    .widthIs(MarginFactor(50.0f))
    .heightIs(MarginFactor(50.0f));
    
    self.userNameLabel.sd_layout
    .leftSpaceToView(self.headerImageView, MarginFactor(10.0f))
    .topEqualToView(self.headerImageView)
    .heightIs(self.userNameLabel.font.lineHeight);
    [self.userNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.departmentLabel.sd_layout
    .leftSpaceToView(self.userNameLabel, MarginFactor(10.0f))
    .bottomEqualToView(self.userNameLabel)
    .heightIs(self.departmentLabel.font.lineHeight)
    .offset(MarginFactor(-2.0f));
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.authenticationView.sd_layout
    .leftSpaceToView(self.departmentLabel, MarginFactor(5.0f))
    .centerYEqualToView(self.departmentLabel);
    
    self.companyLabel.sd_layout
    .leftEqualToView(self.userNameLabel)
    .bottomEqualToView(self.headerImageView)
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *image = [UIImage imageNamed:@"first_friend.png"];
    CGSize size = image.size;
    self.friendImage.sd_layout
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.headerView, 0.0f)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.headerImageView, MarginFactor(15.0f))
    .heightIs(0.5f);
    
    self.centerLine.sd_layout
    .centerXIs(SCREENWIDTH / 2.0f)
    .topSpaceToView(self.lineView, MarginFactor(13.0f))
    .widthIs(0.5f)
    .heightIs(MarginFactor(24.0f));
    
    self.sendMessageButton.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.centerLine, 1.0f)
    .topSpaceToView(self.lineView, 0.0f)
    .heightIs(MarginFactor(50.0f));
    
    
    self.collectButton.sd_layout
    .leftSpaceToView(self.centerLine, 1.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topEqualToView(self.sendMessageButton)
    .heightIs(MarginFactor(50.0f));

    self.grayView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.sendMessageButton, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    [self.headerView setupAutoHeightWithBottomView:self.grayView bottomMargin:0.0f];
    self.tableView.tableHeaderView = self.headerView;
    
}
- (void)tapHeaderView:(UITapGestureRecognizer *)recognizer
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    browser.imageCount = 1;
    browser.currentImageIndex = recognizer.view.tag;
    browser.delegate = self;
    [browser show];
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"]) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showWait];
    WEAK(self, weakSelf);
    NSDictionary *param = @{@"uid":uid, @"target":target, @"rid":time, @"num":@(10)};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"queryCircleById",self.userId] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"=========data = %@",response.dataDictionary);
        [weakSelf parseDataWithDic:response.dataDictionary];
        [weakSelf loadData];
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
        NSLog(@"%@",response.errorMessage);

    }];
}

- (void)loadData
{
    [self.headerImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.potName]] placeholder:[UIImage imageNamed:@"default_head"]];
    BOOL userStatus = [self.userStatus boolValue];
    [self.authenticationView updateWithStatus:userStatus];
    if (self.department.length > 6) {
        NSString * str = [self.department substringToIndex:6];
        self.departmentLabel.text = [NSString stringWithFormat:@"%@...",str];
    } else {
        self.departmentLabel.text = self.department;
    }
    [self.departmentLabel sizeToFit];
    self.companyLabel.text = self.companyName;
    [self.companyLabel sizeToFit];
    NSString *name = [self.nickName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.userNameLabel.text = name;
    [self.userNameLabel sizeToFit];
  
    if ([self.friendShip isEqualToString:@"一度"]) {
        self.friendImage.image = [UIImage imageNamed:@"first_friend.png"];
    }
    if ([self.friendShip isEqualToString:@"二度"])
    {
        self.friendImage.image = [UIImage imageNamed:@"second_friend.png"];
    }
    if ([self.friendShip isEqualToString:@""] || self.userType == SHGUserTypeBusinessAccount) {
        self.friendImage.image = nil;
    }

    if ([self.userId isEqualToString:UID]) {
        self.listArray = [NSMutableArray arrayWithArray:@[@"我的动态", @"我的好友"]];
        self.friendImage.hidden = YES;
        self.lineView.hidden = YES;
        self.centerLine.hidden = YES;
        self.sendMessageButton.hidden = YES;
        self.collectButton.hidden = YES;
        self.grayView.sd_resetLayout
        .leftSpaceToView(self.headerView, 0.0f)
        .rightSpaceToView(self.headerView, 0.0f)
        .topSpaceToView(self.headerImageView, MarginFactor(15.0f))
        .heightIs(MarginFactor(10.0f));
    } else{
        self.lineView.hidden = NO;
        self.centerLine.hidden = NO;
        self.friendImage.hidden = NO;
        self.sendMessageButton.hidden = NO;
        self.collectButton.hidden = NO;
        self.grayView.sd_resetLayout
        .leftSpaceToView(self.headerView, 0.0f)
        .rightSpaceToView(self.headerView, 0.0f)
        .topSpaceToView(self.sendMessageButton, 0.0f)
        .heightIs(MarginFactor(10.0f));
        if ([self.commonfriends intValue] == 0) {
            self.listArray = [NSMutableArray arrayWithArray:@[@"TA的业务",@"TA的动态", @"TA的好友"]];
        } else{
            self.listArray = [NSMutableArray arrayWithArray:@[@"TA的业务",@"TA的动态", @"TA的好友", @"共同好友"]];
       }
        
    }
    
    if (self.userType == SHGUserTypeBusinessAccount) {
        self.listArray = [NSMutableArray arrayWithArray:@[@"TA的动态"]];
    }

    [self refreshFriendShip];
    [self refreshCollection];

    [self.headerView layoutSubviews];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)refreshFriendShip
{
    if ([self.relationShip integerValue] == 0){
        //未关注
        [self.sendMessageButton setTitle:@"+关注" forState:UIControlStateNormal];
        [self.sendMessageButton setTitleColor:[UIColor colorWithHexString:@"F7514A"] forState:UIControlStateNormal];
       
    } else if ([self.relationShip intValue] == 1){
        //已关注
        [self.sendMessageButton setTitle:@"发消息" forState:UIControlStateNormal];
        [self.sendMessageButton setTitleColor:[UIColor colorWithHexString:@"919291"] forState:UIControlStateNormal];
    } else{
        //互相关注
        [self.sendMessageButton setTitle:@"发消息" forState:UIControlStateNormal];
        [self.sendMessageButton setTitleColor:[UIColor colorWithHexString:@"1D5798"] forState:UIControlStateNormal];
    }

}
-(void)refreshCollection
{
    if (self.isCollected) {
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectButton setTitleColor:[UIColor colorWithHexString:@"1D5798"] forState:UIControlStateNormal];
    } else{
        [self.collectButton setTitle:@"收藏名片" forState:UIControlStateNormal];
        [self.collectButton setTitleColor:[UIColor colorWithHexString:@"1D5798"] forState:UIControlStateNormal];
    }
 
}
- (void)parseDataWithDic:(NSDictionary *)dictionary
{
    self.companyName = [dictionary objectForKey: @"company"];
    self.nickName = [dictionary objectForKey: @"nickname"];
    self.potName = [dictionary objectForKey: @"potname"];
    self.relationShip = [dictionary objectForKey: @"rela"];
    self.department = [dictionary objectForKey: @"title"];
    self.userStatus = [dictionary objectForKey:@"userstatus"];
    self.businessStatus = [[dictionary objectForKey:@"businessstatus"] boolValue];
    self.position = [dictionary objectForKey:@"position"];
    self.tags = [dictionary objectForKey:@"tags"];
    self.friendShip = [dictionary objectForKey:@"friendship"];
    if ([[dictionary objectForKey:@"iscollected"] isEqualToString:@"true"]) {
        self.isCollected = YES;
    } else{
        self.isCollected = NO;
    }
    self.businessTotal = [NSString stringWithFormat:@"%@条",[dictionary objectForKey:@"businesstotal"]];
    self.dynamicNumber = [NSString stringWithFormat:@"%@条",[dictionary objectForKey: @"num"]];
    self.friendNumber = [NSString stringWithFormat:@"%@人",[dictionary objectForKey:@"friends"]];
    self.commonfriends = [NSString stringWithFormat:@"%@人",[dictionary objectForKey:@"commonfriends"]];
    NSString *usertype = [dictionary objectForKey:@"usertype"];
    if([usertype rangeOfString:@"vest"].location != NSNotFound){
        self.userType = SHGUserTypeVest;
    } else if ([usertype rangeOfString:@"register"].location != NSNotFound){
        self.userType = SHGUserTypeRegister;
    } else if ([usertype rangeOfString:@"operator"].location != NSNotFound){
        self.userType = SHGUserTypeOperator;
    } else if ([usertype rangeOfString:@"businessAccount"].location != NSNotFound){
        self.userType = SHGUserTypeBusinessAccount;
    } else{
        self.userType = SHGUserTypeOther;
    }

    NSArray *listArray = [dictionary objectForKey: @"list"];
    listArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:listArray class:[CircleListObj class]];
    self.dataArr = [NSMutableArray arrayWithArray:listArray];

}
- (IBAction)sendMessageButtonClick:(UIButton *)sender
{
    if ([self.relationShip integerValue] == 0) {
        CircleListObj *object = [[CircleListObj alloc] init];
        object.userid = self.userId;
        object.isAttention = NO;
        [SHGGlobleOperation addAttation:object];
    } else if ([self.relationShip integerValue] == 1){
        [Hud hideHud];
        [Hud showMessageWithText:@"您与对方还不是好友,对方关注您后\n可进行对话"];
    } else{
        [self chat];
    }

}

- (void)chat
{
    [[SHGGloble sharedGloble] recordUserAction:self.userId type:@"imChat"];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.userId isGroup:NO];
    chatVC.title = self.nickName;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)collectButtonClick:(UIButton *)sender
{
    if (self.isCollected) {
        [self deleteCollected];
    } else{
        [self addCollected];
    }

}

-(void)addCollected
{
    WEAK(self, weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"userCard",@"collect"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"beCollectedId":self.userId};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            weakSelf.isCollected = !weakSelf.isCollected;
            weakSelf.isCardChange = YES;
            [weakSelf loadData];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];

}
-(void)deleteCollected
{
    WEAK(self, weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"userCard",@"cancleCollect"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"beCollectedId":self.userId};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            weakSelf.isCollected = !weakSelf.isCollected;
            weakSelf.isCardChange = NO;
            [weakSelf loadData];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];

}
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.userId isEqualToString:@"-2"] && ![UID isEqualToString:@"-2"]){
        return 0;
    } else{
       return self.listArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(55.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SHGPersonalTableViewCell";
    SHGPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
    SHGPersonalMode *model = [[SHGPersonalMode alloc]init];
    NSMutableArray *mutableCountArray = [[NSMutableArray alloc] init];
    if (![self.userId isEqualToString:UID])
    {
        if (self.userType == SHGUserTypeBusinessAccount) {
            [mutableCountArray addObjectsFromArray:@[self.dynamicNumber]];
        } else{
            [mutableCountArray addObjectsFromArray:@[self.businessTotal,self.dynamicNumber,self.friendNumber,self.commonfriends]];
        }
        
    } else{
        [mutableCountArray addObjectsFromArray:@[self.dynamicNumber,self.friendNumber]];
    }
    model.name = [self.listArray objectAtIndex:indexPath.row];
    model.count = [mutableCountArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [self.listArray objectAtIndex:indexPath.row];
    if ([model isEqualToString:@"我的动态"]) {
        SHGPersonDynamicViewController *controller = [[SHGPersonDynamicViewController alloc] initWithNibName:@"SHGPersonDynamicViewController" bundle:nil];
        controller.userId = self.userId;
        controller.delegate = self.delegate;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([model isEqualToString:@"我的好友"]){
        SHGPersonFriendsViewController *vc = [[SHGPersonFriendsViewController alloc] init];
        vc.userId = self.userId;
        [vc friendStatus:@"me"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model isEqualToString:@"TA的动态"]){
        SHGPersonDynamicViewController *controller = [[SHGPersonDynamicViewController alloc] initWithNibName:@"SHGPersonDynamicViewController" bundle:nil];
        controller.userId = self.userId;
        controller.delegate = self.delegate;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([model isEqualToString:@"TA的业务"]){
        SHGBusinessMineViewController *controller = [[SHGBusinessMineViewController alloc] init];
        controller.userId = self.userId;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([model isEqualToString:@"TA的好友"]){
        SHGPersonFriendsViewController *vc = [[SHGPersonFriendsViewController alloc] init];
        vc.userId = self.userId;
        [vc friendStatus:@"his"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model isEqualToString:@"共同好友"]){
        SHGPersonFriendsViewController *vc = [[SHGPersonFriendsViewController alloc] init];
        vc.userId = self.userId;
        [vc friendStatus:@"all"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark ------图片浏览器代理
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.headerImageView.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
