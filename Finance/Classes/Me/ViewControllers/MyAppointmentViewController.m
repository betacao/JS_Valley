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
	
	self.title = @"我的预约";
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	[_tableView setTableFooterView:view];

	self.dataSource = [[NSMutableArray alloc] init];

	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"orderlist"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
		for (NSDictionary *dic in response.dataArray) {
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
