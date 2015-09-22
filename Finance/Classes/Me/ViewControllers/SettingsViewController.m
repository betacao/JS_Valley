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
#import "BPush.h"
#import "DingDQRCodeShareViewController.h"
#import "EaseMob.h"
#import "SettingsSuggestionsViewController.h"

@interface SettingsViewController ()
<UIAlertViewDelegate>
{
    BOOL  hasUpdatedContacts;
}
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, strong) NSDictionary *arrValues;
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
    // Do any additional setup after loading the view from its nib.
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
-(void)uploadContact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAddress];
    });
    
}
-(NSMutableArray *)phones
{
    if (!_phones) {
        _phones = [NSMutableArray array];
    }
    return _phones;
}
#pragma mark -- sdc
#pragma mark -- 获得通讯录
-(void )getAddress
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABAddressBookRequestAccessWithCompletion
    (addressBook, ^(bool granted, CFErrorRef error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error)
                 NSLog(@"Error: %@", (__bridge NSError *)error);
             else if (!granted)
             {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"获取权限失败" message:@"请设置权限." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [av show];
             }
             else
             {
                 CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
                 
                 for(int i = 0; i < CFArrayGetCount(results); i++)
                 {
                     ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                     ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                     for (int k = 0; k<ABMultiValueGetCount(phone); k++)
                     {
                         //获取該Label下的电话值
                         NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                         NSString *phone = [personPhone validPhone];
                         NSString *personNameFirst = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                         NSString *personNameLast = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                         NSString *personNameCompany = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                         NSLog(@"%@=======%@=====%@",personNameFirst,personNameLast,personNameCompany);
                         NSString *personName = @"";
                         
                         if (!IsStrEmpty(personNameLast))
                         {
                             personName =[NSString stringWithFormat:@"%@",personNameLast];
                             
                         }
                         if (!IsStrEmpty(personNameFirst)){
                             personName =[NSString stringWithFormat:@"%@%@",personNameLast,personNameFirst];
                         }
                         
                         NSString *text = [NSString stringWithFormat:@"%@#%@",personName,phone];
                         NSLog(@"%@",text);
                         BOOL hasExsis = NO;
                         NSInteger index = 0;
                         for (int i = 0 ; i < self.phones.count; i ++)
                         {
                             NSString *phoneStr = self.phones[i];
                             if ([phoneStr hasSuffix:phone]) {
                                 hasExsis = YES;
                                 index = i;
                                 break;
                             }
                         }
                         if ([phone isValidateMobile])
                         {
                             if (hasExsis)
                             {
                                 [self.phones replaceObjectAtIndex:index withObject:text];
                             }
                             else
                             {
                                 [self.phones addObject:text];
                             }
                         }
                     }
                 }
                 if (!IsArrEmpty(self.phones))
                 {
                     
                     [self uploadPhonesWithPhone:self.phones];
                 }
             }
         });
     });
}

