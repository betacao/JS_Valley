//
//  SHGRecommendView.m
//  Finance
//
//  Created by changxicao on 16/5/27.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGRecommendCollectionView.h"
#import "SHGRecommendCollectionViewCell.h"
#import "SHGRecommendManager.h"
#import "SHGDiscoveryManager.h"
#import "SHGDiscoveryDisplayViewController.h"
#import "SHGDiscoveryViewController.h"

#define kCellWidth MarginFactor(170.0f)
#define kCellHeight MarginFactor(125.0f)
#define kCellMargin MarginFactor(12.0f)

@interface SHGRecommendCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *redLineView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) SHGCategoryButton *inviteButton;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;


@end

@implementation SHGRecommendCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (CGFloat)totalHeight
{
    CGFloat height = CGRectGetHeight(self.topView.frame) + ceilf(self.dataArray.count / 2) * (kCellMargin + kCellHeight);
    return height;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (void)setHideInvateButton:(BOOL)hideInvateButton
{
    _hideInvateButton = hideInvateButton;

    self.inviteButton.hidden = hideInvateButton;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _collectionViewFlowLayout;
}

- (void)initView
{
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SHGRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SHGRecommendCollectionViewCell"];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.topView = [[UIView alloc] init];

    self.redLineView = [[UIView alloc] init];
    self.redLineView.backgroundColor = Color(@"d43b37");

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FontFactor(14.0f);
    self.titleLabel.textColor = Color(@"161616");
    self.titleLabel.text = @"人脉，优质业务的源泉";

    self.inviteButton = [SHGCategoryButton buttonWithType:UIButtonTypeCustom];
    [self.inviteButton setTitleColor:Color(@"eeae01") forState:UIControlStateNormal];
    [self.inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    self.inviteButton.titleLabel.font = FontFactor(13.0f);
    self.inviteButton.hidden = YES;
    [self.inviteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    SHGDiscoveryObject *object = [[SHGDiscoveryObject alloc] init];
    object.industryNum = @"0";
    object.industryName = self.inviteButton.currentTitle;
    self.inviteButton.object = object;


    [self sd_addSubviews:@[self.collectionView, self.topView]];
    [self.topView sd_addSubviews:@[self.redLineView, self.titleLabel, self.inviteButton]];
}

- (void)addAutoLayout
{
    self.collectionView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .bottomSpaceToView(self, 0.0f)
    .topSpaceToView(self.topView, 0.0f);

    self.topView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, 0.0f)
    .heightIs(MarginFactor(57.0f) - kCellMargin);

    self.redLineView.sd_layout
    .leftSpaceToView(self.topView, MarginFactor(12.0f))
    .widthIs(MarginFactor(2.0f))
    .heightIs(MarginFactor(11.0f))
    .centerYEqualToView(self.titleLabel);

    self.titleLabel.sd_layout
    .leftSpaceToView(self.redLineView, MarginFactor(10.0f))
    .topSpaceToView(self.topView, (MarginFactor(57.0f) -  self.titleLabel.font.lineHeight)/ 2)
    .rightSpaceToView(self.topView, 0.0f)
    .heightIs(self.titleLabel.font.lineHeight);

    CGSize size = [self.inviteButton sizeThatFits:CGSizeMake(SCREENWIDTH, SCREENWIDTH)];
    self.inviteButton.sd_layout
    .rightSpaceToView(self.topView, MarginFactor(12.0f))
    .topEqualToView(self.redLineView)
    .heightIs(self.inviteButton.titleLabel.font.lineHeight)
    .widthIs(size.width);
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)buttonClick:(SHGCategoryButton *)button
{
    SHGDiscoveryDisplayViewController *controller = [[SHGDiscoveryDisplayViewController alloc] init];
    controller.object = button.object;
    [[SHGDiscoveryViewController sharedController].navigationController pushViewController:controller animated:YES];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHGRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHGRecommendCollectionViewCell" forIndexPath:indexPath];
    cell.object = [self.dataArray objectAtIndex:indexPath.item];
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth, kCellHeight);
}

//定义每个UICollectionViewCell 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCellMargin, kCellMargin, kCellMargin, kCellMargin);
}

@end
