//
//  SHGMarketDetailViewController.m
//  Finance
//
//  Created by changxicao on 15/12/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketDetailViewController.h"
#import "SHGMarketTableViewCell.h"
@interface SHGMarketDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;


@end

@implementation SHGMarketDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务详情";
    self.detailTable.delegate = self;
    self.detailTable.backgroundColor = [UIColor redColor];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString * identifier = @"SHGMarketTableViewCell";
    SHGMarketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
