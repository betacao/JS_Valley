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
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGMarketSegmentViewController.h"
#import "SHGPersonalViewController.h"
#import "SHGMarketCommentTableViewCell.h"
#import "VerifyIdentityViewController.h"
#import "SHGEmptyDataView.h"
#import "MLEmojiLabel.h"
#import "SHGUnifiedTreatment.h"
#define k_FirstToTop 5.0f * XFACTOR
#define k_SecondToTop 10.0f * XFACTOR
#define k_ThirdToTop 15.0f * XFACTOR
#define PRAISE_WIDTH 30.0f
#define PRAISE_SEPWIDTH     10.0f
#define PRAISE_RIGHTWIDTH     40.0f

@interface SHGMarketDetailViewController ()<BRCommentViewDelegate, CircleActionDelegate, SHGMarketCommentDelegate, MLEmojiLabelDelegate>
{
    UIView *PickerBackView;
}
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
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;

@property (assign, nonatomic) BOOL isCollectionChange;

@property (weak, nonatomic) SHGMarketCommentObject *commentObject;
@property (strong, nonatomic) NSString *copyedString;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) BRCommentView *popupView;
//数据
@property (strong, nonatomic) UIView *photoView ;
@property (strong, nonatomic) SHGMarketObject *responseObject;
- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)collectionClick:(UIButton *)sender;

@end

@implementation SHGMarketDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务详情";
    self.isCollectionChange = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];
    
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    [self.detailTable setTableFooterView:[[UIView alloc] init]];


    DDTapGestureRecognizer *hdGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeaderView:)];
    [self.headImageView addGestureRecognizer:hdGes];
    self.headImageView.userInteractionEnabled = YES;
    
    [self initView];
    [self addLayout];
    

    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":self.object.marketId ,@"uid":UID};
    [SHGMarketManager loadMarketDetail:param block:^(SHGMarketObject *object) {
        weakSelf.responseObject = object;
        weakSelf.responseObject.commentList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.commentList class:[SHGMarketCommentObject class]]];
        weakSelf.responseObject.praiseList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.praiseList class:[praiseOBj class]]];
        [weakSelf loadData];
        [weakSelf.detailTable reloadData];
    }];
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateTypeMarketDeleted;
    }
    return _emptyView;
}
//
//- (UIView *)photoView
//{
//    if (!_photoView) {
//        _photoView = [[UIView alloc]init];
//        [self.viewHeader addSubview:_photoView];
//    }
//    return _photoView;
//}

- (void)initView
{
    self.nameLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.companyLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.positionLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    self.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.typeLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.capitalLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.addressLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.modelLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];

    self.phoneNumLabel.numberOfLines = 0;
    self.phoneNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.phoneNumLabel.textColor = [UIColor colorWithHexString:@"888888"];
    self.phoneNumLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.phoneNumLabel.delegate = self;
    self.phoneNumLabel.backgroundColor = [UIColor clearColor];

    self.marketDetialLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    self.detailContentLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];
    [self.speakButton setTitle:@"写评论" forState:UIControlStateNormal];
    [self.speakButton setImage:[UIImage imageNamed:@"market_change"] forState:UIControlStateNormal];
    self.speakButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f,0.0f);
    self.speakButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(15.0f), 0.0f, 0.0f);
    self.speakButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(13.0)];
    self.speakButton.layer.masksToBounds = YES;
    self.speakButton.layer.cornerRadius = 4;
    self.timeLabel.hidden = YES;
}

