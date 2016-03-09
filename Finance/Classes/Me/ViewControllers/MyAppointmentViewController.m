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
    self.tableView.tableFooterView = [[UIView alloc] init];

	self.dataSource = [[NSMutableArray alloc] init];

    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"orderlist"] class:[myAppointmentModel class] parameters:@{@"uid":UID} success:^(MOCHTTPResponse *response) {
      
        [self.dataSource addObjectsFromArray:response.dataArray];
        [self.tableView reloadData];
    } failed:^(MOCHTTPResponse *response) {
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSource.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myAppointmentModel *object = self.dataSource[indexPath.row];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"model" cellClass:[MyAppointmentTableViewCell class] contentViewWidth:CGFLOAT_MAX];
    return height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MyAppointmentTableViewCell  *cell = (MyAppointmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyAppointmentTableViewCell"];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAppointmentTableViewCell" owner:self options:nil] objectAtIndex:0];
	}
	
	myAppointmentModel *model= self.dataSource[indexPath.row];
    cell.model = model;
	
	return cell;
	
	
}


@end
