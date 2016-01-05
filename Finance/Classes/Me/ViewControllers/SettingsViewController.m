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
#import "SettingQuestionViewController.h"
#import "SettingModifyPWDViewController.h"
#import "SettingAboutUsViewController.h"
#import "LoginViewController.h"
#import "DingDQRCodeShareViewController.h"
#import "EaseMob.h"
#import "SettingsSuggestionsViewController.h"
#import "SHGSettingTableViewCell.h"

@interface SettingsViewController ()
<UIAlertViewDelegate>
{
    BOOL  hasUpdatedContacts;
}
@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) NSIndexPath *curIndexPath;

@property (nonatomic, weak) IBOutlet UISwitch *switchView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *footerView;

- (IBAction)logout:(id)sender;
- (IBAction)messageSwitch:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArrContents];
    [self loadSwitchInfo];
    self.title = @"设置";
    
    self.tableView.tableFooterView = self.footerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingsViewController" label:@"onClick"];
}

- (void)uploadContact
{
    [[SHGGloble sharedGloble] getUserAddressList:^(BOOL finished) {
        if(finished){
            [[SHGGloble sharedGloble] uploadPhonesWithPhone:^(BOOL finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(finished){
                        [Hud showMessageWithText:@"通讯录更新成功"];
                    } else{
                        [Hud showMessageWithText:@"上传通讯录列表失败"];
                    }
                });
            }];
        } else{
            [Hud showLoadingWithMessage:@"获取通讯录列表失败，请到系统设置设置权限"];
        }
    }];
}