- (void)addLayout
{
    self.viewInput.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(45.0f));
    
    self.detailTable.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.viewInput, 0.0f);
    
    self.speakButton.sd_layout
    .leftSpaceToView(self.viewInput, MarginFactor(13.0f))
    .topSpaceToView(self.viewInput, MarginFactor(10.0f))
    .bottomSpaceToView(self.viewInput, MarginFactor(10.0f))
    .widthIs(MarginFactor(256.0f));
    
    [self.btnShare sizeToFit];
    CGSize shareSize = self.btnShare.frame.size;
    self.btnShare.sd_layout
    .rightSpaceToView(self.viewInput, MarginFactor(18.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(shareSize.width)
    .heightIs(shareSize.height);
    
    [self.collectionButton sizeToFit];
    CGSize collectSize = self.collectionButton.frame.size;
    self.collectionButton.sd_layout
    .rightSpaceToView(self.btnShare, MarginFactor(25.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(collectSize.width)
    .heightIs(collectSize.height);
    
    //headerView
    self.headImageView.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .topSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .widthIs(MarginFactor(45.0f))
    .heightIs(MarginFactor(45.0f));
    
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headImageView, MarginFactor(9.0f))
    .topEqualToView(self.headImageView)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.positionLabel.sd_layout
    .leftSpaceToView(self.nameLabel, MarginFactor(7.0f))
    .bottomEqualToView(self.nameLabel)
    .autoHeightRatio(0.0);
    [self.positionLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.firstHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .widthIs(SCREENWIDTH)
    .heightIs(0.5f)
    .topSpaceToView(self.headImageView, MarginFactor(15.0f));
    
    self.companyLabel.sd_layout
    .bottomEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView, MarginFactor(9.0f))
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    
    self.typeLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.titleLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.typeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.capitalLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.typeLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.capitalLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.addressLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.capitalLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.addressLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.modelLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.addressLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.modelLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.phoneNumLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.modelLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    self.phoneNumLabel.isAttributedContent = YES;
    
    self.secondHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.phoneNumLabel, MarginFactor(12.0f))
    .heightIs(0.5f);
    
    self.marketDetialLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.marketDetialLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.thirdHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.marketDetialLabel, MarginFactor(12.0f))
    .heightIs(0.5f);
    
    self.detailContentLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(16.0f))
    .autoHeightRatio(0.0f);
    self.detailContentLabel.isAttributedContent = YES;
    
    self.photoView = [[UIView alloc] init];
    [self.viewHeader addSubview:self.photoView];
    self.photoView.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(15.0f))
    .topSpaceToView(self.detailContentLabel,0.0f)
    .heightIs(0.0f);
    
    [self.viewHeader setupAutoHeightWithBottomView:self.photoView bottomMargin:MarginFactor(16.0f)];

    self.detailTable.tableHeaderView = self.viewHeader;
}

- (void)loadData
{
    [self addEmptyViewIfNeeded];
    [self loadShareButtonState];
    
    if (self.responseObject.mode.length == 0) {
         self.modelLabel.text = @"模式： 找资金";
    } else{
        self.modelLabel.text = [NSString stringWithFormat:@"模式：%@",self.responseObject.mode];
    }
    
    self.timeLabel.text = self.responseObject.createTime;
    if (!self.responseObject.price.length == 0) {
        NSString * zjStr = self.responseObject.price;
        self.capitalLabel.text = [NSString stringWithFormat:@"金额： %@",zjStr];
    } else {
        self.capitalLabel.text = [NSString stringWithFormat:@"金额： 暂未说明"];
    }
    self.typeLabel.text = [NSString stringWithFormat:@"类型： %@",self.responseObject.catalog];
    if ([self.responseObject.loginuserstate isEqualToString:@"0" ]) {
        NSString * contactString = @"联系方式：认证可见";
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:contactString];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontFactor(14.0f)] range:NSMakeRange(5, 4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4277B2"] range:NSMakeRange(5, 4)];
       [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"888888"] range:NSMakeRange(0, 5)];
        self.phoneNumLabel.attributedText = str;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactLabelToIdentification:)];
        [self.phoneNumLabel addGestureRecognizer:recognizer];

    } else if([self.responseObject.loginuserstate isEqualToString:@"1" ]){
        NSString * contactString = [@"联系方式：" stringByAppendingString: self.responseObject.contactInfo];
        self.phoneNumLabel.text = contactString;
    }
    self.nameLabel.text = self.responseObject.realname;
    if (![self.responseObject.createBy isEqualToString:UID] && [self.responseObject.anonymous isEqualToString:@"1"]) {
        self.companyLabel.textColor = [UIColor colorWithHexString:@"161616"];
        self.companyLabel.text = @"委托发布";
    }  else{
        if (self.responseObject.company.length == 0) {
            self.companyLabel.textColor = [UIColor colorWithHexString:@"161616"];
            self.companyLabel.text = @"委托发布";
            
        } else{
            self.companyLabel.text = self.responseObject.company;
        }
  
    }
   
    if (self.responseObject.title.length > 6) {
        NSString *str = [self.responseObject.title substringToIndex:6];
        self.positionLabel.text = [NSString stringWithFormat:@"%@…",str];
    } else{
        self.positionLabel.text = self.responseObject.title;
    }

    NSString * aStr = self.responseObject.position;
    self.addressLabel.text = [NSString stringWithFormat:@"地区： %@",aStr];
    [self.headImageView updateStatus:[self.responseObject.status isEqualToString:@"1"] ? YES : NO];
    [self.headImageView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.headimageurl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.responseObject.detail];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:MarginFactor(5.0f)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.responseObject.detail.length)];
    self.detailContentLabel.attributedText = attributedString;
    self.marketDetialLabel.text = @"业务描述：";

    NSString *title = self.responseObject.marketName;
    self.titleLabel.text = title;

    
    if (self.responseObject.isCollection) {
        [self.collectionButton setImage:[UIImage imageNamed:@"marketDetailCollection"] forState:UIControlStateNormal];
    } else{
        [self.collectionButton setImage:[UIImage imageNamed:@"marketDetailNoCollection"] forState:UIControlStateNormal];
    }
    if (self.responseObject.url.length > 0) {
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.viewHeader, MarginFactor(15.0f))
        .rightSpaceToView(self.viewHeader, MarginFactor(15.0f))
        .topSpaceToView(self.detailContentLabel, MarginFactor(15.0f))
        .heightIs(MarginFactor(135.0f));
        self.photoView.clipsToBounds = YES;
        SDPhotoGroup * photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.url];
        [temp addObject:item];
        photoGroup.photoItemArray = temp;
        [self.photoView addSubview:photoGroup];
    }

    [self.viewHeader layoutSubviews];
    self.detailTable.tableHeaderView = self.viewHeader;

}

