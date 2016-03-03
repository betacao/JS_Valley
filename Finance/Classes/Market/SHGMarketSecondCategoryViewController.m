//
//  SHGMarketSecondCategoryViewController.m
//  Finance
//
//  Created by changxicao on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSecondCategoryViewController.h"
#import "SHGMarketObject.h"
#import "SHGMarketListViewController.h"
#import "SHGSecondCategoryButton.h"
#import "SHGMarketManager.h"

#define kItemTopMargin  MarginFactor(14.0f)
#define kItemMargin MarginFactor(16.0f)
#define kItemHeight MarginFactor(35.0f)
#define kItemLeftMargin  MarginFactor(11.0f)
#define kSectionHeight MarginFactor(40.0f)
#define kTitleToTop  MarginFactor(15.0f)
@interface SHGMarketSecondCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *categoryArray;
@property (nonatomic , assign) NSInteger RowHeight;
@property (nonatomic , assign) NSInteger firstCategoryIndex;
@property (nonatomic , strong) NSMutableArray *cellArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *haveSelectedArray;
@end

@implementation SHGMarketSecondCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"自定义业务";
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:FontFactor(15.0f)];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEFF0"];
    [self createCell];
}

- (void)createCell
{    __weak typeof(self) weakSelf = self;
    [[SHGMarketManager shareManager] userSelectedArray:^(NSArray *array) {
        [weakSelf.haveSelectedArray addObjectsFromArray:array];
    }];
    [[SHGMarketManager shareManager] userListArray:^(NSArray *array) {
        self.categoryArray = [NSMutableArray arrayWithArray:array];
        CGFloat width = ceilf((SCREENWIDTH - 2 * kItemMargin - 2 * kItemLeftMargin) / 3.0f);
        for (NSInteger i = 0 ; i < self.categoryArray.count; i ++ ) {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor = [UIColor colorWithHexString:@"EEEFF0"];
            SHGMarketFirstCategoryObject * object = [self.categoryArray objectAtIndex:i];
            [self.cellArray addObject:cell];
            for (NSInteger j = 0 ; j < object.secondCataLogs.count; j ++) {
                NSInteger row = j / 3;
                NSInteger col = j % 3;
                SHGMarketSecondCategoryObject *obj = [object.secondCataLogs objectAtIndex:j];
                SHGSecondCategoryButton *button = [SHGSecondCategoryButton buttonWithType:UIButtonTypeCustom];
                button.selected = NO;
                button.secondId = obj.secondCatalogId;
                for (SHGMarketSelectedObject *object in self.haveSelectedArray) {
                    if ([button.secondId isEqualToString:object.catalogId]) {
                        [self.selectedArray addObject:object.catalogId];
                        button.selected = YES;
                    }
                }
                button.adjustsImageWhenHighlighted = NO;
                button.titleLabel.font = FontFactor(14.0f);
                [button setTitle:obj.secondCatalogName forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHexString:@"8A8A8A"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHexString:@"FF3232"] forState:UIControlStateSelected];
                UIImage *whiteImage = [[UIImage imageNamed:@"buttonWhiteBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
                [button setBackgroundImage:whiteImage forState:UIControlStateNormal];
                UIImage *grayImage = [[UIImage imageNamed:@"buttonGrayBg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
                [button setBackgroundImage:grayImage forState:UIControlStateSelected];
                [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
                CGRect frame = CGRectMake(kItemLeftMargin + (kItemMargin + width) * col, ceilf((kItemTopMargin + kItemHeight) * row + kItemTopMargin), width, kItemHeight);
                button.frame = frame;
                [cell.contentView addSubview:button];

            }
        }

    }];

}

- (void)finishButton:(UIButton * )btn
{
    __weak typeof(self) weakSelf= self;
    NSString * string = @"";
    for (NSString *str  in self.selectedArray) {
        string = [string stringByAppendingFormat:@"%@,",str];
    }
    NSDictionary *param = @{@"uid":UID ,@"catalogIds":string};
    [SHGMarketManager uploadUserMarket:param block:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didUploadUserCategoryTags:)]) {
            [weakSelf.delegate didUploadUserCategoryTags:weakSelf.selectedArray];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];


}

- (void)didSelectCategory:(SHGSecondCategoryButton *)btn
{
    if (btn.selected == NO) {
        btn.selected = YES;
        [self.selectedArray addObject:btn.secondId];
    } else{
        if ([self.selectedArray indexOfObject:btn.secondId] != NSNotFound) {
            [self.selectedArray removeObject:btn.secondId];
            btn.selected = NO;
        }
    }
}

-(NSMutableArray * )haveSelectedArray
{
    if (!_haveSelectedArray) {
        _haveSelectedArray = [NSMutableArray array];
    }
    return _haveSelectedArray;
}

- (NSMutableArray *)cellArray
{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark -- tableView--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryArray.count ;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SHGMarketFirstCategoryObject * object = [self.categoryArray objectAtIndex:section];
    if ( object.secondCataLogs.count > 0) {
        return  1;
    } else{
        return 0;
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.cellArray objectAtIndex:indexPath.section ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)secondCategoryClick: (SHGSecondCategoryButton * )btn
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    SHGMarketFirstCategoryObject * objf = [self.categoryArray objectAtIndex:indexPath.section];
    NSInteger row = (NSInteger)ceilf(objf.secondCataLogs.count / 3.0f);
    height = (kItemTopMargin + kItemHeight) * row + kItemTopMargin;
    return height;
}

- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kSectionHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"EEEFF0"];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(kItemMargin, kTitleToTop, SCREENWIDTH, kSectionHeight - kTitleToTop)];
    title.backgroundColor = [UIColor clearColor];
     SHGMarketFirstCategoryObject * obj = [self.categoryArray objectAtIndex:section];
    title.text = obj.firstCatalogName;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = FontFactor(15.0f);
    title.textColor = [UIColor colorWithHexString:@"161616"];
    [view addSubview:title];
    return view;
}


@end
