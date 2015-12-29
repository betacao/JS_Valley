//
//  SHGMarketDetailViewController.m
//  Finance
//
//  Created by changxicao on 15/12/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketDetailViewController.h"
#import "SHGMarketTableViewCell.h"
#import "CircleLinkViewController.h"
#import "SHGMarketManager.h"
#define k_FirstToTop 5.0f * XFACTOR
#define k_SecondToTop 10.0f * XFACTOR
#define k_ThirdToTop 15.0f * XFACTOR

@interface SHGMarketDetailViewController ()
//界面
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *praiseView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnZan;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
//数据
@property (strong, nonatomic) SHGMarketObject *responseObject;

- (IBAction)zan:(id)sender;
- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;



@end

@implementation SHGMarketDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务详情";
    self.detailTable.delegate = self;
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":self.object.marketId ,@"uid":UID};
    [SHGMarketManager loadMarketDetail:param block:^(SHGMarketObject *object) {
        weakSelf.responseObject = object;
        [weakSelf loadUi];
    }];
}


- (void)loadUi
{
    NSString *title = @"还是领导是卡卡还撒谎时刻会拉丝看哈飒飒的很快会拉的啥都说了是打开后骄傲的上课讲两句话；给付额爱回家啊撒了点就好的撒了解到撒垃圾的撒";
    self.titleLabel.text = title;
    CGSize tsize =CGSizeMake(self.titleLabel.frame.size.width,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  actualsize =[title boundingRectWithSize:tsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    self.titleLabel.height = actualsize.height;
    //控件位置
    self.typeLabel.frame = CGRectMake(self.typeLabel.origin.x, CGRectGetMaxY(self.titleLabel.frame)+k_SecondToTop, self.typeLabel.width, self.typeLabel.height);
    self.capitalLabel.frame = CGRectMake(self.capitalLabel.origin.x, CGRectGetMaxY(self.titleLabel.frame)+k_SecondToTop, self.capitalLabel.width, self.capitalLabel.height);
    self.phoneNumLabel.frame =CGRectMake(self.phoneNumLabel.origin.x, CGRectGetMaxY(self.typeLabel.frame)+k_FirstToTop, self.phoneNumLabel.width, self.phoneNumLabel.height);
    self.secondHorizontalLine.frame = CGRectMake(self.secondHorizontalLine.origin.x, CGRectGetMaxY(self.phoneNumLabel.frame)+k_ThirdToTop, self.secondHorizontalLine.width, self.secondHorizontalLine.height);
    self.marketDetialLabel.frame = CGRectMake(self.detailContentLabel.origin.x, CGRectGetMaxY(self.secondHorizontalLine.frame)+k_ThirdToTop, self.marketDetialLabel.width, self.marketDetialLabel.height);
    self.thirdHorizontalLine.frame = CGRectMake(self.thirdHorizontalLine.origin.x, CGRectGetMaxY(self.marketDetialLabel.frame)+k_ThirdToTop, self.thirdHorizontalLine.width, self.thirdHorizontalLine.height);
    //内容详情
    NSString *detail = @"还是领导是卡卡还撒谎时刻会拉丝看哈飒飒的很快会拉的啥都说了是打开后骄傲的上课讲两句话；给付额爱回家啊撒了点就好的撒了解到撒垃圾的撒";
    self.detailContentLabel.text = detail;
    CGSize dsize =CGSizeMake(self.detailContentLabel.frame.size.width,MAXFLOAT);
    NSDictionary * ddic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  dActualsize =[title boundingRectWithSize:dsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:ddic context:nil].size;
     self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.origin.x, CGRectGetMaxY(self.thirdHorizontalLine.frame)+ k_ThirdToTop, self.detailContentLabel.width, dActualsize.height);
   
    self.photoImageView.frame  = CGRectMake(self.photoImageView.origin.x, CGRectGetMaxY(self.detailContentLabel.frame)+k_FirstToTop, self.photoImageView.width, self.photoImageView.height);
   //图片
    
    self.actionView.frame = CGRectMake(self.actionView.origin.x, CGRectGetMaxY(self.photoImageView.frame)+k_FirstToTop, self.actionView.width, self.actionView.height);
    [self.btnZan setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.btnZan setTitle:@"111" forState:UIControlStateNormal];
    
    [self.btnComment setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.btnComment setTitle:@"222" forState:UIControlStateNormal];
    [self.btnShare setImage:[UIImage imageNamed:@"shareImage"] forState:UIControlStateNormal];
    [self.btnShare setTitle:@"333" forState:UIControlStateNormal];
    
    self.praiseView.frame = CGRectMake(self.praiseView.origin.x, CGRectGetMaxY(self.actionView.frame)+k_FirstToTop, self.praiseView.width, self.praiseView.height);
    //image处理边帽
    UIImage *image = self.backImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;
    
    
    
    
}
#pragma mark ----tableView----

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString * identifier = @"SHGMarketTableViewCell";
    SHGMarketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SHGMarketTableViewCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark ----btnClick---

- (IBAction)zan:(id)sender {
}

- (IBAction)comment:(id)sender {
}

- (IBAction)share:(id)sender {
}
@end
