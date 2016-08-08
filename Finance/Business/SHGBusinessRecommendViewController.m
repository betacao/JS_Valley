//
//  SHGBusinessRecommendViewController.m
//  Finance
//
//  Created by changxicao on 16/7/15.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessRecommendViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessNewDetailViewController.h"
@interface SHGBusinessRecommendViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation SHGBusinessRecommendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"今日优质业务";
    [self initView];
    [self addAutoLayout];
    [self loadData];
}

- (void)initView
{
    self.timeLabel.font = FontFactor(12.0f);
    self.timeLabel.textColor = Color(@"d4d4d4");
    self.tableView.backgroundColor = self.spliteView.backgroundColor = self.footerView.backgroundColor = Color(@"f6f7f8");
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.spliteView.sd_layout
    .leftSpaceToView(self.footerView, 0.0f)
    .rightSpaceToView(self.footerView, 0.0f)
    .topSpaceToView(self.footerView, 0.0f)
    .heightIs(MarginFactor(25.0f));

    self.timeLabel.sd_layout
    .rightSpaceToView(self.footerView, MarginFactor(16.0f))
    .topSpaceToView(self.spliteView, 0.0f)
    .heightIs(self.timeLabel.font.lineHeight);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH  ];

    [self.footerView setupAutoHeightWithBottomView:self.timeLabel bottomMargin:0.0f];

    self.timeLabel.text = self.time;

    self.tableView.tableFooterView = self.footerView;
    [self.timeLabel updateLayout];
    self.tableView.tableFooterView = self.footerView;
}


- (void)loadData
{
    WEAK(self, weakSelf);
    [SHGBusinessManager gradebusiness:@{@"businessId":self.object.businessID, @"type":self.object.type} block:^(NSArray *dataArray) {
        weakSelf.dataArray = [NSArray arrayWithArray:dataArray];
        [weakSelf.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGBusinessObject *object = [self.dataArray objectAtIndex:indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGBusinessRecommendTableViewCell class] contentViewWidth:SCREENWIDTH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SHGBusinessRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGBusinessRecommendTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessRecommendTableViewCell" owner:self options:nil] lastObject];
    }
    SHGBusinessObject *object = [self.dataArray objectAtIndex:indexPath.row];
    cell.object = object;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGBusinessObject *object = [self.dataArray objectAtIndex:indexPath.row];
    SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
    controller.object = object;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



@interface SHGBusinessRecommendTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIView *typeLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation SHGBusinessRecommendTableViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.spliteView.backgroundColor = Color(@"f6f7f8");
    self.spliteLine.backgroundColor = Color(@"e5e5e5");
    self.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.typeLine.backgroundColor = Color(@"e5e5e5");
    self.accessoryImageView.image = [UIImage imageNamed:@"business_type_accessory"];
    self.titleLabel.textColor = Color(@"3e3e3e");
    self.titleLabel.font = FontFactor(17.0f);
    self.firstLabel.textColor = self.secondLabel.textColor = self.thirdLabel.textColor = self.fourthLabel.textColor = Color(@"b8b8b8");
    self.firstLabel.font = self.secondLabel.font = self.thirdLabel.font = self.fourthLabel.font = FontFactor(14.0f);
    self.bottomLine.backgroundColor = Color(@"e5e5e5");

}

- (void)addAutoLayout
{
    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(12.0f));

    self.spliteLine.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteView, 0.0f)
    .heightIs(1 / SCALE);

    self.typeImageView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteLine, 0.0f)
    .widthIs(0.0f)
    .heightIs(0.0f);

    self.typeLine.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(16.0f))
    .rightSpaceToView(self.contentView, MarginFactor(16.0f))
    .topSpaceToView(self.spliteLine, MarginFactor(42.0f))
    .heightIs(1 / SCALE);


    self.titleLabel.sd_layout
    .leftEqualToView(self.typeLine)
    .topSpaceToView(self.typeLine, MarginFactor(21.0f))
    .rightSpaceToView(self.contentView, MarginFactor(62.0f))
    .heightIs(self.titleLabel.font.lineHeight);
    
    self.accessoryImageView.sd_layout
    .topEqualToView(self.titleLabel)
    .rightEqualToView(self.typeLine)
    .widthIs(self.accessoryImageView.image.size.width)
    .heightIs(self.accessoryImageView.image.size.height);

    self.firstLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, MarginFactor(19.0f))
    .rightEqualToView(self.accessoryImageView)
    .heightIs(self.firstLabel.font.lineHeight);

    self.secondLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(210.0f))
    .topEqualToView(self.firstLabel)
    .rightEqualToView(self.accessoryImageView)
    .heightIs(self.secondLabel.font.lineHeight);
    //[self.secondLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.thirdLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.accessoryImageView)
    .topSpaceToView(self.firstLabel, MarginFactor(16.0f))
    .autoHeightRatio(0.0f);
   // [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.fourthLabel.sd_layout
    .leftEqualToView(self.secondLabel)
    .topEqualToView(self.thirdLabel)
    .heightIs(self.fourthLabel.font.lineHeight);
    [self.fourthLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.thirdLabel, MarginFactor(21.0f))
    .heightIs(1 / SCALE);

    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0.0f];
}

- (void)setObject:(SHGBusinessObject *)object
{
    _object = object;
    [self.thirdLabel sizeToFit];
    self.titleLabel.text = object.title;
    object.investAmount = [object.investAmount stringByReplacingOccurrencesOfString:@":" withString:@"："];
    UIImage *image = nil;
    if ([object.type isEqualToString:@"bondfinancing"]) {
        //债权融资
        image = [UIImage imageNamed:@"bond_fanancing_type"];
        self.firstLabel.text = object.investAmount;
        self.secondLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.clarifyingWay showEmptyKeys:NO];
        NSString *string = [[SHGGloble sharedGloble] businessKeysForValues:object.industry showEmptyKeys:NO];
        self.thirdLabel.text = [string substringToIndex:string.length - 1];
        self.fourthLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.fundUsetime showEmptyKeys:NO];
    } else if ([object.type isEqualToString:@"equityfinancing"]) {
        //股权融资
        image = [UIImage imageNamed:@"equity_fanancing_type"];
        self.firstLabel.text = object.investAmount;
        self.secondLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.totalshareRate showEmptyKeys:NO];
        NSString *string = [[SHGGloble sharedGloble] businessKeysForValues:object.industry showEmptyKeys:NO];
        self.thirdLabel.text = [string substringToIndex:string.length - 1];
        self.fourthLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.shortestquitYears showEmptyKeys:NO];
    } else  if ([object.type isEqualToString:@"trademixed"]) {
        //银证业务
        image = [UIImage imageNamed:@"bankcard_business_type"];
        self.firstLabel.text = [[SHGGloble sharedGloble] businessKeysForValues:object.businessType showEmptyKeys:NO];
        NSString * string = [[SHGGloble sharedGloble] businessKeysForValues:object.detail showEmptyKeys:NO];
        string = [string substringToIndex:string.length - 1];
        if (string.length > 38) {
            string = [[string substringToIndex:38] stringByAppendingString:@"..."];
        }
        self.thirdLabel.text = string;
        
    }
    self.typeImageView.image = image;
    self.typeImageView.sd_resetLayout
    .leftSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.spliteLine, 0.0f)
    .widthIs(image.size.width)
    .heightIs(image.size.height);

}


@end