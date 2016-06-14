//
//  SettingsViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsObj.h"
#import "SettingsViewController.h"
#import "SettingModifyPWDViewController.h"
#import "SettingAboutUsViewController.h"
#import "LoginViewController.h"
#import "DingDQRCodeShareViewController.h"
#import "EaseMob.h"
#import "SettingsSuggestionsViewController.h"
#import "SHGSettingTableViewCell.h"

@interface SettingsViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) NSIndexPath *curIndexPath;

@property (nonatomic, weak) IBOutlet UISwitch *switchView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = Color(@"efeeef");
    self.bottomButton.titleLabel.font = FontFactor(17.0f);
    self.bottomButton.backgroundColor = Color(@"f04241");
    self.bottomButton.frame = CGRectMake(MarginFactor(12.0f), self.view.height - MarginFactor(19.0f) - MarginFactor(40.0f) , self.view.width - 2 * MarginFactor(12.0f), MarginFactor(40.0f));
    [self initArrContents];
    [self loadSwitchInfo];
    [self.bottomButton layoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingsViewController" label:@"onClick"];
}

- (void)initArrContents
{
    NSMutableArray *array0 = [NSMutableArray array];
    SettingsObj *obj00 = [[SettingsObj alloc] init];
    obj00.imageInfo = nil;
    obj00.isShowSwith = NO;
    obj00.content = @"个人信息";
    SettingsObj *obj01 = [[SettingsObj alloc] init];
    obj01.imageInfo = nil;
    obj01.isShowSwith = NO;
    obj01.content = @"密码修改";
    [array0 addObject:obj00];
    [array0 addObject:obj01];

    NSMutableArray *array1 = [NSMutableArray array];
    SettingsObj *obj10 = [[SettingsObj alloc] init];
    obj10.imageInfo = nil;
    obj10.isShowSwith = NO;
    obj10.content = @"更新版本";
    [array1 addObject:obj10];

    NSMutableArray *array2 = [NSMutableArray array];
    SettingsObj *obj20 = [[SettingsObj alloc] init];
    obj20.imageInfo = nil;
    obj20.isShowSwith = NO;
    obj20.content = @"清除缓存";
    SettingsObj *obj21 = [[SettingsObj alloc] init];
    obj21.imageInfo = nil;
    obj21.isShowSwith = YES;
    obj21.content = @"消息推送";
    [array2 addObject:obj20];
    [array2 addObject:obj21];

    NSMutableArray *array3 = [NSMutableArray array];
    SettingsObj *obj30 = [[SettingsObj alloc] init];
    obj30.imageInfo = nil;
    obj30.isShowSwith = NO;
    obj30.content = @"意见反馈";
    SettingsObj *obj31 = [[SettingsObj alloc] init];
    obj31.imageInfo = nil;
    obj31.isShowSwith = NO;
    obj31.content = @"关于我们";
    [array3 addObject:obj30];
    [array3 addObject:obj31];

    self.arrValues = @[array0, array2, array3];

    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] checkForUpdate:^(BOOL state) {
        if (state) {
            weakSelf.arrValues = @[array0, array1, array2, array3];
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrValues.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[self.arrValues objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = Color(@"efeeef");
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentity = @"SHGSettingTableViewCell";
    SHGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGSettingTableViewCell" owner:self options:nil] lastObject];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrowImage"]];
    SettingsObj *obj = [[self.arrValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.titleLabel.text = obj.content;

    if (indexPath.row == ((NSArray *)[self.arrValues objectAtIndex:indexPath.section]).count - 1) {
        cell.lineView.hidden = YES;
    } else{
        cell.lineView.hidden = NO;
    }
    
    if (![obj.content isEqualToString:@"更新版本"]) {
        cell.accessoryView.hidden = NO;
    } else{
        cell.accessoryView.hidden = YES;
    }
    
    if (obj.isShowSwith){
        cell.accessoryView = self.switchView;
    } else if ([obj.content isEqualToString:@"清除缓存"]){
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%0.1fM",[self folderSizeAtPath]];
        label.font = FontFactor(14.0f);
        label.textColor = [UIColor colorWithHexString:@"919291"];
        [label sizeToFit];
        cell.accessoryView = label;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(55.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return MarginFactor(11.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingsObj *object = [[self.arrValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([object.content isEqualToString:@"更新版本"]) {
        [[SHGGloble sharedGloble] checkForUpdate:nil];
        
    } else if ([object.content isEqualToString:@"密码修改"]){
        SettingModifyPWDViewController *detailVC = [[SettingModifyPWDViewController alloc] initWithNibName:@"SettingModifyPWDViewController" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];

    } else if ([object.content isEqualToString:@"清除缓存"]){
         [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_setting_clearCache"];
        SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"是否确认清除本地缓存？" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        __weak typeof(self) weakSelf = self;
        alert.rightBlock = ^{
            [Hud showWait];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [Hud hideHud];
                [Hud showMessageWithText:@"清除缓存成功"];
                [weakSelf.tableView reloadData];
            }];
        };
        [alert show];

    } else if([object.content isEqualToString:@"意见反馈"]){
        SettingsSuggestionsViewController *vc = [[SettingsSuggestionsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    } else if([object.content isEqualToString:@"关于我们"]){
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_setting_aboutUs"];
        SettingAboutUsViewController *detailVC = [[SettingAboutUsViewController alloc] initWithNibName:@"SettingAboutUsViewController" bundle:nil];
        [self.navigationController pushViewController:detailVC animated:YES];

    } else if([object.content isEqualToString:@"个人信息"]){
        SHGModifyUserInfoViewController *controller = [[SHGModifyUserInfoViewController alloc] init];
        controller.userInfo = self.userInfo;
        __weak typeof(self)weakSelf = self;
        controller.block = ^(NSDictionary *info){
            weakSelf.userInfo = info;
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)logout:(id)sender
{
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"user_setting_exit"];
    //注销登录
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"是否退出该账号?" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.rightBlock = ^{
        [self performSelector:@selector(initUserInfo) withObject:nil afterDelay:0.25];
    };
    [alert show];
    
}

- (void)initUserInfo
{
    [Hud showWait];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        [Hud hideHud];
        if (error && error.errorCode != EMErrorServerNotLogin){
            [Hud showMessageWithText:@"网络异常，请重新操作"];
        } else{
            LoginViewController *splitViewController =[[[LoginViewController alloc] init] initWithNibName:@"LoginViewController" bundle:nil];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:splitViewController];
            //设置导航title字体
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize], NSForegroundColorAttributeName:NavRTitleColor}];
            //清楚配置信息
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_UID];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_PASSWORD];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_AREA];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTOLOGIN];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //退出shareSDK的登录

            [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            [ShareSDK cancelAuthorize:SSDKPlatformSubTypeQZone];

            [AppDelegate currentAppdelegate].window.rootViewController = nav;

        }
    } onQueue:dispatch_get_main_queue()];
}

