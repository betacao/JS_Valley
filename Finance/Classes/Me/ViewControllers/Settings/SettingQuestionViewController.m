//
//  SettingQuestionViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingQuestionViewController.h"
#import "SettingQuestionCell.h"
#import "SettingQuestionDetailViewController.h"

@interface SettingQuestionViewController ()
@property (atomic, strong) NSMutableArray *arrContents;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation SettingQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.view addSubview:self.tablevContent];
	
	
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"problem"] parameters:nil success:^(MOCHTTPResponse *response) {
	
		NSString *url = [response.dataDictionary objectForKey:@"value"];
		
//		[self.webView loadHTMLString:url baseURL:nil];
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
		
		NSLog(@"%@",response.data);
		NSLog(@"%@",response.errorMessage);
		
	} failed:^(MOCHTTPResponse *response) {
		
	}];

	
    self.arrContents = [NSMutableArray array];
    
    SettingQuestionObj *obj1 = [[SettingQuestionObj alloc] init];
    obj1.content = @"为什么推送消息我看不到";
    [self.arrContents addObject:obj1];
    
    SettingQuestionObj *obj2 = [[SettingQuestionObj alloc] init];
    obj2.content = @"密码忘记了怎么办";
    [self.arrContents addObject:obj2];
    
    SettingQuestionObj *obj3 = [[SettingQuestionObj alloc] init];
    obj3.content = @"社区活动中已报名的信息在哪里看到";
    [self.arrContents addObject:obj3];
    
    SettingQuestionObj *obj5 = [[SettingQuestionObj alloc] init];
    obj5.content = @"叮咚柜如何使用";
    [self.arrContents addObject:obj5];
    
    SettingQuestionObj *obj6 = [[SettingQuestionObj alloc] init];
    obj6.content = @"叮咚生活还有有其他服务项目么";
    [self.arrContents addObject:obj6];
    
    SettingQuestionObj *obj4 = [[SettingQuestionObj alloc] init];
    obj4.content = @"如何下载叮咚生活APP";
    [self.arrContents addObject:obj4];
    
    SettingQuestionObj *obj7 = [[SettingQuestionObj alloc] init];
    obj7.content = @"验证码遗失怎么办";
    [self.arrContents addObject:obj7];
    
    
    SettingQuestionObj *obj8 = [[SettingQuestionObj alloc]init];
    obj8.content = @"叮咚币如何使用";
    [self.arrContents addObject:obj8];
    
    SettingQuestionObj *obj9 = [[SettingQuestionObj alloc]init];
    obj9.content = @"免责声明";
    [self.arrContents addObject:obj9];
    
    UIButton *chat = [UIButton buttonWithType:UIButtonTypeCustom];
    [chat setFrame:CGRectMake(0, 0, 44, 44)];
    [chat setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingQuestionViewController" label:@"onClick"];
    self.title = @"常见问题";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentity = @"SettingQuestionCell";
    SettingQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingQuestionCell" owner:self options:nil] lastObject];
    }
    [cell reloadDatas:[self.arrContents objectAtIndex:indexPath.row]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingQuestionDetailViewController *detailVC = [[SettingQuestionDetailViewController alloc] initWithNibName:@"SettingQuestionDetailViewController"
                                                                                        bundle:nil];
    detailVC.type=[indexPath row];
    SettingQuestionObj *obj=[self.arrContents objectAtIndex:[indexPath row]];
    detailVC.name=obj.content;
    [self.navigationController pushViewController:detailVC animated:YES];

}

@end
