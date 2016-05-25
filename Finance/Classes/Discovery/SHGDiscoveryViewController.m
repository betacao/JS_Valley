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
#import "SHGDiscoveryObject.h"

@interface SHGDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SHGDiscoveryMyContactCell *myContactCell;
@property (strong, nonatomic) SHGDiscoveryContactExpandCell *contactExpandCell;
@property (strong, nonatomic) EMSearchBar *searchBar;
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

    __weak typeof(self) weakSelf = self;
    [SHGDiscoveryManager loadDiscoveryData:@{@"uid":UID} block:^(NSArray *dataArray) {
        weakSelf.myContactCell.effctiveArray = [NSArray arrayWithArray:dataArray];
    }];
}

- (void)initView
{
    self.myContactCell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryMyContactCell" owner:self options:nil] lastObject];
    self.myContactCell.controller = self;

    self.contactExpandCell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryContactExpandCell" owner:self options:nil] lastObject];

    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, kTabBarHeight, 0.0f));
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.row == 0) {
        height = [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[SHGDiscoveryMyContactCell class] contentViewWidth:SCREENWIDTH];
        return height;
    } else {
        height = [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[SHGDiscoveryContactExpandCell class] contentViewWidth:SCREENWIDTH];
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.myContactCell;
    } else {
        return self.contactExpandCell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@interface SHGDiscoveryMyContactCell()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation SHGDiscoveryMyContactCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
    [self addSubButtons];
}

- (void)initView
{
    self.buttonView.backgroundColor = Color(@"efecee");
    self.redLineView.backgroundColor = Color(@"d43b37");
    self.titleLabel.font = FontFactor(14.0f);
    self.titleLabel.text = @"我的人脉";
    self.bottomView.backgroundColor = Color(@"efeeef");
    self.dataArray = [NSMutableArray array];
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
}

- (void)addSubButtons
{
    NSDictionary *dictionay = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"SHGIndustry" ofType:@"plist"]];
    [dictionay enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        SHGDiscoveryObject *object = [[SHGDiscoveryObject alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"discovery_%@", value];
        UIImage *image = [UIImage imageNamed:imageName];
        object.industryImage = image;
        object.industryNum = @"1170";
        object.industryName = key;
        [self.dataArray addObject:object];
    }];
    CGFloat width = (SCREENWIDTH - 2 * 1 / SCALE) / 3;
    UIButton *lastButton = nil;
    for (SHGDiscoveryObject *object in self.dataArray) {
        SHGDiscoveryCategoryButton *button = [SHGDiscoveryCategoryButton buttonWithType:UIButtonTypeCustom];
        NSInteger index = [self.dataArray indexOfObject:object];
        NSInteger row = index % 3;
        NSInteger col = index / 3;
        CGRect frame = CGRectMake(col * (width + 1 / SCALE), row * (1 / SCALE + width) + 1 / SCALE, width, width);
        button.frame = frame;
        [self.buttonView addSubview:button];

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = MarginFactor(4.0f);
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[object.industryName stringByAppendingFormat:@"\n%@", object.industryNum] attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName:style}];

        [title addAttributes:@{NSFontAttributeName:FontFactor(9.0f), NSForegroundColorAttributeName:Color(@"999999")} range:[title.string rangeOfString:object.industryNum]];

        [button setAttributedTitle:title image:object.industryImage];
        lastButton = button;
    }
    if (!lastButton) {
        lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonView addSubview:lastButton];
    }

    self.buttonView.sd_layout
    .topSpaceToView(self.topView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f);
    [self.buttonView setupAutoHeightWithBottomView:lastButton bottomMargin:1 / SCALE];

    self.bottomView.sd_layout
    .topSpaceToView(self.buttonView, MarginFactor(20.0f))
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(10.0f));

    [self setupAutoHeightWithBottomView:self.bottomView bottomMargin:0.0f];
}

- (void)setEffctiveArray:(NSArray *)effctiveArray
{
    _effctiveArray = effctiveArray;
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
    self.redLineView.backgroundColor = Color(@"d43b37");
    self.titleLabel.font = FontFactor(14.0f);
    self.titleLabel.text = @"人脉拓展";

//    __weak typeof(self)weakSelf = self;
//    self.leftButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        [self.leftButton setTitle:@"行业" image:[UIImage imageNamed:@"discovery_department"]];
//    };
//    self.rightButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        [self.rightButton setTitle:@"地区" image:[UIImage imageNamed:@"discovery_location"]];
//    };
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

    [self setupAutoHeightWithBottomView:self.buttonView bottomMargin:0.0f];
}

@end






@interface SHGDiscoveryContactRecommendView()

@end

@interface SHGDiscoveryCategoryButton()

@end

@implementation SHGDiscoveryCategoryButton

- (void)setAttributedTitle:(NSAttributedString *)title image:(UIImage *)image
{
//    if ([title isEqualToAttributedString:self.titleLabel.attributedText] && [self.currentImage isEqual:image]) {
//        return;
//    }

    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self setAttributedTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self resetInsets];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
//    if ([title isEqualToString:self.titleLabel.text] && [self.currentImage isEqual:image] ) {
//        return;
//    }
    self.titleLabel.font = FontFactor(14.0f);
    self.backgroundColor = [UIColor whiteColor];
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self resetInsets];

}

- (void)resetInsets
{
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
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    self.imageEdgeInsets = imageEdgeInsets;

    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    self.titleEdgeInsets = titleEdgeInsets;
}

@end
