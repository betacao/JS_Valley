//
//  SHGBusinessDetailViewController.m
//  Finance
//
//  Created by changxicao on 16/3/31.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessDetailViewController.h"
#import "CircleLinkViewController.h"
#import "SHGBusinessManager.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGPersonalViewController.h"
#import "SHGBusinessCommentTableViewCell.h"
#import "SHGEmptyDataView.h"
#import "MLEmojiLabel.h"
#import "SHGUnifiedTreatment.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"
#define k_FirstToTop 5.0f * XFACTOR
#define k_SecondToTop 10.0f * XFACTOR
#define k_ThirdToTop 15.0f * XFACTOR
#define PRAISE_WIDTH 30.0f
#define PRAISE_SEPWIDTH     10.0f
#define PRAISE_RIGHTWIDTH     40.0f

@interface SHGBusinessDetailViewController ()<BRCommentViewDelegate, CircleActionDelegate, SHGBusinessCommentDelegate, MLEmojiLabelDelegate>
{
    UIView *PickerBackView;
}
//界面
@property (weak, nonatomic) IBOutlet UITableView *detailTable;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *propertyLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *businessDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;

@property (assign, nonatomic) BOOL isCollectionChange;

@property (weak, nonatomic) SHGBusinessCommentObject *commentObject;
@property (strong, nonatomic) NSString *copyedString;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) BRCommentView *popupView;
//数据
@property (strong, nonatomic) UIView *photoView ;
@property (strong, nonatomic) SHGBusinessObject *responseObject;
- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)collectionClick:(UIButton *)sender;

@end

@implementation SHGBusinessDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"业务详情";
    self.isCollectionChange = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];

    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    [self.detailTable setTableFooterView:[[UIView alloc] init]];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_MEMORY];

    [self initView];
    [self addLayout];
    [self initData];

}

- (void)editBusiness
{
    [self initData];
}

- (void)initData
{
    __weak typeof(self) weakSelf = self;
    [SHGBusinessManager getBusinessDetail:self.object success:^(SHGBusinessObject *detailObject) {
        weakSelf.responseObject = detailObject;
        NSLog(@"%@",weakSelf.responseObject);
        [weakSelf loadData];
        [weakSelf.detailTable reloadData];
    }];

}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateTypeBusinessDeleted;
    }
    return _emptyView;
}

- (void)initView
{
    self.nameLabel.font = FontFactor(15.0f);
    self.companyLabel.font = FontFactor(13.0f);
    self.positionLabel.font = FontFactor(13.0f);
    self.titleLabel.font = FontFactor(15.0f);

    self.propertyLabel.font = FontFactor(13.0f);
    self.propertyLabel.numberOfLines = 0;
    self.propertyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.propertyLabel.textColor = [UIColor colorWithHexString:@"888888"];
    self.propertyLabel.delegate = self;
    self.propertyLabel.isAttributedContent = YES;

    self.businessDetialLabel.font = FontFactor(15.0f);
    self.detailContentLabel.font = FontFactor(15.0f);
    [self loadCommentBtnState];
    self.speakButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f,0.0f);
    self.speakButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(15.0f), 0.0f, 0.0f);
    self.speakButton.titleLabel.font = FontFactor(13.0);
    self.speakButton.layer.masksToBounds = YES;
    self.speakButton.layer.cornerRadius = 4;

    [self.collectionButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.editButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnShare  setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
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

    [self.editButton sizeToFit];
    CGSize editSize = self.editButton.frame.size;
    self.editButton.sd_layout
    .rightSpaceToView(self.btnShare, MarginFactor(25.0f))
    .centerYEqualToView(self.speakButton)
    .widthIs(editSize.width)
    .heightIs(editSize.height);


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

    self.propertyLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.titleLabel, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);

    self.secondHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.propertyLabel, MarginFactor(12.0f))
    .heightIs(0.5f);

    self.businessDetialLabel.sd_layout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.businessDetialLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.thirdHorizontalLine.sd_layout
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .topSpaceToView(self.businessDetialLabel, MarginFactor(12.0f))
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
    [self loadCollectButtonState];
    //***************************
    BOOL status = [self.responseObject.status isEqualToString:@"1"] ? YES : NO;
    [self.headImageView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:self.responseObject.createBy];

    self.nameLabel.text = self.responseObject.realName;
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
        self.positionLabel.text = [NSString stringWithFormat:@"%@...",str];
    } else{
        self.positionLabel.text = self.responseObject.title;
    }

    NSString *value = [[SHGGloble sharedGloble] businessKeysForValues:self.responseObject.middleContent];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:FontFactor(13.0f), NSForegroundColorAttributeName: Color(@"888888")}];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5.0f];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    self.propertyLabel.text = string;
    //****************************//

    self.businessDetialLabel.text = @"业务描述：";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.responseObject.detail];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:MarginFactor(5.0f)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.responseObject.detail.length)];
    self.detailContentLabel.attributedText = attributedString;

    NSString *title = self.responseObject.businessTitle;
    self.titleLabel.text = title;

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


    //***************************
    if ([UID isEqualToString:self.responseObject.createBy]) {
        self.editButton.hidden = NO;
        self.collectionButton.hidden = YES;
    } else {
        self.editButton.hidden = YES;
        self.collectionButton.hidden = NO;
    }
    [self.btnShare setImage:[UIImage imageNamed:@"blueMarketDetailShare"] forState:UIControlStateNormal];
    [self.viewHeader layoutSubviews];
    self.detailTable.tableHeaderView = self.viewHeader;

}