- (void)tapContactLabelToIdentification:(UITapGestureRecognizer *)rescognizer
{
    if([self.responseObject.loginuserstate isEqualToString:@"1" ]){
        NSString *phoneNum = self.responseObject.contactInfo;
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:num]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        } else{
            NSLog(@"拨打失败");
        }

    } else{
        [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
            if (status) {

            } else{
                VerifyIdentityViewController * vc = [[VerifyIdentityViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failString:@"认证后才能查看联系方式～"];
    }
}

- (void)addEmptyViewIfNeeded
{
    if ([self.responseObject.isDeleted isEqualToString:@"Y"]) {
        [self.view addSubview:self.emptyView];
    }
}

#pragma mark ----tableView----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseObject.commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SHGMarketCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    CGFloat height = [object heightForCell];
    if(indexPath.row == 0){
        height += kCommentTopMargin;
    }
    if (indexPath.row == self.responseObject.commentList.count - 1){
        height += kCommentBottomMargin;
    }
    return height + kCommentMargin;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGMarketCommentTableViewCell";
    SHGMarketCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGMarketCommentTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.index = indexPath.row;
    SHGMarketCommentType type = SHGMarketCommentTypeNormal;
    NSLog(@"index.row%ld",(long)indexPath.row);
    if(indexPath.row == 0){
        type = SHGMarketCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.commentList.count - 1){
        type = SHGMarketCommentTypeLast;
    }
    SHGMarketCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    [cell loadUIWithObj:object commentType:type];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
    [cell.contentView addGestureRecognizer:longPress];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGMarketCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    self.commentObject = object;
    self.copyedString = object.commentDetail;
    if ([object.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        //复制删除试图
        [self createPickerView];
    } else{
        [self replyClicked:object commentIndex:indexPath.row];
    }
}

#pragma mark -- 删除评论
- (void)longPressGesturecognized:(id)sender
{    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [longPress locationInView:self.detailTable];
    NSIndexPath *indexPath = [self.detailTable indexPathForRowAtPoint:location];
    switch (state){
        case UIGestureRecognizerStateBegan:{
            if (indexPath){
                //判断是否是自己
                SHGMarketCommentObject *obj = self.responseObject.commentList[indexPath.row];
                self.commentObject = obj;
                self.copyedString = obj.commentDetail;
                
                if ([obj.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]){
                    [self createPickerView];
                } else{
                    NSLog(@"2");
                    PickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
                    PickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
                    tap.cancelsTouchesInView = YES;
                    [PickerBackView addGestureRecognizer:tap];
                    PickerBackView.userInteractionEnabled = YES;
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2, self.view.bounds.size.width - 60, 50);
                    button.backgroundColor = [UIColor whiteColor];
                    [button setTitle:@"复制" forState:UIControlStateNormal];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                    [button addTarget:self action:@selector(copyButton) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [PickerBackView addSubview:button];
                    [self.view addSubview:PickerBackView];
                    [self.view bringSubviewToFront:PickerBackView];
                    //[self.view sendSubviewToBack:PickerBackView];
                }
            }
            break;
        }
        default:{
            
        }
    }
}


//创建删除试图
- (void)createPickerView
{
    PickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    PickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    tap.cancelsTouchesInView = YES;
    [PickerBackView addGestureRecognizer:tap];
    PickerBackView.userInteractionEnabled = YES;
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2-50, self.view.bounds.size.width - 60, 50);
    copy.backgroundColor = [UIColor whiteColor];
    [copy setTitle:@"复制" forState:UIControlStateNormal];
    copy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    copy.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [copy addTarget:self action:@selector(copyButton) forControlEvents:UIControlEventTouchUpInside];
    [copy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PickerBackView addSubview:copy];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, (self.view.bounds.size.height-50)/2, self.view.bounds.size.width - 60, 1)];
    view.backgroundColor = [UIColor grayColor];
    [PickerBackView addSubview:view];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2+1, self.view.bounds.size.width - 60, 50);
    delete.backgroundColor = [UIColor whiteColor];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    delete.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [delete addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PickerBackView addSubview:delete];
    
    [self.view addSubview:PickerBackView];
    [self.view bringSubviewToFront:PickerBackView];
}
- (void)closeView
{
    [PickerBackView removeFromSuperview];
}
//复制
- (void)copyButton
{
    NSLog(@"....%@",self.copyedString);
    [UIPasteboard generalPasteboard].string = self.copyedString;
    self.detailTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
}
//删除
- (void)deleteButton
{
    __weak typeof(self)weakSelf = self;
    [SHGMarketManager deleteCommentWithID:self.commentObject.commentId finishBlock:^(BOOL finish) {
        [weakSelf.responseObject.commentList removeObject:weakSelf.commentObject];
        [weakSelf.detailTable reloadData];
    }];

    [self.view sendSubviewToBack:PickerBackView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark ----btnClick---

- (void)loadShareButtonState
{
    [self.btnShare setImage:[UIImage imageNamed:@"marketShareImage"] forState:UIControlStateNormal];
}

- (void)moveToUserCenter:(UITapGestureRecognizer *)recognizer
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] init];
    controller.userId = [NSString stringWithFormat:@"%ld",(long)recognizer.view.tag];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)comment:(id)sender
{
    self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
    self.popupView.delegate = self;
    self.popupView.type = @"comment";
    self.popupView.fid = @"-1";
    self.popupView.detail = @"";
    [self.navigationController.view addSubview:self.popupView];
    [self.popupView showWithAnimated:YES];
}

