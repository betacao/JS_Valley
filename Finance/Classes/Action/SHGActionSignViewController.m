//
//  SHGActionSignViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignViewController.h"
#import "SHGActionSignTableViewCell.h"

#define k
@interface SHGActionSignViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionInLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionIntroduceLabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation SHGActionSignViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已报名";
    UIImage *image = self.titleBgView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
    [self loadUI];
}

- (void)loadUI
{
    self.titleLabel.text = self.object.theme;
    self.actionPositionLabel.text = self.object.meetArea;
    self.actionTotalLabel.text = self.object.meetNum;
    self.actionInLabel.text = self.object.attendNum;
    self.actionIntroduceLabel.text = self.object.detail;
    //设置详情的高度
    CGSize size = [self.actionIntroduceLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.actionIntroduceLabel.frame), MAXFLOAT)];
    CGRect frame = self.actionIntroduceLabel.frame;
    frame.size.height = size.height + 2 * kObjectMargin;
    self.actionIntroduceLabel.frame = frame;
    //设置查看全部的高度
    frame = self.bottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.actionIntroduceLabel.frame);
    self.bottomView.frame = frame;
    //设置headerview的高度
    frame = self.headerView.frame;
    frame.size.height = CGRectGetMaxY(self.bottomView.frame);
    self.headerView.frame = frame;

    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.object.attendNum integerValue];
    count = count > 3 ? 3: count;
    return count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionSignTableViewCell";
    SHGActionSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionSignTableViewCell" owner:self options:nil] lastObject];
        
    }
    [cell loadCellWithDictionary:[self.object.attendList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kActionSignCellHeight;
}
@end