- (IBAction)editButtonClick:(UIButton *)sender
{
    if ([self.responseObject.type isEqualToString:@"moneyside"]) {
        if ([self.responseObject.moneysideType isEqualToString:@"equityInvest"]) {
            SHGEquityInvestSendViewController *viewController = [[SHGEquityInvestSendViewController alloc] init];
            viewController.object = self.responseObject;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if ([self.responseObject.moneysideType isEqualToString:@"bondInvest"]){
            SHGBondInvestSendViewController *viewController = [[SHGBondInvestSendViewController alloc] init];
            viewController.object = self.responseObject;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if ([self.responseObject.type isEqualToString:@"bondfinancing"]){
        SHGBondFinanceSendViewController *viewController = [[SHGBondFinanceSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([self.responseObject.type isEqualToString:@"equityfinancing"]){
        SHGEquityFinanceSendViewController *viewController = [[SHGEquityFinanceSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([self.responseObject.type isEqualToString:@"trademixed"]){
        SHGSameAndCommixtureSendViewController *viewController = [[SHGSameAndCommixtureSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)tapContactLabelToIdentification:(UITapGestureRecognizer *)rescognizer
{

    if([self.responseObject.userState isEqualToString:@"1" ]){
        NSString *phoneNum = self.responseObject.middleContent;
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:num]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        } else{
            NSLog(@"拨打失败");
        }

    } else{
        [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
            if (!state) {
                SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } showAlert:YES leftBlock:^{
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
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
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
    NSString *cellIdentifier = @"SHGBusinessCommentTableViewCell";
    SHGBusinessCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessCommentTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
        [cell.contentView addGestureRecognizer:longPress];
    }
    cell.index = indexPath.row;
    SHGBusinessCommentType type = SHGBusinessCommentTypeNormal;
    NSLog(@"index.row%ld",(long)indexPath.row);
    if(indexPath.row == 0){
        type = SHGBusinessCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.commentList.count - 1){
        type = SHGBusinessCommentTypeLast;
    }
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    [cell loadUIWithObj:object commentType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
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
                SHGBusinessCommentObject *obj = self.responseObject.commentList[indexPath.row];
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
    [SHGBusinessManager deleteCommentWithID:self.commentObject.commentId finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf.responseObject.commentList removeObject:weakSelf.commentObject];
            [weakSelf.detailTable reloadData];
        }
    }];
    [self.view sendSubviewToBack:PickerBackView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark ----btnClick---

- (void)loadCommentBtnState
{
    NSString *memory = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_MEMORY];
    if ([memory isEqualToString:@""]) {
        [self.speakButton setTitle:@"写评论" forState:UIControlStateNormal];
        [self.speakButton setImage:[UIImage imageNamed:@"market_change"] forState:UIControlStateNormal];
        [self.speakButton setTitleColor:[UIColor colorWithHexString:@"a5a5a5"] forState:UIControlStateNormal];
    } else{
        [self.speakButton setTitle:memory forState:UIControlStateNormal];
        [self.speakButton setImage:nil forState:UIControlStateNormal];
        [self.speakButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    }

}

- (IBAction)comment:(id)sender
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            self.popupView.delegate = self;
            self.popupView.type = @"comment";
            self.popupView.fid = @"-1";
            self.popupView.detail = @"";
            [self.navigationController.view addSubview:self.popupView];
            [self.popupView showWithAnimated:YES];
            [self.navigationController.view addSubview:_popupView];
            [_popupView showWithAnimated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity_cancel"];
    } failString:@"认证后才能发起评论哦～"];


}

- (void)replyClicked:(SHGBusinessCommentObject *)obj commentIndex:(NSInteger)index
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
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentOtherName];
}

- (void)leftUserClick:(NSInteger)index
{
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
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

    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:nil finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.detailTable reloadData];
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:fid finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.detailTable reloadData];
        }
    }];
}

- (IBAction)share:(id)sender
{
    [[SHGBusinessManager shareManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {

    }];
}

- (IBAction)collectionClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    if (self.responseObject.isCollection) {
        [SHGBusinessManager unCollectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = NO;
                [weakSelf loadCollectButtonState];
            }
        }];
    } else {
        [SHGBusinessManager collectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = YES;
                [weakSelf loadCollectButtonState];
            }
        }];
    }

}
- (void)loadCollectButtonState
{
    if (self.responseObject.isCollection) {
        [self.collectionButton setImage:[UIImage imageNamed:@"business_collection"] forState:UIControlStateNormal];
        self.isCollectionChange = YES;
    } else{
        [self.collectionButton setImage:[UIImage imageNamed:@"business_unCollection"] forState:UIControlStateNormal];
        self.isCollectionChange = NO;
    }
}


#pragma mark ------分享到圈内好友的通知
- (void)shareToFriendSuccess:(NSNotification *)notification
{
    [SHGBusinessManager shareSuccessCallBack:self.responseObject finishBlock:^(BOOL success) {
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
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", self.responseObject.businessID, self.responseObject.type] type:@"business_call"];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isCollectionChange) {
        [self.controller changeBusinessCollection];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