- (void)replyClicked:(SHGMarketCommentObject *)obj commentIndex:(NSInteger)index
{
    self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:obj.commentUserName];
    self.popupView.delegate = self;
    self.popupView.fid = obj.commentUserId;
    self.popupView.detail = @"";
    self.popupView.rid = obj.commentId;
    self.popupView.type = @"repley";
    [self.navigationController.view addSubview:self.popupView];
    [self.popupView showWithAnimated:YES];
}

- (void)rightUserClick:(NSInteger)index
{
    SHGMarketCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentOtherName];
}

- (void)leftUserClick:(NSInteger)index
{
    SHGMarketCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentOtherName];
}

-(void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [SHGMarketManager addCommentWithObject:self.responseObject content:comment toOther:nil finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.detailTable reloadData];
//            [weakSelf.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [SHGMarketManager addCommentWithObject:self.responseObject content:comment toOther:fid finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.detailTable reloadData];
//  [weakSelf.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];
        }
    }];
}



- (IBAction)share:(id)sender
{
    [[SHGMarketManager shareManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {

    }];
}

- (IBAction)collectionClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeleteCollect:self.responseObject state:^(BOOL state) {
        weakSelf.responseObject.isCollection = state;
        [weakSelf loadCollectButtonState];
        
    }];
 
}
- (void)loadCollectButtonState
{
    if (self.responseObject.isCollection ) {
        [self.collectionButton setImage:[UIImage imageNamed:@"marketDetailCollection"] forState:UIControlStateNormal];
         self.isCollectionChange = YES;
    } else{
        [self.collectionButton setImage:[UIImage imageNamed:@"marketDetailNoCollection"] forState:UIControlStateNormal];
        self.isCollectionChange = NO;
    }
//  [self.btnZan setTitle:self.responseObject.praiseNum forState:UIControlStateNormal];
}


#pragma mark ------分享到圈内好友的通知
- (void)shareToFriendSuccess:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [SHGMarketManager shareSuccessCallBack:self.responseObject finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf loadShareButtonState];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Hud showMessageWithText:@"分享成功"];
    });
}


- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypePhoneNumber:
            [self openTel:link];
            NSLog(@"点击了电话%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }

}
#pragma mark -- sdc
#pragma mark -- 拨打电话
- (BOOL)openTel:(NSString *)tel
{
    [[SHGGloble sharedGloble] recordUserAction:self.responseObject.marketId type:@"call"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)didTapHeaderView:(UIGestureRecognizer *)recognizer
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = self.responseObject.createBy;
    controller.delegate = [SHGUnifiedTreatment sharedTreatment];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isCollectionChange) {
        [self.controller changeMarketCollection];
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