-(void)uploadPhonesWithPhone:(NSMutableArray *)phones
{
    
    NSInteger num = phones.count/100+1;
    for (int i = 1; i <= num; i ++ )
    {
        NSMutableArray *arr = [NSMutableArray array];
        
        NSInteger count = 0;
        if (phones.count > i * 100)
        {
            count =  i *100;
            
        }
        else
        {
            count = (i-1) *100 +phones.count % 100;
        }
        
        for (int j = (i -1)*100; j < count; j ++)
        {
            
            [arr addObject:phones[j]];
        }
        if (!IsArrEmpty(arr)) {
            [self uploadPhone:arr];
            NSLog(@"-----------%@",arr);
        }
        
        
    }
    
}
-(void)uploadPhone:(NSMutableArray *)arr
{
    NSString *str = arr[0];
    for (int i = 1 ; i < arr.count; i ++) {
        str = [NSString stringWithFormat:@"%@,%@",str,arr[i]];
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/contact"];
    //向服务器发请求
    NSLog(@"=========%@",str);
    NSDictionary *parm = @{@"phones":str,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response){
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [MobClick event:@"ActionUpdatedContacts" label:@"onClick"];
        }
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}
- (void)initArrContents
{
    self.arrTitles=@[@"偏好设置",@"关于我们"];
    
    NSMutableArray *twoArray = [NSMutableArray array];
    
    SettingsObj *obj0 = [[SettingsObj alloc] init];
    obj0.imageInfo = @"通讯录更新";
    obj0.isShowSwith = @"NO";
    obj0.content = @"更新好友";
    [twoArray addObject:obj0];
    
    SettingsObj *obj1 = [[SettingsObj alloc] init];
    obj1.imageInfo = @"settings_change_password";
    obj1.isShowSwith = @"NO";
    obj1.content = @"密码修改";
    [twoArray addObject:obj1];
    
    SettingsObj *obj3 = [[SettingsObj alloc] init];
    obj3.imageInfo = @"tag_level.png";
    obj3.isShowSwith = @"NO";
    obj3.content = @"检查更新";
    // [twoArray addObject:obj3];
    
    SettingsObj *obj2 = [[SettingsObj alloc] init];
    obj2.imageInfo = @"setting_clear_cache";
    obj2.isShowSwith = @"NO";
    obj2.content = @"清除缓存";
    [twoArray addObject:obj2];
    
    SettingsObj *obj7 = [[SettingsObj alloc] init];
    obj7.imageInfo = @"settings_message_push";
    obj7.isShowSwith = @"YES";
    obj7.isOn = @"YES";
    obj7.content = @"消息推送";
    [twoArray addObject:obj7];
    
    SettingsObj *obj10 = [[SettingsObj alloc] init];
    obj10.imageInfo = @"settings_message_setting";
    obj10.isShowSwith = @"NO";;
    obj10.content = @"对话设置";
    //	[twoArray addObject:obj10];
    
    NSMutableArray *threeArray = [NSMutableArray array];
    
//    SettingsObj *obj4 = [[SettingsObj alloc] init];
//    obj4.imageInfo = @"settings_normal_question";
//    obj4.isShowSwith = @"NO";
//    obj4.content = @"常见问题";
//    [threeArray addObject:obj4];
    
    SettingsObj *obj5 = [[SettingsObj alloc] init];
    obj5.imageInfo = @"settings_suggestions";
    obj5.isShowSwith = @"NO";
    obj5.content = @"意见反馈";
    [threeArray addObject:obj5];
    
    SettingsObj *obj6 = [[SettingsObj alloc] init];
    obj6.imageInfo = @"settings_about_us";
    obj6.isShowSwith = @"NO";
    obj6.content = @"关于我们";
    [threeArray addObject:obj6];
    
    self.arrValues = @{@"偏好设置": twoArray,@"关于我们": threeArray};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrTitles count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_arrValues objectForKey:[_arrTitles objectAtIndex:section]] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    sectionView.backgroundColor = RGB(240, 240, 240);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 300, 50)];
    label.text = [_arrTitles objectAtIndex:section];;
    label.font = [UIFont fontWithName:@"Palatino" size:17];
    label.textColor = TEXT_COLOR;
    [sectionView addSubview:label];
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentity = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
    }
    
    SettingsObj *obj = [(NSArray *)[_arrValues objectForKey:[_arrTitles objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = obj.content;
    cell.imageView.image = [UIImage imageNamed:obj.imageInfo];
    if (indexPath.row == 3 && indexPath.section == 0){
        cell.accessoryView =self.switchView;
    } else if (indexPath.row == 2 && indexPath.section == 0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, cell.height)];
        NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageCache = [cache stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%0.1fM",[self folderSizeAtPath:imageCache]];
        cell.accessoryView =  label;
    } else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)changeUpdateState
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

                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"是否确认清除本地缓存" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                __weak typeof(self) weakSelf = self;
                alert.rightBlock = ^{
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [weakSelf.tableView reloadData];
                    }];
                    
                };
                [alert show];
            } else if(indexPath.row==3){
                
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
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
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

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}
@end