- (void)initArrContents
{
    
//    SettingsObj *obj0 = [[SettingsObj alloc] init];
//    obj0.imageInfo = @"通讯录更新";
//    obj0.isShowSwith = @"NO";
//    obj0.content = @"更新好友";
//    [twoArray addObject:obj0];
//    
//    SettingsObj *obj1 = [[SettingsObj alloc] init];
//    obj1.imageInfo = @"settings_change_password";
//    obj1.isShowSwith = @"NO";
//    obj1.content = @"密码修改";
//    [twoArray addObject:obj1];
//    
//    SettingsObj *obj3 = [[SettingsObj alloc] init];
//    obj3.imageInfo = @"tag_level.png";
//    obj3.isShowSwith = @"NO";
//    obj3.content = @"检查更新";
//    
//    SettingsObj *obj2 = [[SettingsObj alloc] init];
//    obj2.imageInfo = @"setting_clear_cache";
//    obj2.isShowSwith = @"NO";
//    obj2.content = @"清除缓存";
//    [twoArray addObject:obj2];
//    
//    SettingsObj *obj7 = [[SettingsObj alloc] init];
//    obj7.imageInfo = @"settings_message_push";
//    obj7.isShowSwith = @"YES";
//    obj7.isOn = @"YES";
//    obj7.content = @"消息推送";
//    [twoArray addObject:obj7];
//    
//    SettingsObj *obj10 = [[SettingsObj alloc] init];
//    obj10.imageInfo = @"settings_message_setting";
//    obj10.isShowSwith = @"NO";;
//    obj10.content = @"对话设置";
//    
//    NSMutableArray *threeArray = [NSMutableArray array];
//
//    
//    SettingsObj *obj5 = [[SettingsObj alloc] init];
//    obj5.imageInfo = @"settings_suggestions";
//    obj5.isShowSwith = @"NO";
//    obj5.content = @"意见反馈";
//    [threeArray addObject:obj5];
//    
//    SettingsObj *obj6 = [[SettingsObj alloc] init];
//    obj6.imageInfo = @"settings_about_us";
//    obj6.isShowSwith = @"NO";
//    obj6.content = @"关于我们";
//    [threeArray addObject:obj6];


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
    obj10.content = @"更新好友";
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

    self.arrValues = @[array0, array1, array2, array3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    sectionView.backgroundColor = RGB(240, 240, 240);
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentity = @"SHGSettingTableViewCell";
    SHGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGSettingTableViewCell" owner:self options:nil] lastObject];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"161616"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    SettingsObj *obj = [[self.arrValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.content;
    cell.imageView.image = [UIImage imageNamed:obj.imageInfo];
    cell.rightArrowView.hidden = NO;
    cell.rightView.hidden = YES;

    if (indexPath.row == ((NSArray *)[self.arrValues objectAtIndex:indexPath.section]).count - 1) {
        cell.lineView.hidden = YES;
    } else{
        cell.lineView.hidden = NO;
    }
    if (obj.isShowSwith){
        [cell.rightView removeAllSubviews];
        [cell.rightView addSubview:self.switchView];
        CGRect frame = self.switchView.frame;
        frame.origin.x = (cell.rightView.width - CGRectGetWidth(frame)) / 2.0f;
        frame.origin.y = (cell.rightView.height - CGRectGetHeight(frame)) / 2.0f;
        self.switchView.frame = frame;
        cell.rightArrowView.hidden = YES;
        cell.rightView.hidden = NO;
    } else if ([obj.content isEqualToString:@"清除缓存"]){
        [cell.rightView removeAllSubviews];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%0.1fM",[self folderSizeAtPath]];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithHexString:@"919291"];
        [label sizeToFit];
        label.frame = cell.rightView.bounds;
        [cell.rightView addSubview:label];
        cell.rightArrowView.hidden = YES;
        cell.rightView.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 10.0f;
}

- (void)changeUpdateState
{
    hasUpdatedContacts = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0){
                if (hasUpdatedContacts){
                    [Hud showMessageWithText:@"您刚刚更新过好友"];
                } else{
                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"更新好友将会更新您的一度人脉中的手机通讯录，确认要更新吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    __weak typeof(self) weakSelf = self;
                    alert.rightBlock = ^{
                        [weakSelf uploadContact];
                    };
                    alert.leftBlock = ^{
                        hasUpdatedContacts = NO;
                    };
                    [alert show];
                    hasUpdatedContacts = YES;
                    [self performSelector:@selector(changeUpdateState) withObject:nil afterDelay:60.0f];
                }
            }
            
            if(indexPath.row==1)//修改密码
            {
                SettingModifyPWDViewController *detailVC = [[SettingModifyPWDViewController alloc] initWithNibName:@"SettingModifyPWDViewController" bundle:nil];
                [self.navigationController pushViewController:detailVC animated:YES];
            } else if(indexPath.row==2){//清除缓存

                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否确认清除本地缓存？" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                __weak typeof(self) weakSelf = self;
                alert.rightBlock = ^{
                    [Hud showLoadingWithMessage:@"正在清除缓存..."];
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [Hud hideHud];
                        [Hud showMessageWithText:@"清除缓存成功"];
                        [weakSelf.tableView reloadData];
                    }];
                };
                [alert show];
            }
        }
            break;
        case 1:
        {
            if(indexPath.row==2)//常见问题(1.4.1版本去掉该功能)
            {
                SettingQuestionViewController *detailVC = [[SettingQuestionViewController alloc] initWithNibName:@"SettingQuestionViewController" bundle:nil];
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }else if(indexPath.row==0)//问题反馈
            {
                SettingsSuggestionsViewController *vc = [[SettingsSuggestionsViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if(indexPath.row==1)//关于我们
            {
                SettingAboutUsViewController *detailVC = [[SettingAboutUsViewController alloc] initWithNibName:@"SettingAboutUsViewController" bundle:nil];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)logout:(id)sender
{
    //注销登录
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否退出该账号?" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.rightBlock = ^{
        [self performSelector:@selector(initUserInfo) withObject:nil afterDelay:0.25];
        
    };
    [alert show];
    
}

- (void)initUserInfo
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [Hud showLoadingWithMessage:@"正在注销"];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            [Hud hideHud];
            if (error && error.errorCode != EMErrorServerNotLogin){
            } else{
                LoginViewController *splitViewController =[[[LoginViewController alloc] init] initWithNibName:@"LoginViewController" bundle:nil];
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:splitViewController];
                //设置导航title字体
                [[UINavigationBar appearance] setTitleTextAttributes:
                 
                 @{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize],
                   
                   NSForegroundColorAttributeName:NavRTitleColor}];
                
                //清楚配置信息
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTOLOGIN];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //退出shareSDK的登录
                
                [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
                [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
                [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
                
                [AppDelegate currentAppdelegate].window.rootViewController = nav;
                
            }
        } onQueue:nil];
        
    }];
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
        [Hud showLoadingWithMessage:@"正在打开通知"];
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
        [Hud showLoadingWithMessage:@"正在关闭通知"];
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
