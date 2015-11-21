//
//  SHGActionSignViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignViewController.h"
#import "SHGActionSignTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGActionManager.h"

#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 30.0f

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
@property (weak, nonatomic) IBOutlet UIImageView *footerBgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *praiseScrollView;
@property (weak, nonatomic) IBOutlet UIView *praiseView;
@property (weak, nonatomic) IBOutlet UIButton *viewTotalButton;
@property (weak, nonatomic) IBOutlet UIButton *addPrasiseButton;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
@property (assign, nonatomic) CGFloat height;
@end

@implementation SHGActionSignViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.height == 0) {
        UIImage *image = self.titleBgView.image;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
        [self loadUI];
    }
}

- (void)refreshUI
{
    [self loadUI];
}

- (CGFloat)heightForView
{
    return CGRectGetHeight(self.tableView.frame);
}

- (void)loadUI
{
    self.titleLabel.text = self.object.theme;
    self.actionPositionLabel.text = self.object.meetArea;
    self.actionTotalLabel.text = self.object.meetNum;
    self.actionInLabel.text = self.object.attendNum;
    self.actionIntroduceLabel.text = self.object.detail;

    CGSize size = self.viewTotalButton.imageView.image.size;
    [self.viewTotalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -size.width * 2, 0, size.width * 2)];
    [self.viewTotalButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.viewTotalButton.titleLabel.bounds.size.width, 0, -self.viewTotalButton.titleLabel.bounds.size.width)];
    //设置详情的高度
    size = [self.actionIntroduceLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.actionIntroduceLabel.frame), MAXFLOAT)];
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
    [self loadFooterUI];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    //设置tableview和self.view的高度
    frame = self.tableView.frame;
    CGPoint point = CGPointMake(0.0f, CGRectGetMaxY(self.footerView.frame));
    frame.size.height = point.y;
    self.tableView.frame = frame;
    self.view.frame = frame;
    [self loadPraiseButtonState];
    [self loadCommentButtonState];

    if (self.finishBlock) {
        self.height = CGRectGetHeight(frame);
        self.finishBlock(self.height);
    }
}

- (void)loadPraiseButtonState
{
    //设置点赞的状态
    if ([self.object.isPraise isEqualToString:@"N"]) {
        [self.addPrasiseButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.addPrasiseButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    [self.addPrasiseButton setTitle:self.object.praiseNum forState:UIControlStateNormal];
}

- (void)loadCommentButtonState
{
    [self.addCommentButton setTitle:self.object.commentNum forState:UIControlStateNormal];
}

- (void)loadFooterUI
{
    UIImage *image = self.footerBgImageView.image;
    self.footerBgImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];

    CGRect praiseRect = self.praiseView.frame;
    CGFloat praiseWidth = 0;
    if ([self.object.praiseNum integerValue] > 0){
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:self.object.praiseList class:[praiseOBj class]];
        for (NSInteger i = 0; i < array.count; i++) {
            praiseOBj *obj = [array objectAtIndex:i];
            praiseWidth = PRAISE_WIDTH;
            CGRect rect = CGRectMake((praiseWidth + PRAISE_SEPWIDTH) * i , (CGRectGetHeight(praiseRect) - praiseWidth) / 2.0f, praiseWidth, praiseWidth);
            UIImageView *head = [[UIImageView alloc] initWithFrame:rect];
            head.tag = [obj.puserid integerValue];
            [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname]] placeholderImage:[UIImage imageNamed:@"default_head"]];
            head.userInteractionEnabled = YES;
            DDTapGestureRecognizer *recognizer = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToUserCenter:)];
            [head addGestureRecognizer:recognizer];
            [self.praiseScrollView addSubview:head];
        }
        [self.praiseScrollView setContentSize:CGSizeMake(array.count * (praiseWidth + PRAISE_SEPWIDTH), CGRectGetHeight(self.praiseScrollView.frame))];
    } else{
        [self.praiseScrollView removeAllSubviews];
    }
}

- (void)moveToUserCenter:(UITapGestureRecognizer *)recognizer
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] init];
    controller.userId = [NSString stringWithFormat:@"%ld",(long)recognizer.view.tag];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------查看全部
- (IBAction)viewTotalParticipant:(id)sender
{

}

#pragma mark ------点赞
- (IBAction)addPraiseClick:(id)sender
{
    __weak typeof(self)weakSelf = self;
    if ([self.object.isPraise isEqualToString:@"N"]) {
        [[SHGActionManager shareActionManager] addPraiseWithObject:self.object finishBlock:^(BOOL success) {
            [weakSelf loadPraiseButtonState];
        }];
    } else{
        [[SHGActionManager shareActionManager] deletePraiseWithObject:self.object finishBlock:^(BOOL success) {
            [weakSelf loadPraiseButtonState];
        }];
    }
}

#pragma mark ------tableViewDelegate
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell loadCellWithDictionary:[self.object.attendList objectAtIndex:indexPath.row]];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kActionSignCellHeight;
}
@end
