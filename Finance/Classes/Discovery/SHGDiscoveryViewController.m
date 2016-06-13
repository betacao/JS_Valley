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
#import "SHGDiscoverySearchViewController.h"
#import "SHGDiscoveryGroupingViewController.h"
#import "SHGDiscoveryDisplayViewController.h"
#import "SHGRecommendCollectionView.h"

@interface SHGDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *recommendCell;
@property (strong, nonatomic) SHGDiscoveryMyContactCell *myContactCell;
@property (strong, nonatomic) SHGDiscoveryContactExpandCell *contactExpandCell;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SHGRecommendCollectionView *recommendCollectionView;

@property (strong, nonatomic) NSArray *recommendContactArray;
@end

@implementation SHGDiscoveryViewController

+ (instancetype)sharedController
{
    static SHGDiscoveryViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)initView
{
    self.myContactCell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryMyContactCell" owner:self options:nil] lastObject];

    self.contactExpandCell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryContactExpandCell" owner:self options:nil] lastObject];

    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;

    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (void)addAutoLayout
{
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, 0.0f, kTabBarHeight, 0.0f));
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kNavBarTitleFontSize];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"发现";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (SHGRecommendCollectionView *)recommendCollectionView
{
    if (!_recommendCollectionView) {
        _recommendCollectionView = [[SHGRecommendCollectionView alloc] init];
        _recommendCollectionView.scrollEnabled = NO;
        [self.recommendCell.contentView addSubview:_recommendCollectionView];
        _recommendCollectionView.sd_layout
        .spaceToSuperView(UIEdgeInsetsZero);
    }
    return _recommendCollectionView;
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    [self.recommendContactArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SHGDiscoveryRecommendObject class]]) {
            SHGDiscoveryRecommendObject *recommendObject = (SHGDiscoveryRecommendObject *)obj;
            if ([recommendObject.userID isEqualToString:targetUserID]) {
                recommendObject.isAttention = attationState;
            }
        }
    }];
    [self.recommendCollectionView reloadData];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SHGDiscoveryManager loadDiscoveryData:@{@"uid":UID} block:^(NSArray *firstArray, NSArray *secondArray) {
        weakSelf.recommendContactArray = nil;
        if ([self isViewLoaded]) {
            if (firstArray.count > 0) {
                weakSelf.myContactCell.effctiveArray = [[NSArray alloc] initWithArray:firstArray copyItems:YES];
                weakSelf.myContactCell.hideInvateButton = [SHGDiscoveryManager shareManager].hideInvateButton;
            } else {
                weakSelf.recommendContactArray = [NSArray arrayWithArray:secondArray];
                weakSelf.recommendCollectionView.dataArray = weakSelf.recommendContactArray;
                weakSelf.recommendCollectionView.hideInvateButton = [SHGDiscoveryManager shareManager].hideInvateButton;
            }
            [weakSelf.tableView reloadData];
        }
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.section == 0) {
        if (self.recommendContactArray) {
            height = self.recommendCollectionView.totalHeight;
            return height;
        } else {
            height = [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[SHGDiscoveryMyContactCell class] contentViewWidth:SCREENWIDTH];
            return height;
        }
    } else {
        height = [tableView cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:[SHGDiscoveryContactExpandCell class] contentViewWidth:SCREENWIDTH];
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.recommendContactArray) {
            return self.recommendCell;
        } else {
            return self.myContactCell;
        }
    } else {
        return self.contactExpandCell;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SHGDiscoverySearchViewController *controller = [[SHGDiscoverySearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end



#pragma mark ------我的人脉------
@interface SHGDiscoveryMyContactCell()

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet SHGCategoryButton *inviteButton;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SHGDiscoveryMyContactCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
    [self addButtons];
}

- (void)initView
{
    self.buttonView.backgroundColor = Color(@"efecee");

    self.redLineView.backgroundColor = Color(@"d43b37");

    self.titleLabel.font = FontFactor(14.0f);
    self.titleLabel.textColor = Color(@"161616");
    self.titleLabel.text = @"我的人脉";

    self.bottomView.backgroundColor = Color(@"efeeef");

    [self.inviteButton setTitleColor:Color(@"eeae01") forState:UIControlStateNormal];
    [self.inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    self.inviteButton.titleLabel.font = FontFactor(13.0f);
    self.inviteButton.hidden = YES;
    [self.inviteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    SHGDiscoveryObject *object = [[SHGDiscoveryObject alloc] init];
    object.industryNum = @"0";
    object.industryName = self.inviteButton.currentTitle;
    self.inviteButton.object = object;

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

    CGSize size = [self.inviteButton sizeThatFits:CGSizeMake(SCREENWIDTH, SCREENWIDTH)];
    self.inviteButton.sd_layout
    .rightSpaceToView(self.topView, MarginFactor(12.0f))
    .centerYEqualToView(self.topView)
    .heightRatioToView(self.topView, 1.0f)
    .widthIs(size.width);
}

- (void)addButtons
{
    NSArray *array = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"SHGIndustry" ofType:@"plist"]];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        SHGDiscoveryObject *object = [[SHGDiscoveryObject alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"discovery_%@", [[dictionary allValues] firstObject]];
        UIImage *image = [UIImage imageNamed:imageName];
        object.industryImage = image;
        object.industryNum = @"0";
        object.industryName = [[dictionary allKeys] firstObject];
        object.industry =[[dictionary allValues] firstObject];
        [self.dataArray addObject:object];
    }];

    CGFloat width = (SCREENWIDTH - 2 * 1 / SCALE) / 3;
    UIButton *lastButton = nil;
    for (SHGDiscoveryObject *object in self.dataArray) {
        SHGDiscoveryCategoryButton *button = [SHGDiscoveryCategoryButton buttonWithType:UIButtonTypeCustom];
        NSInteger index = [self.dataArray indexOfObject:object];
        NSInteger row = index / 3;
        NSInteger col = index % 3;
        CGRect frame = CGRectMake(col * (width + 1 / SCALE), row * (1 / SCALE + width) + 1 / SCALE, width, width);
        button.frame = frame;
        button.object = object;
        [self.buttonView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    //先做一次清空 然后再赋值
    for (SHGDiscoveryCategoryButton *button in self.buttonView.subviews) {
        SHGDiscoveryObject *object = button.object;
        object.industryNum = @"0";
    }
    for (SHGDiscoveryObject *object in effctiveArray) {
        if ([self.dataArray containsObject:object]) {
            SHGDiscoveryCategoryButton *button = [self.buttonView.subviews objectAtIndex:[self.dataArray indexOfObject:object]];
            button.object = object;
        }
    }
}

- (void)setHideInvateButton:(BOOL)hideInvateButton
{
    _hideInvateButton = hideInvateButton;

    self.inviteButton.hidden = hideInvateButton;
}

- (void)buttonClick:(SHGDiscoveryCategoryButton *)button
{
    SHGDiscoveryDisplayViewController *controller = [[SHGDiscoveryDisplayViewController alloc] init];
    controller.object = button.object;
    [[SHGDiscoveryViewController sharedController].navigationController pushViewController:controller animated:YES];
}


@end




#pragma mark ------人脉拓展------
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
    self.titleLabel.textColor = Color(@"161616");
    self.titleLabel.text = @"人脉拓展";

    self.leftButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"行业" attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName:Color(@"161616")}];
        [self.leftButton setAttributedTitle:title image:[UIImage imageNamed:@"discovery_department"]];
    };
    self.rightButton.didFinishAutoLayoutBlock = ^(CGRect rect){
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"地区" attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName:Color(@"161616")}];
        [self.rightButton setAttributedTitle:title image:[UIImage imageNamed:@"discovery_location"]];
    };

    SHGDiscoveryIndustryObject *leftObject = [[SHGDiscoveryIndustryObject alloc] init];
    leftObject.moduleType = SHGDiscoveryGroupingTypeIndustry;
    self.leftButton.object = leftObject;
    [self.leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    SHGDiscoveryIndustryObject *rightObject = [[SHGDiscoveryIndustryObject alloc] init];
    rightObject.moduleType = SHGDiscoveryGroupingTypePosition;
    self.rightButton.object = rightObject;
    [self.rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)buttonClick:(SHGDiscoveryCategoryButton *)button
{
    SHGDiscoveryGroupingViewController *controller = [[SHGDiscoveryGroupingViewController alloc] init];
    controller.object = button.object;
    [[SHGDiscoveryViewController sharedController].navigationController pushViewController:controller animated:YES];
}

@end


#pragma mark ------发现的首页按钮------
@interface SHGDiscoveryCategoryButton()

@end

@implementation SHGDiscoveryCategoryButton

- (void)setAttributedTitle:(NSAttributedString *)title image:(UIImage *)image
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self setAttributedTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
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
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.imageEdgeInsets)) {
        self.imageEdgeInsets = imageEdgeInsets;
    }

    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.titleEdgeInsets)) {
        self.titleEdgeInsets = titleEdgeInsets;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        CGRect frame = view.frame;
        frame = [self convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
        frame.origin.x = ceilf(frame.origin.x);
        frame.origin.y = ceilf(frame.origin.y);
        frame.size.width = ceilf(frame.size.width);
        frame.size.height = ceilf(frame.size.height);
        frame = [self convertRect:frame fromView:[UIApplication sharedApplication].keyWindow];
        view.frame = frame;
    }
}

- (void)setObject:(id)object
{
    if ([object isKindOfClass:[SHGDiscoveryObject class]]) {
        SHGDiscoveryObject *discoveryObject = (SHGDiscoveryObject *)object;

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = MarginFactor(4.0f);
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[discoveryObject.industryName stringByAppendingFormat:@"\n%@", discoveryObject.industryNum] attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName:Color(@"161616"), NSParagraphStyleAttributeName:style}];

        [title addAttributes:@{NSFontAttributeName:FontFactor(10.0f), NSForegroundColorAttributeName:Color(@"999999")} range:[title.string rangeOfString:discoveryObject.industryNum]];
        
        [self setAttributedTitle:title image:discoveryObject.industryImage];
    }
    _object = object;
}

@end
