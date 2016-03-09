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

@interface MyMoneyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"我的佣金";
    [CommonMethod setExtraCellLineHidden:self.tableView];

	self.dataSource = [[NSMutableArray alloc] init];
    [self initView];
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
        [self loadData];
		[self.tableView reloadData];
		
		
		NSLog(@"%@",response.data);
		NSLog(@"%@",response.errorMessage);
		
	} failed:^(MOCHTTPResponse *response) {
		
	}];

}

- (void)initView
{
    
    self.viewHeader.backgroundColor = [UIColor whiteColor];
    self.allLabel.font = FontFactor(13.0f);
    self.allLabel.textColor = [UIColor colorWithHexString:@"989898"];
    self.numLabel.font = FontFactor(25.0f);
    self.numLabel.textColor = [UIColor colorWithHexString:@"d43c33"];
    self.grayView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.detailNameLabel.font = FontFactor(13.0f);
    self.detailNameLabel.textColor = [UIColor colorWithHexString:@"989898"];
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
    self.viewHeader.sd_layout
    .topSpaceToView(self.tableView, 0.0f)
    .leftSpaceToView(self.tableView, 0.0f)
    .rightSpaceToView(self.tableView, 0.0f)
    .heightIs(MarginFactor(142.0f));
    
    self.grayView.sd_layout
    .bottomSpaceToView(self.viewHeader, 0.0f)
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .heightIs(MarginFactor(37.0f));
    
    self.detailNameLabel.sd_layout
    .leftSpaceToView(self.grayView, MarginFactor(12.0f))
    .centerYEqualToView(self.grayView)
    .autoHeightRatio(0.0f);
    [self.detailNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.allLabel.sd_layout
    .topSpaceToView(self.viewHeader, MarginFactor(10.0f))
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.allLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.numLabel.sd_layout
    .leftEqualToView(self.allLabel)
    .bottomSpaceToView(self.grayView, MarginFactor(35.0f))
    .autoHeightRatio(0.0f);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    self.tableView.tableHeaderView = self.viewHeader;
}

- (void)loadData
{
    self.allLabel.text = @"佣金总计";
    [self.allLabel sizeToFit];
    self.detailNameLabel.text = @"佣金明细";
    [self.detailNameLabel sizeToFit];
    self.numLabel.text = self.totalMoney;
    [self.numLabel sizeToFit];
    [self.viewHeader layoutSubviews];
    self.tableView.tableHeaderView = self.viewHeader;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMoneyDetailObject *object = self.dataSource[indexPath.row];
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[MyMoneyDetailTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
		static NSString *CellIdentifier = @"MyMoneyDetailTableViewCell";
    MyMoneyDetailTableViewCell *cell = (MyMoneyDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    
    MyMoneyDetailObject *obj = self.dataSource[indexPath.row];
    cell.object = obj;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
