//
//  SHGCitySelectViewController.m
//  Finance
//
//  Created by weiqiankun on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCitySelectViewController.h"
#import "CCLocationManager.h"

@interface SHGCitySelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *momentView;
@property (weak, nonatomic) IBOutlet UILabel *momentLabel;
@property (weak, nonatomic) IBOutlet UIButton *momentCityButton;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *citys;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation SHGCitySelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"城市选择";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.areaLabel.text = self.momentCity;
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"China_City" ofType:@"plist"]];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.provinces addObject:[obj objectForKey:@"state"]];
        NSArray *cityArray = [obj objectForKey:@"cities"];
        [self.citys addObject:cityArray];
    }];
    
    self.currentIndex = 0;
    if ([[self.citys objectAtIndex:self.currentIndex] count] == 0) {
        [self.dataArray addObject:[self.provinces objectAtIndex:self.currentIndex]];
    } else{
        [self.dataArray addObjectsFromArray:[self.citys objectAtIndex:self.currentIndex]];
    }
    
    [self addSdLyout];
    [self initView];
    
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}
- (NSMutableArray *)provinces
{
    if (!_provinces) {
        _provinces = [[NSMutableArray alloc] init];
    }
    return _provinces;
}

- (NSMutableArray *)citys
{
    if (!_citys) {
        _citys = [[NSMutableArray alloc] init];
    }
    return _citys;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)initView
{
    self.momentView.backgroundColor = self.secondView.backgroundColor = self.scrollview.backgroundColor = Color(@"f7f7f7");
    self.momentLabel.textColor = self.secondLabel.textColor = Color(@"8d8d8d");
    self.momentLabel.font = self.secondLabel.font = FontFactor(14.0f);
    self.momentLabel.textAlignment = self.secondLabel.textAlignment = NSTextAlignmentLeft;
    self.areaLabel.textColor = Color(@"161616");
    self.areaLabel.font = FontFactor(16.0f);
    self.areaLabel.textAlignment = NSTextAlignmentLeft;
    self.momentCityButton.titleLabel.font = FontFactor(14.0f);
    [self.momentCityButton setTitleColor:Color(@"247ee3") forState:UIControlStateNormal];
    self.momentCityButton.titleLabel.textAlignment = NSTextAlignmentRight;
    __block UIButton *lastButton = nil;
    for (NSInteger i = 0; i < self.provinces.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(3.0f, i * (MarginFactor(50.0f) + 1.0f) , MarginFactor(138.0f), MarginFactor(50.0f));
        button.titleLabel.font = FontFactor(14.0f);
        [button setTitle:[self.provinces objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.currentIndex) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        [self.buttonArray addObject:button];
        [self.scrollview addSubview:button];
        
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = Color(@"e6e7e8");
        bottomLineView.frame = CGRectMake(0.0f,CGRectGetMaxY(button.frame), MarginFactor(138.0f), 1.0 / SCALE);
        [self.scrollview addSubview:bottomLineView];
        lastButton = button;
    }
    self.redView = [[UIView alloc] init];
    self.redView.backgroundColor = Color(@"f04f46");
    self.redView.frame = CGRectMake(0.0f, 0.0, 3.0f, MarginFactor(50.0f));
    [self.scrollview addSubview:self.redView];
    
    [self.scrollview setupAutoContentSizeWithBottomView:lastButton bottomMargin:1.0f];
}

- (IBAction)cityButtonClick:(UIButton *)sender
{
    [[CCLocationManager shareLocation] getCity:^{
        NSString *provinceName = [SHGGloble sharedGloble].provinceName;
        NSString *city = [SHGGloble sharedGloble].cityName;
        self.areaLabel.text = [NSString stringWithFormat:@"%@ %@",provinceName,city];
    }];
}

- (void)buttonClick:(UIButton *)btn
{
   NSInteger index = [self.provinces indexOfObject:btn.titleLabel.text];
    for (NSInteger i = 0; i < self.buttonArray.count; i ++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        if (i == index) {
            [button setBackgroundColor:[UIColor whiteColor]];
            self.redView.frame = CGRectMake(0.0f, CGRectGetMinY(button.frame), 3.0f, MarginFactor(50.0f));
        } else{
            [button setBackgroundColor:Color(@"f7f7f7")];
        }
    }
    NSLog(@"index%ld",index);
    [self.dataArray removeAllObjects];
    if ([[self.citys objectAtIndex:index] count] == 0) {
        [self.dataArray addObject:[self.provinces objectAtIndex:index]];
    } else{
        [self.dataArray addObjectsFromArray:[self.citys objectAtIndex:index]];
    }
    [self.tableView reloadData];
    self.currentIndex = index;
    
}

- (void)addSdLyout
{
 
    self.momentView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(32.0f));
    
    self.momentLabel.sd_layout
    .leftSpaceToView(self.momentView, MarginFactor(19.0f))
    .centerYEqualToView(self.momentView)
    .heightIs(MarginFactor(32.0f));
    [self.momentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.momentCityButton.sd_layout
    .rightSpaceToView(self.momentView, MarginFactor(19.0f))
    .centerYEqualToView(self.momentView)
    .widthIs(MarginFactor(150.0f))
    .heightIs(MarginFactor(32.0f));
    
    self.areaLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(27.0f))
    .topSpaceToView(self.momentView, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(53.0f));
    
    self.secondView.sd_layout
    .topSpaceToView(self.areaLabel, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(32.0f));
    
    self.secondLabel.sd_layout
    .leftSpaceToView(self.secondView, MarginFactor(19.0f))
    .rightSpaceToView(self.secondView, 0.0f)
    .topSpaceToView(self.secondView, 0.0f)
    .heightIs(MarginFactor(32.0f));
    
    self.scrollview.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.secondView, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .widthIs(MarginFactor(138.0f));

    self.tableView.sd_layout
    .leftSpaceToView(self.scrollview, 0.0f)
    .topSpaceToView(self.secondView, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
}

#pragma mark -- tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(51.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"SHGCitySelectTableViewCell";
    SHGCitySelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identity owner:self options:nil] lastObject];
    }
    cell.city = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *provinceName = [self.provinces objectAtIndex:self.currentIndex];
    NSString *city = [self.dataArray objectAtIndex:indexPath.row];
    WEAK(self, weakSelf);
    if (weakSelf.returnCityBlock) {
        if ([provinceName isEqualToString:city]) {
            weakSelf.returnCityBlock(city);
            weakSelf.areaLabel.text = city;
        } else{
             weakSelf.returnCityBlock([NSString stringWithFormat:@"%@ %@",provinceName,city]);
            weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@ %@",provinceName,city];
        }
       
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end


@interface SHGCitySelectTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation SHGCitySelectTableViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSdLayout];
    [self initView];
    
}

- (void)addSdLayout
{
    self.cityLabel.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 1.0f);
    
    self.lineView.sd_layout
    .topSpaceToView(self.cityLabel, 0.0f)
    .leftSpaceToView(self.contentView, MarginFactor(23.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1/SCALE);
}

- (void)initView
{
    self.cityLabel.textColor = Color(@"161616");
    self.cityLabel.font = FontFactor(14.0f);
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    self.lineView.backgroundColor = Color(@"e6e7e8");
}

- (void)setCity:(NSString *)city
{
    _city = city;
    self.cityLabel.text = self.city;
}
@end


