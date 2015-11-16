//
//  SHGActionDetailViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionDetailViewController.h"
#import "ReplyTableViewCell.h"
#import "SHGActionSignTableViewCell.h"
#define k_title_height 44.0
#define k_redLineToLeft 14;
#define k_labelToLeft 20;
#define k_imageToLabel 
//#import "SHGActionTableViewCell.h"
@interface SHGActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //UITableView * ybmTableView;
}
@property (strong,nonatomic)UITableView *ybmTableView;
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *titleBg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *JBXXLine;
@property (weak, nonatomic) IBOutlet UILabel *JBXXLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allNumImage;
@property (weak, nonatomic) IBOutlet UILabel *allNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BmImage;
@property (weak, nonatomic) IBOutlet UILabel *bmLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLineImage;
@property (weak, nonatomic) IBOutlet UIView *jjRedLine;
@property (weak, nonatomic) IBOutlet UILabel *jjLabel;
@property (weak, nonatomic) IBOutlet UILabel *jjMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CenterLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *plbutton;
@property (weak, nonatomic) IBOutlet UIView *yBMRedLine;
@property (weak, nonatomic) IBOutlet UILabel *yBMLabel;
@property (weak, nonatomic) IBOutlet UILabel *yBMNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *firstHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *secondHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *thirHeadButton;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstCommpany;
@property (weak, nonatomic) IBOutlet UIButton *firstLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *firstRightButton;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *secondCommpany;
@property (weak, nonatomic) IBOutlet UIButton *secondLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *SecondRightButton;
@property (weak, nonatomic) IBOutlet UILabel *thirHeadName;
@property (weak, nonatomic) IBOutlet UILabel *thirCommpany;
@property (weak, nonatomic) IBOutlet UIButton *thirLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *thirRiightButton;

@end

