//
//  MyAddressViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "AddressObject.h"
#import "AddAddressViewController.h"

@interface MyAddressViewController ()
	<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"我的地址";
	self.view.backgroundColor = RGB(240, 240, 240);
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(addNewAddress)];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame =CGRectMake(0, 0, 50, 44);
	[button addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"修改" forState:UIControlStateNormal];
	[button setTitle:@"修改" forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	[_tableView setTableFooterView:view];

	
	self.dataSource = [[NSMutableArray alloc] init];
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"address"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
		
		
		
		AddressObject *obj = [[AddressObject alloc] init];
		obj.name = [response.dataDictionary valueForKey:@"name"];
		obj.phoneNumber = [response.dataDictionary valueForKey:@"phone"];
		obj.code = [response.dataDictionary valueForKey:@"code"];
		obj.area = [response.dataDictionary valueForKey:@"street"];
		obj.addressDescription = [response.dataDictionary valueForKey:@"address"];
		[self.dataSource addObject:obj];
		
		[self.tableView reloadData];
		
		
		NSLog(@"%@",response.data);
		NSLog(@"%@",response.errorMessage);
		
	} failed:^(MOCHTTPResponse *response) {
		
	}];

}

- (void)addNewAddress
{
	AddAddressViewController *vc = [[AddAddressViewController alloc] init];
	if (self.dataSource.count >0) {
		vc.obj = self.dataSource[0];
	}else{
		vc.obj = [[AddressObject alloc] init];
	}
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"MyAddressTableViewCell";
	MyAddressTableViewCell *cell = (MyAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Configure the cell...
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
	}
	
	AddressObject *obj = self.dataSource[indexPath.row];

	cell.nameLabel.text = obj.name;
	cell.phoneNumberLabel.text = obj.phoneNumber;
	cell.addressDecription.text = obj.addressDescription;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
