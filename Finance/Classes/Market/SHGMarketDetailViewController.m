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
@property (weak, nonatomic) IBOutlet headerView *headImageView;
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

@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIButton *smileImage;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

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
       [weakSelf loadDate];
       [weakSelf loadUi];
    }];
}

- (void)loadDate
{
    self.timeLabel.text = self.responseObject.createTime;
    if (!self.responseObject.price.length == 0) {
        NSString * zjStr = self.responseObject.price;
        self.capitalLabel.text = [NSString stringWithFormat:@"金额：%@",zjStr];
    }else {
         self.capitalLabel.text = [NSString stringWithFormat:@"金额：暂未说明"];
    }
    NSString * typeStr = self.responseObject.catalog;
    self.typeLabel.text = [NSString stringWithFormat:@"类型： %@",typeStr];
    NSString * pNumStr = self.responseObject.contactInfo;
    self.phoneNumLabel.text = [NSString stringWithFormat:@"电话： %@",pNumStr];
    self.nameLabel.text = self.responseObject.realname;
    self.companyLabel.text = self.responseObject.company;
    self.positionLabel.text = self.responseObject.title;
    [self.headImageView updateStatus:[self.responseObject.status isEqualToString:@"1"] ? YES : NO];
    [self.headImageView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.headimageurl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.detailContentLabel.text = self.responseObject.detail;
   
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.url]]];
   
    
}

- (void)loadUi
{
    CGSize nameSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.nameLabel.frame));
    NSDictionary * nameDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15.0],NSFontAttributeName,nil];
    CGSize  nameActualsize =[self.nameLabel.text boundingRectWithSize:nameSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:nameDic context:nil].size;
    if (nameActualsize.width > 50.f) {
        nameActualsize.width = 50.f;
    }
    self.nameLabel.frame =CGRectMake(self.nameLabel.origin.x,self.nameLabel.origin.y, nameActualsize.width, CGRectGetHeight(self.nameLabel.frame));
    
    self.verticalLine.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+5.0,self.verticalLine.origin.y, self.verticalLine.frame.size.width, CGRectGetHeight(self.verticalLine.frame));
    
    CGSize companySize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.companyLabel.frame));
    NSDictionary * companyDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,nil];
    CGSize  companyActualsize =[self.companyLabel.text boundingRectWithSize:companySize options:NSStringDrawingUsesLineFragmentOrigin  attributes:companyDic context:nil].size;
    if (companyActualsize.width > 90.f) {
        companyActualsize.width = 90.f;
    }
    self.companyLabel.frame =CGRectMake(CGRectGetMaxX(self.verticalLine.frame) + 5.0f,self.companyLabel.origin.y, companyActualsize.width, CGRectGetHeight(self.companyLabel.frame));
    
    CGSize positionSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.positionLabel.frame));
    NSDictionary * positionDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,nil];
    CGSize  positionActualsize =[self.positionLabel.text boundingRectWithSize:positionSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:positionDic context:nil].size;
    if (positionActualsize.width > 90.f) {
        positionActualsize.width = 90.f;
    }
    self.positionLabel.frame =CGRectMake(CGRectGetMaxX(self.companyLabel.frame) + 5.0f,self.positionLabel.origin.y, companyActualsize.width, CGRectGetHeight(self.positionLabel.frame));
    
    CGSize capitalSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.capitalLabel.frame));
    NSDictionary * capitalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,nil];
    CGSize  capitalActualsize =[self.capitalLabel.text boundingRectWithSize:capitalSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:capitalDic context:nil].size;
    if (capitalActualsize.width > 120.f) {
        capitalActualsize.width = 120.f;
    }
    self.capitalLabel.frame =CGRectMake(SCREENWIDTH-capitalActualsize.width-15,self.capitalLabel.origin.y, capitalActualsize.width, CGRectGetHeight(self.positionLabel.frame));

    
    
    NSString *title = self.responseObject.marketName;
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
    
    self.detailContentLabel.numberOfLines = 0;
    CGSize dsize =CGSizeMake(self.detailContentLabel.frame.size.width,MAXFLOAT);
    NSDictionary * ddic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  dActualsize =[self.detailContentLabel.text boundingRectWithSize:dsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:ddic context:nil].size;
     self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.origin.x, CGRectGetMaxY(self.thirdHorizontalLine.frame)+ k_ThirdToTop, self.detailContentLabel.width, dActualsize.height);
    if (!self.responseObject.url.length == 0) {
        self.photoImageView.frame  = CGRectMake(self.photoImageView.origin.x, CGRectGetMaxY(self.detailContentLabel.frame)+k_FirstToTop*2, self.photoImageView.width, self.photoImageView.height);
         self.actionView.frame = CGRectMake(self.actionView.origin.x, CGRectGetMaxY(self.photoImageView.frame)+k_FirstToTop, self.actionView.width, self.actionView.height);
    }else{
        self.photoImageView.hidden = YES;
         self.actionView.frame = CGRectMake(self.actionView.origin.x, CGRectGetMaxY(self.detailContentLabel.frame)+k_FirstToTop, self.actionView.width, self.actionView.height);
    }
    [self.btnZan setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.btnZan setTitle:[NSString stringWithFormat:@"%@",self.responseObject.praiseNum] forState:UIControlStateNormal];
    
    [self.btnComment setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];
    [self.btnShare setImage:[UIImage imageNamed:@"shareImage"] forState:UIControlStateNormal];
    [self.btnShare setTitle:[NSString stringWithFormat:@"%@",self.responseObject.shareNum] forState:UIControlStateNormal];
    
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
//    self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
//    self.popupView.delegate = self;
//    self.popupView.type = @"comment";
//    self.popupView.fid = @"-1";
//    self.popupView.detail = @"";
//    [self.navigationController.view addSubview:self.popupView];
//    [self.popupView showWithAnimated:YES];

}

- (IBAction)share:(id)sender {
}
@end
