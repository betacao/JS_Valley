//
//  SHGAreaViewController.m
//  Finance
//
//  Created by changxicao on 15/9/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGAreaViewController.h"
//主要目的是记录“全部”显示的位置，与cell里面的对齐
#define leftMargin 16.0f * XFACTOR

@interface SHGAreaViewController ()

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) UITableViewCell *gpsCell;

@end

@implementation SHGAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"China_City" ofType:@"plist"]];
//    self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
//    self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
//    self.locate.city = [self.cities objectAtIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return 37.0f;
    }
    return 0.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identfier";
    UITableViewCell *cell = nil;
    if(indexPath.section > 0){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else{
        return self.gpsCell;
    }

    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.section == 1){
        NSDictionary *province = [self.provinces objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"434343"];
        cell.textLabel.text = [province objectForKey:@"state"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, 37.0f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];

    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.text = @"全部";
    allLabel.font = [UIFont systemFontOfSize:15.0f];
    allLabel.textColor = [UIColor colorWithHexString:@"606060"];
    [allLabel sizeToFit];
    allLabel.center = headerView.center;
    CGRect frame = allLabel.frame;
    frame.origin.x = leftMargin;
    allLabel.frame = frame;
    [headerView addSubview:allLabel];
    return headerView;
}

- (UITableViewCell *)gpsCell
{
    if(!_gpsCell){
        _gpsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _gpsCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _gpsCell.textLabel.textColor = [UIColor colorWithHexString:@"141414"];
        _gpsCell.textLabel.text = @"南京";
        UILabel *gpsLabel = [[UILabel alloc] init];
        gpsLabel.text = @"GPS定位";
        gpsLabel.textColor = [UIColor colorWithHexString:@"4b88b7"];
        gpsLabel.font = [UIFont systemFontOfSize:15.0f];
        [gpsLabel sizeToFit];
        gpsLabel.center = _gpsCell.contentView.center;
        CGRect frame = gpsLabel.frame;
        frame.origin.x = 3.5f * leftMargin;
        gpsLabel.frame = frame;
        [_gpsCell.contentView addSubview:gpsLabel];
    }

    return _gpsCell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end