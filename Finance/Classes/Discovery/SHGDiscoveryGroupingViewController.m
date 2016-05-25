//
//  SHGDiscoveryGroupingViewController.m
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryGroupingViewController.h"
#import "SHGDiscoveryManager.h"

@interface SHGDiscoveryGroupingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SHGDiscoveryGroupingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addAutoLayout];
    NSDictionary *param = nil;
    if (self.type == SHGDiscoveryGroupingTypeIndustry) {
        self.title = @"行业分组";
        param = @{@"uid":UID, @"aliasName":@"industry"};
    } else {
        self.title = @"地区分组";
        param = @{@"uid":UID, @"aliasName":@"position"};
    }
    __weak typeof(self)weakSelf = self;
    [SHGDiscoveryManager loadDiscoveryGroupUser:param block:^(NSArray *dataArray) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [weakSelf.tableView reloadData];
    }];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(55.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGDiscoveryGroupingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryGroupingCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryGroupingCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



@interface SHGDiscoveryGroupingCell()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIView *spliteView;

@end

@implementation SHGDiscoveryGroupingCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.leftLabel.font = FontFactor(15.0f);
    self.leftLabel.textColor = Color(@"161616");

    self.rightLabel.font = FontFactor(13.0f);
    self.rightLabel.textColor = Color(@"bbbbbb");

    self.rightArrowImageView.image = [UIImage imageNamed:@"rightArrowImage"];

    self.spliteView.backgroundColor = Color(@"e5e6e7");

}

- (void)addAutoLayout
{
    self.leftLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(19.0f))
    .centerYEqualToView(self.contentView);
    [self.leftLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.rightArrowImageView.sd_layout
    .centerYEqualToView(self.leftLabel)
    .rightSpaceToView(self.contentView, MarginFactor(19.0f))
    .widthIs(self.rightArrowImageView.image.size.width)
    .heightIs(self.rightArrowImageView.image.size.height);

    self.rightLabel.sd_layout
    .rightSpaceToView(self.rightArrowImageView, MarginFactor(15.0f))
    .centerYEqualToView(self.contentView);
    [self.rightLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];

    self.spliteView.sd_layout
    .bottomSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, MarginFactor(16.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

}

- (void)setObject:(SHGDiscoveryIndustryObject *)object
{
    _object = object;
    self.leftLabel.text = object.moduleName;
    self.rightLabel.text = [object.counts stringByAppendingString:@"人"];
}

@end