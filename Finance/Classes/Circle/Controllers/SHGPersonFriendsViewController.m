//
//  SHGPersonFriendsViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/22.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGPersonFriendsViewController.h"
#import "BasePeopleObject.h"
#import "HeadImage.h"
#import "SHGUserTagModel.h"
#import "SHGPersonFriendsTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGEmptyDataView.h"

@interface SHGPersonFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic)NSInteger  pageNum;
@property (strong,nonatomic)NSString *   friend_status;
@property (strong, nonatomic) NSMutableArray    *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableViewCell *emptyCell;
@property (strong, nonatomic) SHGEmptyDataView *emptyView;

@end

@implementation SHGPersonFriendsViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.pageNum = 1;
    [self requestContact];
}

- (void)friendStatus:(NSString *)status
{
    self.friend_status = status;
}

- (NSMutableArray *)dataSource
{
    if ((!_dataSource)) {
        self.dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}
- (NSMutableArray *)contactsSource
{
    if ((!_contactsSource)) {
        self.contactsSource = [NSMutableArray array];
        
    }
    return _contactsSource;
}


-(void)requestContact
{
    [Hud showWait];
    
    if ([self.friend_status isEqualToString:@"me"]) {
        self.title = @"我的好友";
        NSString * uid = self.userId;
        NSDictionary *param = @{@"uid":uid,
                                @"pagenum":[NSNumber numberWithInteger:self.pageNum],                          @"pagesize":@15};
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"friends",@"getHisFriends"];
        [MOCHTTPRequestOperationManager postWithURL:url class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            if(response.dataArray.count>0){
                if (self.pageNum == 1) {
                    [self.contactsSource removeAllObjects];
                }
            }
            for (int i = 0; i<response.dataArray.count; i++)
            {
                NSDictionary *dic = response.dataArray[i];
                BasePeopleObject *obj = [[BasePeopleObject alloc] init];
                obj.name = [dic valueForKey:@"nick"];
                obj.headImageUrl = [dic valueForKey:@"avatar"];
                obj.uid = [dic valueForKey:@"username"];
                obj.company = [dic valueForKey:@"company"];
                obj.userstatus = [dic valueForKey:@"userstatus"];
                [self.contactsSource addObject:obj];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [HeadImage inertWithArr:self.contactsSource];
            });
            [self.tableView reloadData];
            [Hud hideHud];
            
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }else if ([self.friend_status isEqualToString:@"his"]) {
        self.title = @"TA的好友";
        NSString * uid = self.userId;
        NSDictionary *param = @{@"uid":uid,
                                @"pagenum":[NSNumber numberWithInteger:self.pageNum], @"pagesize":@15};
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"friends",@"getHisFriends"];
        [MOCHTTPRequestOperationManager postWithURL:url class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            if(response.dataArray.count>0){
                if (self.pageNum == 1) {
                    [self.contactsSource removeAllObjects];
                }
            }
            for (int i = 0; i<response.dataArray.count; i++)
            {
                NSDictionary *dic = response.dataArray[i];
                BasePeopleObject *obj = [[BasePeopleObject alloc] init];
                obj.name = [dic valueForKey:@"nick"];
                obj.headImageUrl = [dic valueForKey:@"avatar"];
                obj.uid = [dic valueForKey:@"username"];
                obj.company = [dic valueForKey:@"company"];
                obj.userstatus = [dic valueForKey:@"userstatus"];
                [self.contactsSource addObject:obj];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [HeadImage inertWithArr:self.contactsSource];
            });
            [self.tableView reloadData];
            [Hud hideHud];
            
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];

    }else if([self.friend_status isEqualToString:@"all"])
    {     self.title = @"共同好友";
         NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"friends",@"getCommonFriends"];
         NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"ownerId":self.userId};
        [MOCHTTPRequestOperationManager postWithURL:url class:[BasePeopleObject class] parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            if(response.dataArray.count>0){
                if (self.pageNum == 1) {
                    [self.contactsSource removeAllObjects];
                }
            }
            for (int i = 0; i<response.dataArray.count; i++)
            {
                NSDictionary *dic = response.dataArray[i];
                BasePeopleObject *obj = [[BasePeopleObject alloc] init];
                obj.name = [dic valueForKey:@"nick"];
                obj.headImageUrl = [dic valueForKey:@"avatar"];
                obj.uid = [dic valueForKey:@"username"];
                obj.company = [dic valueForKey:@"company"];
                obj.userstatus = [dic valueForKey:@"userstatus"];
                [self.contactsSource addObject:obj];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [HeadImage inertWithArr:self.contactsSource];
            });
            [self.tableView reloadData];
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];

    }
    
}

- (UITableViewCell *)emptyCell
{
    if (!_emptyCell) {
        _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_emptyCell.contentView addSubview:self.emptyView];
    }
    return _emptyCell;
}


- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _emptyView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.contactsSource.count > 0) {
         return self.contactsSource.count;
    } else{
        return 1;
    }
   
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contactsSource.count > 0) {
        BasePeopleObject * obj = self.contactsSource[indexPath.row];
        NSString *cellIdentifier = @"SHGPersonFriendsTableViewCell";
        SHGPersonFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGPersonFriendsTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.obj = obj;
        return cell;
    } else{
        return self.emptyCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contactsSource.count > 0) {
        BasePeopleObject * obj = self.contactsSource[indexPath.row];
        SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init];
        vc.userId = obj.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contactsSource.count > 0) {
         return MarginFactor(60.0f);
    } else{
        return CGRectGetHeight(self.view.frame);
    }
   
    
}

@end
