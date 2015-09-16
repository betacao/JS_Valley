//
//  MyAppointmentViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "MyAppointmentTableViewCell.h"

@interface MyAppointmentViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	
	self.title = @"我的订单";
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	[_tableView setTableFooterView:view];

	self.dataSource = [[NSMutableArray alloc] init];
//	NSDictionary *dic1 = @{@"pname":@"定向增发",
//						  @"time":@"哈哈哈哈哈哈",
//						  @"ptype":@"股票配资",
//						  @"crate":@"国创高新",
//						  @"pstate":@"阿里的建安路口见大家都",
//						  @"term":@"3年",
//						  @"bline":@"3年",
//						  @"sname":@"3年",
//						  @"recordno":@"3年",
//						  @"holding":@"3年",
//						  @"sprice":@"3年",
//						  @"add":@"3年"};
//	[self.dataSource addObject:dic1];
//	NSDictionary *dic2 = @{@"pname":@"定向增发",
//						  @"time":@"哈哈哈哈哈哈",
//						  @"ptype":@"打新股",
//						  @"crate":@"国创高新",
//						  @"pstate":@"阿里的建安路口见大家都",
//						  @"term":@"3年",
//						  @"bline":@"3年",
//						  @"sname":@"3年",
//						  @"recordno":@"3年",
//						  @"holding":@"3年",
//						  @"sprice":@"3年",
//						  @"add":@"3年"};
//	[self.dataSource addObject:dic2];
//	NSDictionary *dic3 = @{@"pname":@"定向增发",
//						  @"time":@"哈哈哈哈哈哈",
//						  @"ptype":@"定向增发",
//						  @"crate":@"国创高新",
//						  @"pstate":@"阿里的建安路口见大家都",
//						  @"term":@"3年",
//						  @"bline":@"3年",
//						  @"sname":@"3年",
//						  @"recordno":@"3年",
//						  @"holding":@"3年",
//						  @"sprice":@"3年",
//						  @"add":@"3年"};
//	[self.dataSource addObject:dic3];
//	NSDictionary *dic4 = @{@"pname":@"定向增发",
//						  @"time":@"哈哈哈哈哈哈",
//						  @"ptype":@"新三板",
//						  @"crate":@"国创高新",
//						  @"pstate":@"阿里的建安路口见大家都",
//						  @"term":@"3年",
//						  @"bline":@"3年",
//						  @"sname":@"3年",
//						  @"recordno":@"3年",
//						  @"holding":@"3年",
//						  @"sprice":@"3年",
//						  @"add":@"3年"};
//	[self.dataSource addObject:dic4];
//

	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"orderlist"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
		
//		NSArray *array = [response.dataDictionary valueForKey:@"detail"];
		
		for (NSDictionary *dic in response.dataArray) {
//			NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//			
//			NSString *time = [dic valueForKey:@"time"];
//			if (!IsStrEmpty(time)) {
//				[dataDic setObject:time forKey:@"预约时间"];
//			}
//			NSString *pname = [dic valueForKey:@"pname"];
//			if (!IsStrEmpty(pname)) {
//				[dataDic setObject:pname forKey:@"产品名称"];
//			}
//			NSString *ptype = [dic valueForKey:@"ptype"];
//			if (!IsStrEmpty(ptype)) {
//				[dataDic setObject:ptype forKey:@"产品类型"];
//			}
//			NSString *crate = [dic valueForKey:@"crate"];
//			if (!IsStrEmpty(crate)) {
//				[dataDic setObject:crate forKey:@"返佣费率"];
//			}
//			NSString *pstate = [dic valueForKey:@"pstate"];
//			if (!IsStrEmpty(pstate)) {
//				[dataDic setObject:pstate forKey:@"状态"];
//			}
//			NSString *term = [dic valueForKey:@"term"];
//			if (!IsStrEmpty(term)) {
//				[dataDic setObject:term forKey:@"投资期限"];
//			}
//			NSString *bline = [dic valueForKey:@"bline"];
//			if (!IsStrEmpty(bline)) {
//				[dataDic setObject:bline forKey:@"购买起点"];
//			}
//			NSString *sname = [dic valueForKey:@"sname"];
//			if (!IsStrEmpty(sname)) {
//				[dataDic setObject:sname forKey:@"股票名称"];
//			}
//			NSString *recordno = [dic valueForKey:@"recordno"];
//			if (!IsStrEmpty(recordno)) {
//				[dataDic setObject:recordno forKey:@"证监会备案号"];
//			}
//			NSString *holding = [dic valueForKey:@"holding"];
//			if (!IsStrEmpty(holding)) {
//				[dataDic setObject:holding forKey:@"持有周期"];
//			}
//			NSString *sprice = [dic valueForKey:@"sprice"];
//			if (!IsStrEmpty(sprice)) {
//				[dataDic setObject:sprice forKey:@"单股价格"];
//			}
//			
//			NSString *add = [dic valueForKey:@"add"];
//			if (!IsStrEmpty(add)) {
//				[dataDic setObject:add forKey:@"递增单位"];
//			}

			[self.dataSource addObject:dic];
		}
		
		[self.tableView reloadData];
		
		
		NSLog(@"%@",response.data);
		NSLog(@"%@",response.errorMessage);
		
	} failed:^(MOCHTTPResponse *response) {
		
	}];
	

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
//	return self.dataSource.count;
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
//	NSDictionary *dic = self.dataSource[section];
	
//	return dic.allKeys.count;
	return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"";
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MyAppointmentTableViewCell  *cell = (MyAppointmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyAppointmentTableViewCell"];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAppointmentTableViewCell" owner:self options:nil] objectAtIndex:0];
	}
	
	NSDictionary *dic = self.dataSource[indexPath.row];
	[cell setCellWithDic:dic];
	
	return cell;
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
