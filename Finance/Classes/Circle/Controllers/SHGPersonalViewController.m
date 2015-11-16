//
//  SHGPersonalViewController.m
//  Finance
//
//  Created by changxicao on 15/11/11.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonalViewController.h"
#import "SHGUserTagModel.h"
#import "SHGPersonDynamicViewController.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"

#define kTagViewWidth 45.0f * XFACTOR
#define kTagViewHeight 16.0f * XFACTOR

typedef NS_ENUM(NSInteger, SHGUserType) {
    //马甲号类型
    SHGUserTypeVest = 0,
    //真实用户
    SHGUserTypeRegister = 1,
    //管理员(类似大牛圈)
    SHGUserTypeOperator = 2,
    //其他
    SHGUserTypeOther
};


@interface SHGPersonalViewController ()<UITableViewDataSource, UITableViewDelegate, CircleActionDelegate>
//界面
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *tagViews;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImageView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//数据
@property (strong, nonatomic) NSString *department;//职称
@property (strong, nonatomic) NSString *relationShip;
@property (strong, nonatomic) NSString *potName;
@property (strong, nonatomic) NSString *dynamicNumber;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *userStatus;
@property (strong, nonatomic) NSString *friendNumber;
@property (assign, nonatomic) SHGUserType userType;

@end

@implementation SHGPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人动态";
    if ([self.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
        self.listArray = [NSMutableArray arrayWithArray:@[@"我的动态", @"我的好友"]];
        self.footerView.hidden = YES;
    } else{
        self.listArray = [NSMutableArray arrayWithArray:@[@"他的动态", @"他的好友", @"共同好友"]];
    }

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self initView];

    [self requestDataWithTarget:@"first" time:@""];
}

- (void)initView
{
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = CGRectGetHeight(self.headerImageView.frame) / 2.0f;
}

- (void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"]) {
        [self.tableView.footer resetNoMoreData];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];

    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"uid":uid, @"target":target, @"rid":[NSNumber numberWithInt:[time intValue]], @"num":rRequestNum};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,actioncircle,self.userId] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"=data = %@",response.dataDictionary);
        [weakSelf parseDataWithDic:response.dataDictionary];
        [weakSelf loadUI];
        [weakSelf.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
        NSLog(@"%@",response.errorMessage);

    }];
}

- (void)loadUI
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.potName]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.departmentLabel.text = self.department;
    self.companyLabel.text = self.companyName;
    self.userNameLabel.text = self.nickName;
    [self.tagViews removeAllSubviews];
    [self.tagViews addSubview:[self viewForTags:@[@"银行", @"证券", @"二级市场"]]];
    [self refreshFriendShip];

}

- (void)refreshFriendShip
{
    if ([self.relationShip integerValue] == 0){         //未关注
        [self.leftButton setTitle:@"+关注" forState:UIControlStateNormal];
    } else if ([self.relationShip intValue] == 1){      //已关注
        [self.leftButton setTitle:@"已关注" forState:UIControlStateNormal];
    } else{
        //互相关注
        [self.leftButton setTitle:@"会话" forState:UIControlStateNormal];
    }

}
- (void)parseDataWithDic:(NSDictionary *)dictionary
{
    self.companyName = [dictionary objectForKey: @"company"];
    self.friendNumber = [NSString stringWithFormat:@"%@",[dictionary objectForKey: @"fans"]];
    self.nickName = [dictionary objectForKey: @"nickname"];
    self.dynamicNumber = [dictionary objectForKey: @"num"];
    self.potName = [dictionary objectForKey: @"potname"];
    self.relationShip = [dictionary objectForKey: @"rela"];
    self.department = [dictionary objectForKey: @"title"];
    self.userStatus = [dictionary objectForKey:@"userstatus"];
    NSString *usertype = [dictionary objectForKey:@"usertype"];
    if([usertype rangeOfString:@"vest"].location != NSNotFound){
        self.userType = SHGUserTypeVest;
    } else if ([usertype rangeOfString:@"register"].location != NSNotFound){
        self.userType = SHGUserTypeRegister;
    } else if ([usertype rangeOfString:@"operator"].location != NSNotFound){
        self.userType = SHGUserTypeOperator;
    } else{
        self.userType = SHGUserTypeOther;
    }

    NSArray *listArray = [dictionary objectForKey: @"list"];
    listArray = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:listArray class:[CircleListObj class]];
    self.dataArr = [NSMutableArray arrayWithArray:listArray];

}

