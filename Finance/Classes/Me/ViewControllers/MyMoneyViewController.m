//
//  MyMoneyViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "MyMoneyDetailTableViewCell.h"
#import "MyMoneyDetailObject.h"

@interface MyMoneyViewController ()
	<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"我的佣金";
    [CommonMethod setExtraCellLineHidden:self.tableView];

	self.dataSource = [[NSMutableArray alloc] init];
//	MyMoneyDetailObject *obj = [[MyMoneyDetailObject alloc] init];
//	obj.name = @"哈哈";
//	obj.productName = @"哈哈";
//	obj.totalMoney = @"哈哈";
//	obj.commission = @"哈哈";
//	[self.dataSource addObject:obj];

	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	[MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"commission"] parameters:@{@"uid":uid}success:^(MOCHTTPResponse *response) {
		
		self.totalMoney = [response.dataDictionary valueForKey:@"commissions"];
		NSArray *array = [response.dataDictionary valueForKey:@"detail"];
		
		for (NSDictionary *dic in array) {
			
			
			MyMoneyDetailObject *obj = [[MyMoneyDetailObject alloc] init];
			obj.name = [dic valueForKey:@"name"];
			obj.productName = [dic valueForKey:@"pname"];
			obj.totalMoney = [dic valueForKey:@"money"];
			obj.commission = [dic valueForKey:@"commission"];
            obj.type =[dic valueForKey:@"type"];

			[self.dataSource addObject:obj];
		}
        NSLog(@"%@",response.dataDictionary);
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
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	if (section == 0) {
		return 1;
	}else if(section == 1){
		return self.dataSource.count;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	if (section == 0) {
//		return @"佣金总和";
//	}else if(section == 1){
//		return @"佣金明细";
//	}
//	return @"";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
	sectionView.backgroundColor = RGB(240, 240, 240);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 300, 50)];
	if (section == 0) {
		label.text = @"佣金总计";
	}else if(section == 1){
		label.text = @"佣金明细";
	}
	label.font = [UIFont fontWithName:@"Palatino" size:17];
	[sectionView addSubview:label];
	return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 55;
	}else if(indexPath.section == 1){
        
		return 205;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
		cell.textLabel.text = [NSString stringWithFormat:@"%@元",self.totalMoney];
		return cell;
		
	}else if(indexPath.section == 1){
		static NSString *CellIdentifier = @"MyMoneyDetailTableViewCell";
		MyMoneyDetailTableViewCell *cell = (MyMoneyDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
		}
		
		MyMoneyDetailObject *obj = self.dataSource[indexPath.row];
		
		cell.nameLabel.text = obj.name;
		cell.productLabel.text = obj.productName;
		cell.totalMoney.text = obj.totalMoney;
		cell.commissionMoney.text = obj.commission;
        switch ([obj.type intValue]) {
            case 0:
                cell.moneyType.text=@"我的客户";
                break;
            case 1:
                cell.moneyType.text=@"二级客户";
            default:
                cell.moneyType.text=@"三级客户";
                break;
        }
        

        
		
		cell.nameLabel.textColor = TEXT_COLOR;
		cell.productLabel.textColor = TEXT_COLOR;
		cell.totalMoney.textColor = TEXT_COLOR;
		cell.commissionMoney.textColor = TEXT_COLOR;
        cell.moneyType.textColor = TEXT_COLOR;
		
		return cell;

	}

	
	UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
	NSLog(@"empty cell created");
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