@implementation SHGActionDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    self.replyTable.delegate = self;
    self.replyTable.dataSource = self;
        
    [self setColor];
    
    [self setImage];
    
    [self setFram];
   
}
-(void)setFram
{
    NSInteger num = 3;
    NSInteger  plRowHeight = 54.0;
    self.replyTable.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    self.titleBg.frame = CGRectMake(0,0 , self.replyTable.frame.size.width, 44);
    self.titleLabel.frame = CGRectMake(0,0 , self.replyTable.frame.size.width, 44);
    self.jjMessageLabel.numberOfLines = 0;//任意行数
    NSString  *text = @"xxxx文件  来哈市办法V大搜啊；哈水电费；的；撒谎和；顺丰发大水了那副；厉害多撒谎；好；HDL；觳觫；发挥；萨满皮肤撒谎封IP撒谎覅哈斯；换肤dsa";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.f];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.jjMessageLabel.attributedText = attributedString;
    CGSize size = [self.jjMessageLabel sizeThatFits:CGSizeMake(self.replyTable.frame.size.width-40.0, MAXFLOAT)];
    CGRect frame = self.jjMessageLabel.frame;
    
    frame.size.height = size.height;
    self.jjMessageLabel.frame = CGRectMake(20, self.jjLabel.frame.origin.y+35, self.replyTable.frame.size.width-40, frame.size.height);
    self.CenterLineImage.frame = CGRectMake(0,self.jjMessageLabel.frame.size.height+self.jjMessageLabel.frame.origin.y+15 , self.replyTable.frame.size.width, 1);
    self.topLineImage.frame = CGRectMake(0, self.bmLabel.frame.size.height+self.bmLabel.frame.origin.y +15, [UIScreen mainScreen].bounds.size.width, 1);
    self.yBMRedLine.frame = CGRectMake(14, self.CenterLineImage.frame.origin.y+9, 1, 15);
    self.yBMLabel.frame = CGRectMake(25, self.CenterLineImage.frame.origin.y+6, 54, 20);
    self.yBMNumLabel.frame = CGRectMake(87, self.CenterLineImage.frame.origin.y+6, 54, 20);
    
    self.commentView.hidden = YES;
    _ybmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.yBMLabel.frame), self.replyTable.frame.size.width, plRowHeight *num)];
    self.ybmTableView.delegate = self;
    self.ybmTableView.dataSource = self;
    self.ybmTableView.scrollEnabled = NO;
    self.ybmTableView.showsHorizontalScrollIndicator = NO;
    self.ybmTableView.showsVerticalScrollIndicator = NO;
    self.ybmTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewHeader addSubview:self.ybmTableView];
    
    self.checkButton.frame = CGRectMake(self.replyTable.frame.size.width-14-20 , self.CenterLineImage.frame.origin.y+11, 10, 10);
    self.checkLabel.frame = CGRectMake(self.replyTable.frame.size.width-14-20-5-60, self.CenterLineImage.frame.origin.y+6, 60, 20);
    self.plbutton.frame = CGRectMake(self.replyTable.frame.size.width-14-50, CGRectGetMaxY(self.ybmTableView.frame)+10, 50, 20);
    self.zanButton.frame = CGRectMake(self.replyTable.frame.size.width-14-50-50, CGRectGetMaxY(self.ybmTableView.frame)+10, 50, 20);
    self.bottomLine.frame = CGRectMake(0, self.zanButton.frame.origin.y-6, self.replyTable.frame.size.width, 1);
    self.viewHeader.height = self.zanButton.frame.origin.y + self.zanButton.frame.size.height +10;
}
-(void)setColor
{
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"3A3A3A3A"];
    self.JBXXLine.backgroundColor = [UIColor colorWithHexString:@"F95C53"];
    self.jjRedLine.backgroundColor = [UIColor colorWithHexString:@"F95C53"];
    self.yBMRedLine.backgroundColor = [UIColor colorWithHexString:@"F95C53"];
    //
    self.JBXXLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.jjLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.jjMessageLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.yBMLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.allNumLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.bmLabel.textColor = [UIColor colorWithHexString:@"606060"];
    self.checkLabel.textColor = [UIColor colorWithHexString:@"F7514A"];
    
    self.firstName.textColor = [UIColor colorWithHexString:@"333333"];
    self.secondName.textColor = [UIColor colorWithHexString:@"333333"];
    self.thirHeadName.textColor = [UIColor colorWithHexString:@"333333"];
    self.firstCommpany.textColor = [UIColor colorWithHexString:@"606060"];
    self.secondCommpany.textColor = [UIColor colorWithHexString:@"606060"];
    self.thirCommpany.textColor = [UIColor colorWithHexString:@"606060"];
}
-(void)setImage
{
    [self.zanButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    [self.zanButton setTitle:@"555" forState:UIControlStateNormal];
    [self.zanButton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    [self.plbutton setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.plbutton setTitle:@"555" forState:UIControlStateNormal];
    [self.plbutton setTitleColor:[UIColor colorWithHexString:@"D1D1D1"] forState:UIControlStateNormal];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"action_checkAll"] forState:UIControlStateNormal];
    
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.topLineImage.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.CenterLineImage.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.bottomLine.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.replyTable]) {
        return  self.viewHeader.height;
    }else if ([tableView isEqual:self.ybmTableView]){
        
        return 0;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if ([tableView isEqual:self.replyTable]) {
        return  self.viewHeader;
    }else if ([tableView isEqual:self.ybmTableView]){
        
        return nil;
    }
    return nil;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.replyTable]) {
        section = 3;
    } else if([tableView isEqual:self.ybmTableView]){
        section = 3;
    }
    return section;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.replyTable]) {
        NSString *cellIdentifier = @"cellIdentifier";
        ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor = [UIColor redColor];
        return cell;

    }else if ([tableView isEqual:self.ybmTableView]){
         NSString *cellIdentifier = @"SHGActionSignTableViewCell";
        SHGActionSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionSignTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    if ([tableView isEqual:self.replyTable]) {
        rowHeight = 44.0;
    }else if ([tableView isEqual:self.ybmTableView]) {
        rowHeight = 54.0;
    }
    return rowHeight;
}
@end
