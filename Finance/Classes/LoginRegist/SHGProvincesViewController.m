//
//  SHGAreaViewController.m
//  Finance
//
//  Created by changxicao on 15/9/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGProvincesViewController.h"
#import "CCLocationManager.h"
//主要目的是记录“全部”显示的位置，与cell里面的对齐
#define leftMargin 16.0f * XFACTOR

@interface SHGProvincesViewController ()

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) UITableViewCell *gpsCell;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation SHGProvincesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"China_City" ofType:@"plist"]];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectZero];
    NSString *imageName = @"返回";
    [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    __weak typeof(self) weakSelf = self;
    [[CCLocationManager shareLocation] getCity:^{
        [weakSelf.indicator removeFromSuperview];
        weakSelf.gpsCell.textLabel.text = [SHGGloble sharedGloble].cityName;
    }];
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        NSString *cityName = [SHGGloble sharedGloble].cityName;

        _gpsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _gpsCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _gpsCell.textLabel.textColor = [UIColor colorWithHexString:@"141414"];
        if(!cityName || cityName.length == 0){
            self.indicator.center = _gpsCell.contentView.center;
            CGRect frame = self.indicator.frame;
            frame.origin.x = leftMargin;
            self.indicator.frame = frame;
            [_gpsCell.contentView addSubview:self.indicator];
            [self.indicator startAnimating];
        } else{
            _gpsCell.textLabel.text = @"南京";
        }
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
    if(indexPath.section == 0){
        NSString *cityName = [SHGGloble sharedGloble].cityName;
        if(cityName && cityName.length > 0){
            if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCity:)]){
                [self.delegate didSelectCity:cityName];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else{
            [Hud showMessageWithText:@"正在定位，请稍后..."];
        }
    } else{
        NSArray *citys = [[self.provinces objectAtIndex:indexPath.row] objectForKey:@"cities"];
        if(citys && citys.count > 0){
            SHGCitysViewController *controller = [[SHGCitysViewController alloc] initWithStyle:UITableViewStylePlain];
            controller.citys = citys;
            controller.delegate = self.delegate;
            [self.navigationController pushViewController:controller animated:YES];
        } else{
            NSString *cityName = [[self.provinces objectAtIndex:indexPath.row] objectForKey:@"state"];
            if(cityName && cityName.length > 0){
                if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCity:)]){
                    [self.delegate didSelectCity:cityName];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
}

@end

@interface SHGCitysViewController ()

@end

@implementation SHGCitysViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择城市";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectZero];
    NSString *imageName = @"返回";
    [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCitys:(NSArray *)citys
{
    _citys = citys;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identfier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *city = [self.citys objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"434343"];
    cell.textLabel.text = city;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCity:)]){
        [self.delegate didSelectCity:[self.citys objectAtIndex:indexPath.row]];
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:index - 2];
        if(controller){
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


@end