- (void)loadSwitchInfo
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@%@",rBaseAddressForHttp,@"/pushApp/getPushSwitch"] parameters:@{@"uid":uid} success:^(MOCHTTPResponse *response) {
        if(response.dataArray && response.dataArray.count){
            NSString *pushflag = [[response.dataArray firstObject] objectForKey:@"pushflag"];
            [self.switchView setOn:[pushflag boolValue] animated:YES];
        }
    } failed:^(MOCHTTPResponse *response) {
        
        [self.switchView setOn:YES animated:YES];
    }];
}

- (IBAction)messageSwitch:(id)sender {
    if (self.switchView.isOn) {
        __weak typeof(self)weakSelf = self;
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
        NSString *pushFlag = @"1";
        [Hud showWait];
        [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"pushApp/pushSwitch"] parameters:@{@"uid":uid, @"pushFlag":pushFlag} success:^(MOCHTTPResponse *response) {
            [weakSelf.switchView setOn:YES animated:YES];
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [weakSelf.switchView setOn:NO animated:YES];
            [Hud hideHud];
            [Hud showMessageWithText:@"打开通知失败"];
        }];
    }else{
        __weak typeof(self)weakSelf = self;
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
        NSString *pushFlag = @"0";
        [Hud showWait];
        [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"pushApp/pushSwitch"] parameters:@{@"uid":uid, @"pushFlag":pushFlag} success:^(MOCHTTPResponse *response) {
            [weakSelf.switchView setOn:NO animated:YES];
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [weakSelf.switchView setOn:YES animated:YES];
            [Hud hideHud];
            [Hud showMessageWithText:@"关闭通知失败"];
        }];
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (CGFloat) folderSizeAtPath{
    CGFloat cacheSize = [[SDImageCache sharedImageCache] getSize] / (1024.0f * 1024.0f);
    return cacheSize;
}
@end
