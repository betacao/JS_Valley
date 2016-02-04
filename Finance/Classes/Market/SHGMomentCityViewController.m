//
//  SHGMomentCityViewController.m
//  Finance
//
//  Created by weiqiankun on 16/1/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMomentCityViewController.h"
#import "SHGMomentCityTableViewCell.h"
#import "SHGMarketManager.h"
#import "CCLocationManager.h"
//主要目的是记录“全部”显示的位置，与cell里面的对齐
#define leftMargin 16.0f * XFACTOR

@interface SHGMomentCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableViewCell *gpsCell;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SHGMomentCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前城市";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    [[SHGMarketManager shareManager] loadHotCitys:^(NSArray *array) {
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.dataArr addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    }];


}

- (UITableViewCell *)gpsCell
{
    if(!_gpsCell){
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        NSString *cityName = [SHGMarketManager shareManager].cityName;

        _gpsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _gpsCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _gpsCell.textLabel.textColor = [UIColor colorWithHexString:@"141414"];
        _gpsCell.textLabel.text = cityName;

        UIButton *gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];;
        [gpsButton setTitle:@"重新定位" forState:UIControlStateNormal];
        [gpsButton setTitleColor:[UIColor colorWithHexString:@"4b88b7"] forState:UIControlStateNormal];
        [gpsButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [gpsButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0f, 0, 0)];
        [gpsButton addTarget:self action:@selector(startlocation) forControlEvents:UIControlEventTouchUpInside];
        gpsButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
        [gpsButton sizeToFit];
        gpsButton.center = _gpsCell.contentView.center;
        CGRect frame = gpsButton.frame;
        frame.size.height = CGRectGetHeight(_gpsCell.frame);
        frame.origin.x = SCREENWIDTH - CGRectGetWidth(frame) - leftMargin;
        frame.origin.y = 0.0f;
        gpsButton.frame = frame;

        self.indicator.center = _gpsCell.contentView.center;
         frame = self.indicator.frame;
        frame.origin.x = leftMargin;
        self.indicator.frame = frame;
        self.indicator.hidesWhenStopped = YES;
        [_gpsCell.contentView addSubview:self.indicator];

        [_gpsCell.contentView addSubview:gpsButton];
    }

    return _gpsCell;
}

- (void)startlocation
{
    __weak typeof(self) weakSelf = self;
    [self.indicator startAnimating];
    self.gpsCell.textLabel.text = @"";
    [[CCLocationManager shareLocation] getCity:^{
        [weakSelf.indicator stopAnimating];
        weakSelf.gpsCell.textLabel.text = [SHGGloble sharedGloble].cityName;
    }];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identfier";
    SHGMomentCityTableViewCell *cell = nil;
    if(indexPath.section > 0){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else{
        return self.gpsCell;
    }

    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMomentCityTableViewCell" owner:self options:nil] lastObject];
    }
    if(indexPath.section == 1){
        SHGMarketCityObject *object = [self.dataArr objectAtIndex:indexPath.row];
        [cell loadWithUi:object];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, 37.0f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"EFEEEF"];

    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.text = @"热门城市";
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        NSString *cityName = self.gpsCell.textLabel.text;
        if(cityName && cityName.length > 0){
            [SHGMarketManager shareManager].cityName = cityName;
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            [Hud showMessageWithText:@"正在定位，请稍后..."];
        }
    } else{
        SHGMarketCityObject *city = [self.dataArr objectAtIndex:indexPath.row];
        [SHGMarketManager shareManager].cityName = city.cityName;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
