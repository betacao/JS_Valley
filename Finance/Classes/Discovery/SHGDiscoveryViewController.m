//
//  SHGDiscoveryViewController.m
//  Finance
//
//  Created by changxicao on 16/5/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryViewController.h"
#import "SHGDiscoveryManager.h"
#import "EMSearchBar.h"

@interface SHGDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SHGDiscoveryMyContactView *myContactView;
@property (strong, nonatomic) IBOutlet SHGDiscoveryContactRecommendView *contactRecommendView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) IBOutlet SHGDiscoveryContactExpandCell *contactExpandCell;

@end

@implementation SHGDiscoveryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发现";
    [self initView];
    [self addAutoLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [SHGDiscoveryManager loadDiscoveryData:@{@"uid":UID} block:^(NSArray *dataArray, NSString *position, NSString *tipUrl, NSString *cfData) {

    }];
}

- (void)initView
{
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(193.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contactExpandCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@interface SHGDiscoveryMyContactView()

@end

@implementation SHGDiscoveryMyContactView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end




@interface SHGDiscoveryContactExpandCell()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SHGDiscoveryCategoryButton *leftButton;
@property (weak, nonatomic) IBOutlet SHGDiscoveryCategoryButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation SHGDiscoveryContactExpandCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.buttonView.backgroundColor = Color(@"efecee");
    self.redLineView.backgroundColor = [UIColor redColor];
    self.titleLabel.font = FontFactor(14.0f);
    self.titleLabel.text = @"人脉拓展";

    __weak typeof(self)weakSelf = self;
    self.leftButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        [weakSelf.leftButton setTitle:@"行业" image:[UIImage imageNamed:@"discovery_department"]];
    };
    self.rightButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        [weakSelf.rightButton setTitle:@"地区" image:[UIImage imageNamed:@"discovery_location"]];
    };
}

- (void)addAutoLayout
{
    self.topView.sd_layout
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .topSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(57.0f));

    self.redLineView.sd_layout
    .leftSpaceToView(self.topView, MarginFactor(12.0f))
    .widthIs(MarginFactor(2.0f))
    .heightIs(MarginFactor(11.0f))
    .centerYEqualToView(self.topView);

    self.titleLabel.sd_layout
    .leftSpaceToView(self.redLineView, MarginFactor(10.0f))
    .centerYEqualToView(self.topView)
    .rightSpaceToView(self.topView, 0.0f)
    .heightIs(self.titleLabel.font.lineHeight);

    self.buttonView.sd_layout
    .topSpaceToView(self.topView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(136.0f));

    self.leftButton.sd_layout
    .leftSpaceToView(self.buttonView, 0.0f)
    .topSpaceToView(self.buttonView, 1 / SCALE)
    .widthRatioToView(self.buttonView, 0.5f)
    .bottomSpaceToView(self.buttonView, 1 / SCALE);

    self.rightButton.sd_layout
    .leftSpaceToView(self.leftButton, 1 / SCALE)
    .topSpaceToView(self.buttonView, 1 / SCALE)
    .rightSpaceToView(self.buttonView, 0.0f)
    .bottomSpaceToView(self.buttonView, 1 / SCALE);

}

@end






@interface SHGDiscoveryContactRecommendView()

@end

@interface SHGDiscoveryCategoryButton()

@end

@implementation SHGDiscoveryCategoryButton

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    if ([title isEqualToString:self.titleLabel.text]) {
        return;
    }
    self.titleLabel.font = FontFactor(14.0f);
    self.backgroundColor = [UIColor whiteColor];
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, buttonBoundsCenter.y - (MarginFactor(10.0f) + CGRectGetHeight(self.imageView.frame)) / 2.0f);

    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, buttonBoundsCenter.y + (MarginFactor(10.0f) + CGRectGetHeight(self.titleLabel.frame)) / 2.0f);

    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;

    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;

    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);

    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}

@end
