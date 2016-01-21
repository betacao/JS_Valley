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

#define k_ToleftOne 11.0f * XFACTOR
#define k_ToleftTwo 21.0f * XFACTOR
#define k_SectionHeight 40

#define kItemTopMargin  10.0f * XFACTOR
#define kItemMargin 14.0f * XFACTOR
#define kItemHeight 30.0f * XFACTOR
#define kItemLeftMargin  11.0f

@interface SHGMarketSecondCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *categoryArray;
@property (nonatomic , assign) NSInteger RowHeight;
@property (nonatomic , assign) NSInteger firstCategoryIndex;
@property (nonatomic , strong) NSMutableArray *cellArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
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
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f *XFACTOR]];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EEEFF0"];
    [[SHGMarketManager shareManager] userListArray:^(NSArray *array) {
        self.categoryArray = array;
    
        CGFloat width = (SCREENWIDTH - 2 * kItemMargin - 2 * kItemLeftMargin) / 3.0f;
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
                button.layer.cornerRadius = 1.0f;
                button.layer.borderWidth = 0.5f;
                button.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF"].CGColor;
                button.titleLabel.font = [UIFont systemFontOfSize:13.0f * XFACTOR];
                [button setTitle:obj.secondCatalogName forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHexString:@"8A8A8A"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHexString:@"FF3232"] forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F3F3F3"]] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
                CGRect frame = CGRectMake(ceilf(kItemLeftMargin + (kItemMargin + width) * col), ceilf(kItemTopMargin + (kItemMargin + kItemHeight) * row), ceilf(width), ceilf(kItemHeight));
                button.frame = frame;
                [cell.contentView addSubview:button];
                
            }
        }
        
    }];
}
//- (void)updateSelectedArray
//{
//    NSArray *selectedArray = [SHGGloble sharedGloble].selectedTagsArray;
//    NSArray *tagsArray = [SHGGloble sharedGloble].tagsArray;
//    [self.selectedArray removeAllObjects];
//    [self clearButtonState];
//    for(SHGUserTagModel *model in selectedArray){
//        NSInteger index = [tagsArray indexOfObject:model];
//        NSLog(@"......%ld",(long)index);
//        [self.selectedArray addObject:@(index)];
//        UIButton *button = [self.buttonArray objectAtIndex:index];
//        if(button){
//            [button setSelected:YES];
//        }
//    }
//}
//
//- (void)didSelectCategory:(UIButton *)button
//{
//    BOOL isSelecetd = button.selected;
//    NSInteger index = [self.categoryArray indexOfObject:button];
//    if(!isSelecetd){
//        if(self.selectedArray.count >= 3){
//            [Hud showMessageWithText:@"最多选3项"];
//        } else{
//            button.selected = !isSelecetd;
//            [self.selectedArray addObject:@(index)];
//        }
//    } else{
//        button.selected = !isSelecetd;
//        [self.selectedArray removeObject:@(index)];
//    }
//}
//
//- (void)clearButtonState
//{
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if([obj isKindOfClass:[UIButton class]]){
//            UIButton *button = (UIButton *)obj;
//            [button setSelected:NO];
//        }
//    }];
//}

//- (NSArray *)userSelectedTags
//{
//    return self.selectedArray;
//}

- (void)finishButton:(UIButton * )btn
{
    __weak typeof(self) weakSelf= self;
    NSString * string = @"";
    for (NSString *str  in self.selectedArray) {
        string = [string stringByAppendingFormat:@"%@,",str];
    }
    if (string.length > 0) {
        string = [string substringToIndex:string.length - 1];
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

-(NSArray * )categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSArray array];
    }
    return _categoryArray;
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
    return  1;
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
    return k_SectionHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    SHGMarketFirstCategoryObject * objf = [self.categoryArray objectAtIndex:indexPath.section];
    height = objf.secondCataLogs.count / 3.0f * (2 * kItemTopMargin + kItemHeight);
    
    return height;
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger sectionHeight = 50.0f;
    NSInteger titleToTop = 20.0f;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, sectionHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"EEEFF0"];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(k_ToleftOne, titleToTop, 100.0f, 20.0f)];
    title.backgroundColor = [UIColor clearColor];
     SHGMarketFirstCategoryObject * obj = [self.categoryArray objectAtIndex:section];
    title.text = obj.firstCatalogName;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:14.0F];
    title.textColor = [UIColor colorWithHexString:@"161616"];
    [view addSubview:title];
    return view;
}


@end