- (IBAction)leftButtonClick:(id)sender
{
    if ([self.relationShip integerValue] == 0) {
        [self action];
    } else if ([self.relationShip integerValue] == 1){
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您与对方还不是好友，对方关注您后可进行对话" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
    } else{
        [self chat];
    }
}

//关注
- (void)action
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"oid":self.userId};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            weakSelf.relationShip = [response.dataDictionary valueForKey:@"state"];
            for (CircleListObj *cobj in weakSelf.dataArr){
                if ([cobj.userid isEqualToString:weakSelf.userId]) {
                    cobj.isattention = @"Y";
                }
            }
            [self.delegate detailAttentionWithRid:weakSelf.userId attention:@"Y"];
            CircleListObj *cObj = [[CircleListObj alloc] init];
            cObj.userid = weakSelf.userId;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:cObj];
            [weakSelf loadUI];
            [weakSelf.tableView reloadData];

        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)chat{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.userId isGroup:NO];
    chatVC.title = self.nickName;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)rightButtonClick:(id)sender
{

}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"434343"];
    }

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textColor = [UIColor colorWithHexString:@"4b88b7"];
    switch (indexPath.row) {
        case 0:{
            label.text = [NSString stringWithFormat:@"%@条",self.dynamicNumber];
        }
            break;
        case 1:{
            label.text = [NSString stringWithFormat:@"%@人",self.friendNumber];
        }
            break;
        case 2:{
            label.text = [NSString stringWithFormat:@"%@人",self.friendNumber];
        }
            break;
        default:
            break;
    }
    [label sizeToFit];

    UIView *view = [[UIView alloc] init];
    [view addSubview:label];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessoryView"]];
    [imageView sizeToFit];
    [view addSubview:imageView];
    CGRect frame = imageView.frame;
    frame.origin.x = CGRectGetMaxX(label.frame) + kObjectMargin;
    imageView.frame = frame;

    frame = view.frame;
    frame.size.width = CGRectGetMaxX(imageView.frame);
    frame.size.height = MAX(CGRectGetMaxY(label.frame), CGRectGetMaxY(imageView.frame));
    view.frame = frame;

    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    cell.accessoryView = view;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            __weak typeof(self) weakSelf = self;
            SHGPersonDynamicViewController *controller = [[SHGPersonDynamicViewController alloc] initWithNibName:@"SHGPersonDynamicViewController" bundle:nil];
            controller.userId = self.userId;
            controller.dataArr = self.dataArr;
            controller.delegate = self.delegate;
            controller.block = ^(NSString *state){
                weakSelf.relationShip = state;
                [weakSelf refreshFriendShip];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:{
            ChatListViewController *vc = [[ChatListViewController alloc] init];
            vc.chatListType = ContactListView;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:{

        }
            break;
    }
}

- (UIView *)viewForTags:(NSArray *)array
{
    UIView *view = [[UIView alloc] init];
    for (NSString *model in array){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"f7514b"]];
        button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        CGRect frame = CGRectMake(0.0f, (CGRectGetHeight(self.tagViews.frame) - kTagViewHeight) / 2.0f, kTagViewWidth, kTagViewHeight);
        frame.origin.x = CGRectGetMaxX(view.frame) + kObjectMargin / 2.0f;
        button.frame = frame;
        frame = view.frame;
        frame.size.width = CGRectGetMaxX(button.frame);
        frame.size.height = CGRectGetMaxY(button.frame);
        view.frame = frame;
        [view addSubview:button];
    }
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
