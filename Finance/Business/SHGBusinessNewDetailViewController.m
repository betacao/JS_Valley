//
//  SHGBusinessNewDetailViewController.m
//  Finance
//
//  Created by weiqiankun on 16/6/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessCommentTableViewCell.h"
#import "SHGCopyTextView.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGPersonalViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"
#import "LinkViewController.h"
#import "SHGEmptyDataView.h"
#import "NSCharacterSet+Common.h"
#import "SHGAlertView.h"
#import "SHGBusinessComplainViewController.h"
#import "SHGCompanyDisplayViewController.h"
#import "SHGCompanyBrowserViewController.h"
#import "SHGCompanyManager.h"
#import "SHGMyComplainViewController.h"

typedef NS_ENUM(NSInteger, SHGTapPhoneType)
{
    SHGTapPhoneTypeDialNumber,
    SHGTapPhoneTypeSendMessage
};

@interface SHGBusinessNewDetailViewController ()<CircleActionDelegate,SHGBusinessCommentDelegate,BRCommentViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIView *PickerBackView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *inPutView;
@property (weak, nonatomic) IBOutlet UIView *inputTopLine;

//头部redView
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *titleDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *complianNumButton;

//money和userView
@property (weak, nonatomic) IBOutlet UIView *moneyAndUserView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIView *userBottomLine;

//灰色view
@property (weak, nonatomic) IBOutlet UIView *firstGrayView;
@property (weak, nonatomic) IBOutlet UIView *secondGrayView;


//businessMessageVIew
@property (weak, nonatomic) IBOutlet UIView *businessMessageView;
@property (weak, nonatomic) IBOutlet UILabel *businessMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *businessMessageLabelView;
@property (weak, nonatomic) IBOutlet UIView *businessMessageTopLine;
@property (weak, nonatomic) IBOutlet UIView *businessMessageBpttomLine;

//企业信息
@property (strong, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *messageRightButton;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *companyTopLIneView;
@property (weak, nonatomic) IBOutlet UIView *companyCenterLineView;
@property (weak, nonatomic) IBOutlet UIView *companyBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *companyBottomView;

//业务描述
@property (strong, nonatomic) IBOutlet UIView *representView;
@property (weak, nonatomic) IBOutlet UIView *representLabelTopine;
@property (weak, nonatomic) IBOutlet UILabel *businessRepresentLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet SHGCopyTextView *contentTextView;

//inputView
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *complainButton;

@property (strong, nonatomic) UILabel *collectionLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) UILabel *editLabel;
@property (strong, nonatomic) UILabel *complainLabel;
//BP View
@property (weak, nonatomic) IBOutlet UIView *BPView;
@property (weak, nonatomic) IBOutlet UIView *thirdGaryView;
@property (weak, nonatomic) IBOutlet UIView *BPLine;
@property (weak, nonatomic) IBOutlet UILabel *BPLabel;
@property (weak, nonatomic) IBOutlet UIView *BPButtonView;
@property (weak, nonatomic) IBOutlet UIView *BPTopLine;
@property (weak, nonatomic) IBOutlet UIView *BPBottomLine;

@property (strong, nonatomic) UIView *photoView;
@property (strong, nonatomic) SHGBusinessObject *responseObject;
@property (weak, nonatomic) SHGBusinessCommentObject *commentObject;
@property (strong, nonatomic) SHGBusinessContactAuthObject *contactAuthObject;
@property (strong, nonatomic) NSString *copyedString;

@property (strong, nonatomic) BRCommentView *popupView;

@property (strong, nonatomic) NSMutableArray *middleContentArray;
@property (strong, nonatomic) NSMutableArray *phoneArray;
@property (strong, nonatomic) NSMutableArray *mobileArray;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (assign, nonatomic) SHGTapPhoneType type;

@property (assign, nonatomic) BOOL isChangeCollection;

@property (strong, nonatomic) SHGCompanyObject *companyObject;

@end

@implementation SHGBusinessNewDetailViewController
- (void)viewDidLoad
{
    self.rightItemImageName = @"newBusiness_share";
    [super viewDidLoad];
    self.isChangeCollection = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.inPutView addSubview:self.collectionLabel];
    [self.inPutView addSubview:self.phoneLabel];
    [self.inPutView addSubview:self.commentLabel];
    [self.inPutView addSubview:self.editLabel];
    [self.inPutView addSubview:self.complainLabel];
    [self initView];
    [self addSdLayout];
    [self loadData];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FontFactor(kNavBarTitleFontSize);
        _titleLabel.text = @"业务详情";
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)collectionLabel
{
    if (!_collectionLabel) {
        _collectionLabel = [[UILabel alloc] init];
        _collectionLabel.textAlignment = NSTextAlignmentCenter;
        _collectionLabel.text = @"收藏";
        _collectionLabel.textColor = Color(@"565656");
        _collectionLabel.font = FontFactor(12.0f);
        
    }
    return _collectionLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.text = @"联系TA";
        _phoneLabel.textColor = Color(@"565656");
        _phoneLabel.font = FontFactor(12.0f);
        
    }
    return _phoneLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        _commentLabel.text = @"留言";
        _commentLabel.textColor = Color(@"565656");
        _commentLabel.font = FontFactor(12.0f);
        
    }
    return _commentLabel;
}

- (UILabel *)editLabel
{
    if (!_editLabel) {
        _editLabel = [[UILabel alloc] init];
        _editLabel.textAlignment = NSTextAlignmentCenter;
        _editLabel.text = @"编辑";
        _editLabel.textColor = Color(@"565656");
        _editLabel.font = FontFactor(12.0f);
        
    }
    return _editLabel;
}

- (UILabel *)complainLabel
{
    if (!_complainLabel) {
        _complainLabel = [[UILabel alloc] init];
        _complainLabel.textAlignment = NSTextAlignmentCenter;
        _complainLabel.text = @"投诉";
        _complainLabel.textColor = Color(@"565656");
        _complainLabel.font = FontFactor(12.0f);
        
    }
    return _complainLabel;
}

- (NSMutableArray *)phoneArray
{
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

- (NSMutableArray *)mobileArray
{
    if (!_mobileArray) {
        _mobileArray = [NSMutableArray array];
    }
    return _mobileArray;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDataBusinessDeleted;
    }
    return _emptyView;
}


- (void)addSdLayout
{
    //inputView
    self.inPutView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.collectionButton.sd_layout
    .topSpaceToView(self.inputView, MarginFactor(8.0f))
    .centerXIs(SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.collectionButton.frame.size.height);

    self.collectionLabel.sd_layout
    .topSpaceToView(self.collectionButton, MarginFactor(4.0f))
    .centerXIs(SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.collectionLabel.font.lineHeight);

    self.editButton.sd_layout
    .topSpaceToView(self.inputView, MarginFactor(8.0f))
    .centerXIs(SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.editButton.frame.size.height);

    self.editLabel.sd_layout
    .topSpaceToView(self.editButton, MarginFactor(4.0f))
    .centerXIs(SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.editLabel.font.lineHeight);

    self.commentButton.sd_layout
    .topSpaceToView(self.inputView, MarginFactor(8.0f))
    .centerXIs(3 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.commentButton.size.height);

    self.commentLabel.sd_layout
    .topSpaceToView(self.commentButton, MarginFactor(4.0f))
    .centerXIs(3 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.commentLabel.font.lineHeight);
    
    self.complainButton.sd_layout
    .topSpaceToView(self.inputView, MarginFactor(8.0f))
    .centerXIs(5 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.complainButton.size.height);
    
    self.complainLabel.sd_layout
    .topSpaceToView(self.complainButton, MarginFactor(4.0f))
    .centerXIs(5 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.complainLabel.font.lineHeight);

    self.phoneButton.sd_layout
    .topSpaceToView(self.inputView, MarginFactor(8.0f))
    .centerXIs(7 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.phoneButton.size.height);
    
    self.phoneLabel.sd_layout
    .topSpaceToView(self.phoneButton, MarginFactor(4.0f))
    .centerXIs(7 * SCREENWIDTH/8)
    .widthIs(SCREENWIDTH/4)
    .heightIs(self.phoneLabel.font.lineHeight);
    
    self.inputTopLine.sd_layout
    .leftSpaceToView(self.inPutView, 0.0f)
    .rightSpaceToView(self.inPutView, 0.0f)
    .topSpaceToView(self.inPutView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.headerView.sd_layout
    .topSpaceToView(self.tableView, 0.0f)
    .leftSpaceToView(self.tableView, 0.0f)
    .rightSpaceToView(self.tableView, 0.0f);
    
    //redView
    self.redView.sd_layout
    .topSpaceToView(self.headerView, 0.0f)
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .heightIs(MarginFactor(124.0f));

    self.titleDetailLabel.sd_layout
    .topSpaceToView(self.redView, 0.0f)
    .leftSpaceToView(self.redView, MarginFactor(14.0f))
    .rightSpaceToView(self.redView, MarginFactor(14.0f))
    .heightIs(MarginFactor(83.0f));
    
    
    self.firstHorizontalLine.sd_layout
    .leftSpaceToView(self.redView, MarginFactor(14.0f))
    .rightSpaceToView(self.redView, MarginFactor(14.0f))
    .bottomSpaceToView(self.redView, MarginFactor(41.0f))
    .heightIs(1 / SCALE);
    
    self.typeButton.sd_layout
    .leftSpaceToView(self.redView, MarginFactor(14.0f))
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(21.0f))
    .widthIs(10.0f)
    .heightIs(10.0f);
    
    self.areaButton.sd_layout
    .leftSpaceToView(self.typeButton, MarginFactor(9.0f))
    .centerYEqualToView(self.typeButton)
    .widthIs(10.0f)
    .heightIs(10.0f);
    
    self.complianNumButton.sd_layout
    .rightSpaceToView(self.redView, MarginFactor(19.0f))
    .centerYEqualToView(self.typeButton)
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(20.0f));
    
    //moneyAndUserView
    self.moneyAndUserView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.redView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.centerLine.sd_layout
    .centerYEqualToView(self.moneyAndUserView)
    .centerXEqualToView(self.moneyAndUserView)
    .widthIs(1 / SCALE)
    .heightIs(MarginFactor(35.0f));
    
    self.moneyLabel.sd_layout
    .centerXIs(SCREENWIDTH / 4.0)
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(MarginFactor(115.0f))
    .heightRatioToView(self.moneyAndUserView, 1.0f);
    
    self.userLabel.sd_layout
    .centerXIs(3 * SCREENWIDTH / 4.0)
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(MarginFactor(115.0f))
    .heightRatioToView(self.moneyAndUserView, 1.0f);
    
    [self.userButton sizeToFit];
    CGSize userButtonSize = self.userButton.frame.size;
    self.userButton.sd_layout
    .rightSpaceToView(self.moneyAndUserView, MarginFactor(14.0f))
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(userButtonSize.width)
    .heightIs(userButtonSize.height);
    
    self.userBottomLine.sd_layout
    .leftSpaceToView(self.moneyAndUserView, 0.0f)
    .rightSpaceToView(self.moneyAndUserView, 0.0f)
    .bottomSpaceToView(self.moneyAndUserView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.firstGrayView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.moneyAndUserView, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    UIImage *rightImage = [UIImage imageNamed:@"rightArrowImage"];
    CGSize rightImageSize = rightImage.size;
    
    //公司信息
    self.companyView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.firstGrayView, 0.0f);
    
    self.companyTopLIneView.sd_layout
    .leftSpaceToView(self.companyView, 0.0f)
    .rightSpaceToView(self.companyView, 0.0f)
    .topSpaceToView(self.companyView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.companyLabel.sd_layout
    .leftSpaceToView(self.companyView, MarginFactor(14.0f))
    .rightSpaceToView(self.companyView, MarginFactor(14.0f))
    .topSpaceToView(self.companyTopLIneView, 0.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.companyCenterLineView.sd_layout
    .leftEqualToView(self.companyLabel)
    .rightEqualToView(self.companyLabel)
    .topSpaceToView(self.companyLabel, 1.0f)
    .heightIs(1 / SCALE);
    
    self.messageButton.sd_layout
    .leftSpaceToView(self.companyView, MarginFactor(14.0f))
    .topSpaceToView(self.companyCenterLineView, 0.0f)
    .rightSpaceToView(self.companyView, MarginFactor(19.0f) + rightImageSize.width)
    .heightIs(MarginFactor(52.0f));
    
    self.messageRightButton.sd_layout
    .rightSpaceToView(self.companyView, MarginFactor(19.0f))
    .centerYEqualToView(self.messageButton)
    .widthIs(rightImageSize.width)
    .heightIs(rightImageSize.height);
    
    self.companyBottomLineView.sd_layout
    .leftSpaceToView(self.companyView, 0.0f)
    .rightSpaceToView(self.companyView, 0.0f)
    .topSpaceToView(self.messageButton, 0.0f)
    .heightIs(1 / SCALE);
    
    self.companyBottomView.sd_layout
    .topSpaceToView(self.companyBottomLineView, 0.0f)
    .leftSpaceToView(self.companyView, 0.0f)
    .rightSpaceToView(self.companyView, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    [self.companyView setupAutoHeightWithBottomView:self.companyBottomView bottomMargin:0.0f];
    

    //messageView
    self.businessMessageView.sd_layout
    .topSpaceToView(self.companyView, 0.0f)
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f);
    
    self.businessMessageTopLine.sd_layout
    .leftSpaceToView(self.businessMessageView, 0.0f)
    .rightSpaceToView(self.businessMessageView, 0.0f)
    .topSpaceToView(self.businessMessageView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.businessMessageLabel.sd_layout
    .leftSpaceToView(self.businessMessageView, MarginFactor(14.0f))
    .rightSpaceToView(self.businessMessageView, 0.0f)
    .topSpaceToView(self.businessMessageTopLine, 0.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.secondHorizontalLine.sd_layout
    .leftEqualToView(self.businessMessageLabel)
    .rightSpaceToView(self.businessMessageView, MarginFactor(14.0f))
    .topSpaceToView(self.businessMessageLabel, 0.0f)
    .heightIs(1 / SCALE);
    
    self.businessMessageLabelView.sd_layout
    .leftEqualToView(self.secondHorizontalLine)
    .rightEqualToView(self.secondHorizontalLine)
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(14.0f));

    
    [self.businessMessageView setupAutoHeightWithBottomView:self.businessMessageLabelView bottomMargin:0.0f];

    self.businessMessageBpttomLine.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.businessMessageView, MarginFactor(8.0f))
    .heightIs(1 / SCALE);
    
    self.secondGrayView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.businessMessageBpttomLine, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    
      //BPView
    self.BPView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.secondGrayView,0.0f);
    
    self.BPTopLine.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.BPLabel.sd_layout
    .leftSpaceToView(self.BPView, MarginFactor(14.0f))
    .rightSpaceToView(self.BPView, MarginFactor(14.0f))
    .topSpaceToView(self.BPView, 1.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.BPLine.sd_layout
    .leftEqualToView(self.BPLabel)
    .rightEqualToView(self.BPLabel)
    .topSpaceToView(self.BPLabel, 0.0f)
    .heightIs(1 / SCALE);
    
    self.BPButtonView.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPLine, 0.0f)
    .heightIs(MarginFactor(110.0f));
    
    self.BPBottomLine.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPButtonView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.thirdGaryView.sd_layout
    .leftEqualToView(self.BPButtonView)
    .rightEqualToView(self.BPButtonView)
    .topSpaceToView(self.BPBottomLine,0.0f)
    .heightIs(MarginFactor(10.0f));
    
    
    [self.BPView setupAutoHeightWithBottomView:self.thirdGaryView bottomMargin:0.0f];
    //业务描述
    self.representView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.secondGrayView, 0.0f);
    
    self.representLabelTopine.sd_layout
    .leftSpaceToView(self.representView, 0.0f)
    .rightSpaceToView(self.representView, 0.0f)
    .topSpaceToView(self.representView, 0.0f)
    .heightIs(1 / SCALE);
    
    self.businessRepresentLabel.sd_layout
    .leftSpaceToView(self.representView, MarginFactor(14.0f))
    .rightSpaceToView(self.representView, MarginFactor(14.0f))
    .topSpaceToView(self.representLabelTopine, 0.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.thirdHorizontalLine.sd_layout
    .leftEqualToView(self.businessRepresentLabel)
    .rightEqualToView(self.businessRepresentLabel)
    .topSpaceToView(self.businessRepresentLabel, 1.0f)
    .heightIs(1 / SCALE);
    
    self.contentTextView.sd_layout
    .leftEqualToView(self.thirdHorizontalLine)
    .rightEqualToView(self.thirdHorizontalLine)
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(15.0f));
    
    [self.representView setupAutoHeightWithBottomView:self.contentTextView bottomMargin:MarginFactor(15.0f)];
    
    self.photoView = [[UIView alloc] init];
    [self.headerView addSubview:self.photoView];
    self.photoView.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(15.0f))
    .rightSpaceToView(self.headerView, MarginFactor(15.0f))
    .topSpaceToView(self.representView,0.0f)
    .heightIs(0.0f);
    
    [self.headerView setupAutoHeightWithBottomView:self.photoView bottomMargin:MarginFactor(15.0f)];
    self.headerView.hidden = YES;
    [self.tableView setTableHeaderView:self.headerView];
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view,0.0f)
    .bottomSpaceToView(self.inPutView, 0.0f);
}

- (void)initView
{

    self.businessRepresentLabel.text = @"业务描述";
    [self.headerView sd_addSubviews:@[self.redView,self.moneyAndUserView,self.businessMessageView,self.BPView,self.companyView,self.representView]];

    [self.userButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:150.0f];
    UITapGestureRecognizer *tableHeaderViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableHeaderView:)];
    [self.headerView addGestureRecognizer:tableHeaderViewRecognizer];
    //inputView
    self.inPutView.backgroundColor = Color(@"f4f4f4");    
    self.inputTopLine.backgroundColor = Color(@"e2e2e2");
    [self.collectionButton setTitleColor:Color(@"565656") forState:UIControlStateNormal];
    
    [self.commentButton setTitleColor:Color(@"565656") forState:UIControlStateNormal];

    [self.phoneButton setTitleColor:Color(@"565656") forState:UIControlStateNormal];
    
    [self.editButton setTitleColor:Color(@"565656") forState:UIControlStateNormal];
    
    [self.complainButton setTitleColor:Color(@"565656") forState:UIControlStateNormal];

    self.editButton.titleLabel.font = self.collectionButton.titleLabel.font = self.commentButton.titleLabel.font = self.phoneButton.titleLabel.font = self.complainButton.titleLabel.font = FontFactor(12.0f);
    
    //redView
    self.redView.backgroundColor = Color(@"f04f46");
    self.firstHorizontalLine.backgroundColor = Color(@"fd665d");
    self.typeButton.titleLabel.font = self.areaButton.titleLabel.font = FontFactor(12.0f);
    [self.typeButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.areaButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    self.typeButton.adjustsImageWhenHighlighted = self.areaButton.adjustsImageWhenHighlighted = NO;
    self.moneyLabel.isAttributedContent = self.userLabel.isAttributedContent = YES;
    self.userLabel.numberOfLines = self.moneyLabel.numberOfLines = 0;
    self.moneyLabel.textAlignment = self.userLabel.textAlignment = NSTextAlignmentCenter;
    
    self.firstGrayView.backgroundColor = self.secondGrayView.backgroundColor = self.thirdGaryView.backgroundColor = self.companyBottomView.backgroundColor = Color(@"f7f7f7");
    self.secondHorizontalLine.backgroundColor = self.thirdHorizontalLine.backgroundColor = self.centerLine.backgroundColor = Color(@"e6e7e8");
    self.userBottomLine.backgroundColor = self.businessMessageBpttomLine.backgroundColor = self.businessMessageTopLine.backgroundColor = self.BPBottomLine.backgroundColor = self.BPTopLine.backgroundColor = self.representLabelTopine.backgroundColor = self.companyTopLIneView.backgroundColor = self.companyCenterLineView.backgroundColor = self.companyBottomLineView.backgroundColor = Color(@"e6e7e8");
    
    self.businessMessageLabel.font = self.businessRepresentLabel.font = self.companyLabel.font = FontFactor(16.0f);
    self.businessMessageLabel.textColor = self.businessRepresentLabel.textColor = self.companyLabel.textColor = Color(@"3A3A3A");
    
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(0, -5.0f, 0, 0);
    
    [self.messageButton setTitleColor:Color(@"247ee2") forState:UIControlStateNormal];
    self.messageButton.titleLabel.font = FontFactor(14.0f);
    self.messageButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.complianNumButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.complianNumButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    self.complianNumButton.alpha = 0.75;
    self.complianNumButton.titleLabel.font = FontFactor(13.0f);
    
    
}

- (void)loadData
{
    WEAK(self, weakSelf);
    [SHGBusinessManager getBusinessDetail:weakSelf.object success:^(SHGBusinessObject *detailObject) {
        weakSelf.responseObject = detailObject;
        NSString *value = [[SHGGloble sharedGloble] businessKeysForValues:self.responseObject.middleContent showEmptyKeys:NO];
        NSArray *array = [value componentsSeparatedByString:@"\n"];
        weakSelf.middleContentArray = [NSMutableArray arrayWithArray:array];
        NSLog(@"%@",weakSelf.responseObject);
        [weakSelf resetView];
        [weakSelf.tableView reloadData];
    }];
}

- (void)loadCompanyInfo
{
    WEAK(self, weakSelf);
    NSString *companyName = IsStrEmpty(self.messageButton.titleLabel.text) ? @"" : self.messageButton.titleLabel.text;
    [SHGCompanyManager loadExactCompanyInfo:@{@"companyName":companyName, @"needCollect":@"true"} success:^(SHGCompanyObject *object) {
        weakSelf.companyObject = object;
    }];
}

- (void)didCreateOrModifyBusiness
{
    [self loadData];
    [self.businessMessageLabelView removeAllSubviews];
    [self.photoView removeAllSubviews];
}

- (void)addEmptyViewIfNeeded
{
    if ([self.responseObject.isDeleted isEqualToString:@"Y"]) {
        self.title = @"业务详情";
        self.navigationItem.rightBarButtonItem = nil;
        [self.view addSubview:self.emptyView];
    }

}

- (void)resetView
{
    
    [self addEmptyViewIfNeeded];

    
    [self loadCollectButtonState];
    
    [self loadRedView];
    
    [self loadUserAndMoneyView];
    
    [self loadBusinessMessageView];
    
    [self loadCompanyView];
    
    [self loadBPView];
    if ([UID isEqualToString:self.responseObject.createBy]) {
        self.editButton.hidden = NO;
        self.editLabel.hidden = NO;
        self.collectionButton.hidden = YES;
        self.collectionLabel.hidden = YES;
    } else {
        self.editButton.hidden = YES;
        self.editLabel.hidden = YES;
        self.collectionButton.hidden = NO;
        self.collectionLabel.hidden = NO;
    }
    [self loadInPutView];
    
    NSMutableParagraphStyle * contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [contentParagraphStyle setLineSpacing:MarginFactor(5.0f)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.responseObject.detail attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName: Color(@"3a3a3a"), NSParagraphStyleAttributeName:contentParagraphStyle}];
    self.contentTextView.attributedText = attributedString;
    
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(SCREENWIDTH - 2 * MarginFactor(12.0f), CGFLOAT_MAX)];
    self.contentTextView.sd_resetLayout
    .leftSpaceToView(self.representView, MarginFactor(14.0f))
    .rightSpaceToView(self.representView, MarginFactor(14.0f))
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(15.0f))
    .heightIs(size.height);
    
    if (self.responseObject.url.length > 0) {
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.headerView, MarginFactor(15.0f))
        .rightSpaceToView(self.headerView, MarginFactor(15.0f))
        .topSpaceToView(self.representView, MarginFactor(15.0f))
        .heightIs(MarginFactor(135.0f) + 64.0f);
        self.photoView.clipsToBounds = YES;
        SDPhotoGroup * photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.url];
        [temp addObject:item];
        photoGroup.photoItemArray = temp;
        [self.photoView addSubview:photoGroup];
    }
    self.headerView.hidden = NO;
    [self.headerView layoutSubviews];
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)loadInPutView
{
    if ([self.responseObject.createBy isEqualToString:UID]) {
        self.complainButton.hidden = YES;
        self.complainLabel.hidden = YES;
        self.phoneButton.hidden = YES;
        self.phoneLabel.hidden = YES;
        UIImage *editImage = [UIImage imageNamed:@"newBusiness_edit"];
        if ([self.responseObject.businessauditstate isEqualToString:@"0"] || [self.responseObject.businessauditstate isEqualToString:@"9"]){
            [self.editButton setImage:editImage forState:UIControlStateNormal];
            self.editButton.enabled = YES;
        } else{
            [self.editButton setImage:[UIImage imageNamed:@"newBusiness_unEdit"] forState:UIControlStateNormal];
            self.editButton.enabled = NO;
        }
        
        self.editButton.sd_resetLayout
        .topSpaceToView(self.inputView, MarginFactor(8.0f))
        .centerXIs(SCREENWIDTH/3)
        .widthIs(SCREENWIDTH/4)
        .heightIs(editImage.size.height);
        
        self.editLabel.sd_resetLayout
        .topSpaceToView(self.editButton, MarginFactor(4.0f))
        .centerXIs(SCREENWIDTH/3)
        .widthIs(SCREENWIDTH/4)
        .heightIs(self.editLabel.font.lineHeight);
        
        UIImage *commentImage = [UIImage imageNamed:@"red_businessComment"];
        [self.commentButton setImage:commentImage forState:UIControlStateNormal];
        self.commentButton.sd_resetLayout
        .topSpaceToView(self.inputView, MarginFactor(8.0f))
        .centerXIs(2 * SCREENWIDTH/3)
        .widthIs(SCREENWIDTH/4)
        .heightIs(commentImage.size.height);
        
        self.commentLabel.sd_resetLayout
        .topSpaceToView(self.commentButton, MarginFactor(4.0f))
        .centerXIs(2 * SCREENWIDTH/3)
        .widthIs(SCREENWIDTH/4)
        .heightIs(self.commentLabel.font.lineHeight);
        
    } else{
        self.complainButton.hidden = NO;
        self.complainLabel.hidden = NO;
        self.phoneButton.hidden = NO;
        self.phoneLabel.hidden = NO;
    }
}

- (void)loadRedView
{
    if ([self.responseObject.complainNum isEqualToString:@"0"]) {
        self.complianNumButton.hidden = YES;
    } else{
        self.complianNumButton.hidden = NO;
    }
    [self.complianNumButton setTitle:[NSString stringWithFormat:@"投诉:%@",self.responseObject.complainNum] forState:UIControlStateNormal];
    NSString *title = self.responseObject.businessTitle;
    self.titleDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.titleDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleDetailLabel.textColor = Color(@"ffffff");
    self.titleDetailLabel.numberOfLines = 0;
    if (title.length < 10) {
        self.titleDetailLabel.font = BoldFontFactor(25.0f);
    } else if (title.length > 20){
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:19]];
        self.titleDetailLabel.font = BoldFontFactor(23.0f);
    } else{
        self.titleDetailLabel.font = BoldFontFactor(23.0f);
    }
    self.titleDetailLabel.text = title;
    if ([self.responseObject.type isEqualToString:@"moneyside"]) {
        [self.typeButton setTitle:@"投资机构" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"trademixed"]){
        [self.typeButton setTitle:@"银证业务" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"equityfinancing"]){
        [self.typeButton setTitle:@"股权融资" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"bondfinancing"]){
        [self.typeButton setTitle:@"债权融资" forState:UIControlStateNormal];
    }
    NSString *typeString = self.typeButton.titleLabel.text;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:FontFactor(12.0f),NSFontAttributeName,nil];
    CGRect typeRect = [typeString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MarginFactor(40.0f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
    NSString *areaString = self.areaButton.titleLabel.text;
    CGRect areaRect = [areaString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MarginFactor(40.0f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
    
    [self.typeButton setBackgroundImage:[[UIImage imageNamed:@"newBusiness_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.areaButton setBackgroundImage:[[UIImage imageNamed:@"newBusiness_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    self.typeButton.sd_resetLayout
    .leftEqualToView(self.firstHorizontalLine)
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(10.0f))
    .widthIs(typeRect.size.width + MarginFactor(28.0f))
    .heightIs(MarginFactor(20.0f));
    
    self.areaButton.sd_resetLayout
    .leftSpaceToView(self.typeButton, MarginFactor(9.0f))
    .centerYEqualToView(self.typeButton)
    .widthIs(areaRect.size.width + MarginFactor(48.0f))
    .heightIs(MarginFactor(20.0f));
}

- (void)loadUserAndMoneyView
{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:MarginFactor(6.0f)];
    
    NSString *money = @"";
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.middleContentArray];
    for (NSString *obj in tempArray) {
        if ([obj containsString:@"金额"]) {
            NSArray *array = [obj componentsSeparatedByString:@"："];
            if ([[array lastObject] length] == 0) {
                money = @"暂未说明";
            } else{
                money = [array lastObject];
            }
            [self.middleContentArray removeObject:obj];
        }
    }
    
    NSString *allMoney = [NSString stringWithFormat:@"%@\n%@",@"金额",money];
    NSMutableAttributedString *moneyStr= [[NSMutableAttributedString alloc] initWithString:allMoney attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName: Color(@"8d8d8d"), NSParagraphStyleAttributeName:paragraphStyle}];
    [moneyStr addAttribute:NSFontAttributeName value:FontFactor(14.0f) range:[allMoney rangeOfString:money]];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f04f46"] range: [allMoney rangeOfString:money]];
    self.moneyLabel.attributedText = moneyStr;
    
    NSString *sender = @"";
    NSString *allSender = @"";
    if ([self.responseObject.realName isEqualToString:@"大牛助手"]) {
        sender = @"委托大牛助手";
        self.userButton.hidden = YES;
        allSender = [NSString stringWithFormat:@"%@\n%@",@"发布人",sender];
    } else{
        sender = self.responseObject.realName;
        if (self.responseObject.realName.length > 7) {
            sender = [NSString stringWithFormat:@"%@...",[sender substringToIndex:7]];
            allSender = [NSString stringWithFormat:@"%@\n%@...",@"发布人",[sender substringToIndex:7]];
        } else{
            allSender = [NSString stringWithFormat:@"%@\n%@",@"发布人",sender];
        }
    }
    
    
    NSMutableAttributedString *senderStr= [[NSMutableAttributedString alloc] initWithString:allSender attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName: Color(@"8d8d8d"), NSParagraphStyleAttributeName:paragraphStyle}];
    [senderStr addAttribute:NSFontAttributeName value:FontFactor(14.0f) range:[allSender rangeOfString:sender]];
    [senderStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f04f46"] range: [allSender rangeOfString:sender]];
    self.userLabel.attributedText = senderStr;
}

- (void)loadBusinessMessageView
{
    self.businessMessageLabel.text = @"业务信息";
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.middleContentArray];
    for (NSString *obj in tempArray) {
            if ([obj containsString:@"地区"]) {
//            NSArray *array = [obj componentsSeparatedByString:@"："];
//            [self.areaButton setTitle:[array lastObject] forState:UIControlStateNormal];
            [self.middleContentArray removeObject:obj];
        }
    }
    
    if (self.object.cityName.length == 0) {
        [self.areaButton setTitle:self.responseObject.position forState:UIControlStateNormal];
    } else{
        [self.areaButton setTitle:self.responseObject.cityName forState:UIControlStateNormal];
    }
    __block NSMutableArray *leftArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *rightArray = [[NSMutableArray alloc] init];
    [leftArray removeAllObjects];
    [rightArray removeAllObjects];
    [self.middleContentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [obj componentsSeparatedByString:@"："];
        [leftArray addObject:[array firstObject]];
        [rightArray addObject:[array lastObject]];
    }];
    [leftArray insertObject:@"发布时间" atIndex:0];
    [rightArray insertObject:[self.object.modifyTime substringToIndex:10] atIndex:0];
    NSInteger topMargin = MarginFactor(21.0f);
    NSString *rightString = @"";
    CGFloat height = 0.0f;
    NSMutableParagraphStyle * labelParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    labelParagraphStyle.alignment = NSTextAlignmentRight;
    [labelParagraphStyle setLineSpacing:MarginFactor(5.0f)];
    for (NSInteger i = 0; i < rightArray.count - 2 ; i ++) {
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = Color(@"3a3a3a");
        rightLabel.font = FontFactor(14.0f);
        rightString = [rightArray objectAtIndex:i];
        NSMutableAttributedString *string= [[NSMutableAttributedString alloc] initWithString:rightString attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName: Color(@"3a3a3a"), NSParagraphStyleAttributeName:labelParagraphStyle}];
        rightLabel.attributedText = string;
        [rightLabel sizeToFit];
        CGSize size = [rightLabel sizeThatFits:CGSizeMake(MarginFactor(223.0f), CGFLOAT_MAX)];
        rightLabel.frame = CGRectMake(MarginFactor(125.0f), height +  i * topMargin , MarginFactor(223.0f), size.height);
        [self.businessMessageLabelView addSubview:rightLabel];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.textColor = Color(@"8d8d8d");
        leftLabel.font = FontFactor(14.0f);
        leftLabel.text = [leftArray objectAtIndex:i];
        leftLabel.frame = CGRectMake(0.0f, height +  i * topMargin - 1, MarginFactor(120.0f),leftLabel.font.lineHeight);
        [self.businessMessageLabelView addSubview:leftLabel];
        
        height =  height + size.height  ;
        
    }
    self.businessMessageLabelView.sd_resetLayout
    .leftEqualToView(self.secondHorizontalLine)
    .rightEqualToView(self.secondHorizontalLine)
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(14.0f))
    .heightIs(height + (rightArray.count-3) * topMargin );
    

    
}

- (void)loadBPView
{
    if (self.responseObject.bpnameList) {
        self.BPView.hidden = NO;
        self.BPLine.backgroundColor = Color(@"e6e7e8");
        self.representView.sd_resetLayout
        .leftSpaceToView(self.headerView, 0.0f)
        .rightSpaceToView(self.headerView, 0.0f)
        .topSpaceToView(self.BPView, 0.0f);
        self.BPLabel.text = @"项目BP";
        CGFloat buttonWidth = SCREENWIDTH / 3.0;
        CGFloat labelWidth = (SCREENWIDTH - MarginFactor(60.0f)) / 3.0;
        CGFloat buttonHeight = MarginFactor(95.0f);
        for (NSInteger i = 0 ; i < self.responseObject.bpnameList.count ; i ++) {
            SHGBusinessPDFObject *obj = [[SHGBusinessPDFObject alloc] init];
            NSDictionary *dicName = [self.responseObject.bpnameList objectAtIndex:i];
            NSDictionary *dicPath = [self.responseObject.bppathList objectAtIndex:i];
            obj.bpName = [dicName valueForKey:@"bpname"];
            obj.bpPath = [dicPath valueForKey:@"bppath"];
            SHGBusinessCategoryButton *button = [SHGBusinessCategoryButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(i * buttonWidth , MarginFactor(15.0f) , buttonWidth, buttonHeight);
            button.frame = frame;
            button.object = obj;
            [self.BPButtonView addSubview:button];
            [button addTarget:self action:@selector(pdfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *nameLabel = [[UILabel alloc] init];
            if (obj.bpName.length > 8) {
                NSMutableString *name = [[NSMutableString alloc] initWithString:obj.bpName];
                [name insertString:@"\n" atIndex:8];
                if (name.length > 16) {
                    nameLabel.text = [NSString stringWithFormat:@"%@...",[name substringToIndex:16]];
                } else{
                    nameLabel.text = name;
                }
            } else{
                nameLabel.text = obj.bpName;
            }
            nameLabel.numberOfLines = 0;
            nameLabel.font = FontFactor(11.0f);
            nameLabel.textColor = Color(@"8d8d8d");
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.frame = CGRectMake(MarginFactor(10.0f) + i *(MarginFactor(20.0f) + labelWidth), MarginFactor(65.0f), labelWidth, MarginFactor(40.0f));
            [self.BPButtonView addSubview:nameLabel];
            
        }
        
    } else{
        self.BPView.hidden = YES;
    }

}

- (void)loadCompanyView
{
    if (self.responseObject.businessCompanyName.length > 0) {
        self.companyView.hidden = NO;
        self.companyLabel.text = @"公司信息";
        [self.messageButton setTitle:self.responseObject.businessCompanyName forState:UIControlStateNormal];
        [self.messageRightButton setImage:[UIImage imageNamed:@"rightArrowImage"] forState:UIControlStateNormal];
        [self loadCompanyInfo];
    } else{
        self.companyView.hidden = YES;
        self.businessMessageView.sd_layout
        .topSpaceToView(self.firstGrayView, 0.0f)
        .leftSpaceToView(self.headerView, 0.0f)
        .rightSpaceToView(self.headerView, 0.0f);
    }

}

- (void)pdfButtonClick:(SHGBusinessCategoryButton *)btn
{
    SHGBusinessPDFObject *obj = [[SHGBusinessPDFObject alloc] init];
    obj = btn.pdfObject;
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@",self.responseObject.businessID,self.responseObject.type] type:@"business_bp"];
    LinkViewController *viewController = [[LinkViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.bpPath];
    viewController.linkTitle = obj.bpName;
    viewController.url = url;
    [self.navigationController pushViewController:viewController animated:YES];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.contentTextView resignFirstResponder];
    if (scrollView.contentSize.height > CGRectGetHeight(scrollView.frame) + CGRectGetHeight(self.redView.frame)) {
        
        if (!self.navigationItem.titleView) {
            self.navigationItem.titleView = self.titleLabel;
        }

        if (scrollView.contentOffset.y > CGRectGetHeight(self.redView.frame)){
            self.titleLabel.alpha = 1.0f;
        }
        if (scrollView.contentOffset.y < CGRectGetHeight(self.redView.frame)){
            self.titleLabel.alpha = scrollView.contentOffset.y  / CGRectGetHeight(self.redView.frame);
        }
    }
}

#pragma mark -- 删除评论
- (void)longPressGesturecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
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
    self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
}
//删除
- (void)deleteButton
{
    WEAK(self, weakSelf);
    [SHGBusinessManager deleteCommentWithID:self.commentObject.commentId finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf.responseObject.commentList removeObject:weakSelf.commentObject];
            [weakSelf.tableView reloadData];
        }
    }];
    [self.view sendSubviewToBack:PickerBackView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma  mark ----btnClick---

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

- (IBAction)complainButtonClick:(UIButton *)sender
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            [SHGBusinessManager getBusinessComplainBlock:^(BOOL success, NSString *allowCreate) {
                if (success) {
                    if ([allowCreate boolValue] == YES) {
                        SHGBusinessComplainViewController *viewController = [[SHGBusinessComplainViewController alloc] init];
                        viewController.object = self.responseObject;
                        [self.navigationController pushViewController:viewController animated:YES];
                    } else{
                        [Hud showMessageWithText:@"今日投诉次数已经用完"];
                    }
                }
            }];
            
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能发起投诉哦～"];
    
}

- (IBAction)comanyButtonClick:(UIButton *)button
{
    if (self.companyObject) {
        SHGCompanyBrowserViewController *controller = [[SHGCompanyBrowserViewController alloc] init];
        controller.object = self.companyObject;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        SHGCompanyDisplayViewController *viewController = [[SHGCompanyDisplayViewController alloc] init];
        viewController.companyName = IsStrEmpty(button.titleLabel.text) ? @"" : button.titleLabel.text;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)comment:(id)sender
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            self.popupView.delegate = self;
            self.popupView.sendColor = @"429fff";
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
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能发起评论哦～"];
    
}

- (void)replyClicked:(SHGBusinessCommentObject *)obj commentIndex:(NSInteger)index
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:obj.commentUserName];
            self.popupView.delegate = self;
            self.popupView.sendColor = @"429fff";
            self.popupView.fid = obj.commentUserId;
            self.popupView.detail = @"";
            self.popupView.rid = obj.commentId;
            self.popupView.type = @"repley";
            [self.navigationController.view addSubview:self.popupView];
            [self.popupView showWithAnimated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能发起评论哦～"];
}

- (void)rightUserClick:(NSInteger)index
{
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentOtherId name:obj.commentOtherName];
}

- (void)leftUserClick:(NSInteger)index
{
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentUserName];
}

- (void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    WEAK(self, weakSelf);
    [self.popupView hideWithAnimated:YES];
    
    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:nil finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    WEAK(self, weakSelf);
    [self.popupView hideWithAnimated:YES];
    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:fid finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void) loadCommentBtnState
{
    
}

- (IBAction)phoneNumClick:(UIButton *)sender
{
   
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            WEAK(self, weakSelf);
            [weakSelf makePhoneNum];
            NSString *leftTitle = @"发短信";
            if (self.mobileArray.count == 0 ) {
                leftTitle = nil;
            }
            if (self.mobileArray.count > 0 || self.phoneArray.count > 0) {
                [SHGBusinessManager getBusinessContactAuth:weakSelf.responseObject success:^(SHGBusinessContactAuthObject *contactAuthObject) {
                    weakSelf.contactAuthObject = contactAuthObject;
                    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"打电话或发短信将消耗1次联系\n对方的机会，今日剩余%@次",weakSelf.contactAuthObject.userContactLimit] attributes:@{NSFontAttributeName:FontFactor(15.0f),NSForegroundColorAttributeName:Color(@"8d8d8d")}];
                    [textString addAttribute:NSForegroundColorAttributeName value:Color(@"f95c53") range:NSMakeRange(25, weakSelf.contactAuthObject.userContactLimit.length)];
                    if (weakSelf.contactAuthObject.contactShow) {
                        if (weakSelf.contactAuthObject.tipFlag) {
                            [weakSelf showContactAlertView:leftTitle text:textString];
                        } else{
                            [weakSelf showContactAlertView:leftTitle text:nil];
                        }
                    } else{
                        if ([weakSelf.contactAuthObject.businessContactLimit integerValue] > 0){
                            if ([weakSelf.contactAuthObject.userContactLimit integerValue] > 0) {
                                [weakSelf showContactAlertView:leftTitle text:textString];
                            } else{
                                if (!weakSelf.contactAuthObject.businessLicenceFlag) {
                                    if ([weakSelf.contactAuthObject.firstAuditValue integerValue] < 0) {
                                        [weakSelf showAlertView:[NSString stringWithFormat:@"您今日查看联系方式次数已用完，\n认证营业执照后每日可查看%@条\n联系方式~",weakSelf.contactAuthObject.secondAudit] leftTitle:@"我知道了" rightTitle:@"现在认证"];
                                    } else{
                                        [Hud showMessageWithText:@"营业执照认证中，通过认证后方可\n查看更多联系方式"];
                                    }
                                    
                                } else{
                                    [weakSelf showAlertView:@"您今日的查看次数已用完~" leftTitle:nil rightTitle:@"确定"];
                                }
                            }
                            
                        } else{
                            [weakSelf showAlertView:@"该业务联系次数今日已达上限，\n明天早点哦~" leftTitle:nil rightTitle:@"确定"];
                        }
                    }
                }];
            }
            
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能查看联系方式哦~"];
}

- (void)showAlertView:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"无法查看" contentText:message leftButtonTitle:leftTitle rightButtonTitle:rightTitle];
    [alert show];
}

- (void)showContactAlertView:(NSString *)leftTitle text:(NSAttributedString *)text
{
    SHGBusinessContactAlertView *contactAlert = [[SHGBusinessContactAlertView alloc] initWithLeftButtonTitle:leftTitle rightButtonTitle:@"打电话"];
    contactAlert.text = text;
    contactAlert.touchOtherDismiss = YES;
    WEAK(self, weakSelf);
    contactAlert.leftBlock = ^{
        [SHGBusinessManager getBusinessCheckedNum:weakSelf.responseObject success:^(NSString *num) {
            if ([num integerValue] > 0) {
                [weakSelf sendMessage];
            } else{
                [weakSelf showAlertView:@"该业务联系次数今日已达上限，\n明天早点哦~" leftTitle:nil rightTitle:@"确定"];
            }
        }] ;
        
    };
    contactAlert.rightBlock = ^{
        [SHGBusinessManager getBusinessCheckedNum:weakSelf.responseObject success:^(NSString *num) {
            if ([num integerValue] > 0) {
                [weakSelf callPhone];
            } else{
                [weakSelf showAlertView:@"该业务联系次数今日已达上限，\n明天早点哦~" leftTitle:nil rightTitle:@"确定"];
            }
        }] ;
        
    };
    [contactAlert show];
}

- (void)rightItemClick:(id)sender
{
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", self.responseObject.businessID, self.responseObject.type] type:@"business_share"];
    [[SHGBusinessManager shareManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {
        
    }];
}

- (IBAction)collectionClick:(UIButton *)sender {
    WEAK(self, weakSelf);
    
    if (self.responseObject.isCollection) {
        [SHGBusinessManager unCollectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = NO;
                [weakSelf loadCollectButtonState];
                [Hud showMessageWithText:@"取消收藏成功"];
                
            }
        }];
    } else {
        [SHGBusinessManager collectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = YES;
                [weakSelf loadCollectButtonState];
                [Hud showMessageWithText:@"收藏成功"];
            }
        }];
    }
    
}
- (void)loadCollectButtonState
{
    if (self.responseObject.isCollection) {
        [self.collectionButton setImage:[UIImage imageNamed:@"red_businessCollectied"] forState:UIControlStateNormal];
        self.isChangeCollection = YES;
    } else{
        [self.collectionButton setImage:[UIImage imageNamed:@"red_businessCollection"] forState:UIControlStateNormal];
        self.isChangeCollection = NO;
    }
}

- (IBAction)complianNumButtonClick:(UIButton *)sender
{
    SHGMyComplainViewController *viewController = [[SHGMyComplainViewController alloc] init];
    viewController.type = @"other";
    viewController.object = self.responseObject;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)userButton:(UIButton *)sender
{
    SHGPersonalViewController *viewController = [[SHGPersonalViewController alloc] init];
    if ([self.responseObject.realName isEqualToString:@"大牛助手"]) {
        viewController.userId = @"-2";
    } else{
        viewController.userId = self.responseObject.createBy;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tapTableHeaderView:(UITapGestureRecognizer *)recognizer
{
    [self.contentTextView resignFirstResponder];
}

- (void)callPhone
{
    NSMutableArray *array = [NSMutableArray array];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [self.mobileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
        [sheet addButtonWithTitle:obj];
    }];
    [self.phoneArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
        [sheet addButtonWithTitle:obj];
    }];
    if (array.count == 1) {
        [self openTel:[array firstObject]];
    } else {
        self.type = SHGTapPhoneTypeDialNumber;
        [sheet showInView:self.view];
    }

}

- (void)sendMessage
{
    NSMutableArray *array = [NSMutableArray array];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [self.mobileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
        [sheet addButtonWithTitle:obj];
    }];
    if (array.count == 1) {
        [[SHGGloble sharedGloble] showMessageView:array body:@"你好，我在大牛圈看到您发布的业务，请问"];
    } else {
        self.type = SHGTapPhoneTypeSendMessage;
        [sheet showInView:self.view];
    }
   
}



- (void)makePhoneNum
{
    [self.mobileArray removeAllObjects];
    [self.phoneArray removeAllObjects];
    __block NSString *string = @"";
    [self.middleContentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [obj componentsSeparatedByString:@":"];
        if ([obj containsString:@"联系方式"]) {
            string =[array lastObject];
        }
    }];
        NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@":", @"：", @"，", @",", @" ", @"\n"]]];
        
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"((13|15|18|17)[0-9]{9})"];
            if ([mobilePredicate evaluateWithObject:obj]) {
                [self.mobileArray addObject:obj];
            }
            
            NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(0[1,2]{1}\\d{1}-?\\d{8})|(0[3-9] {1}\\d{2}-?\\d{7,8})|(0[1,2]{1}\\d{1}-?\\d{8}-(\\d{1,4}))|(0[3-9]{1}\\d{2}-? \\d{7,8}-(\\d{1,4}))|0[7,8]\\d{2}-?\\d{8}|0\\d{2,3}-?\\d{7,8}"];
            if ([phonePredicate evaluateWithObject:obj]) {
                [self.phoneArray addObject:obj];
            }
        }];
        NSLog(@"%@", string);
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

#pragma mark -- sdc
#pragma mark -- 拨打电话

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *string = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (self.type == SHGTapPhoneTypeSendMessage) {
            [[SHGGloble sharedGloble] showMessageView:@[string] body:@"你好，我在大牛圈看到您发布的业务，请问"];
        } else {
            [self openTel:string];
        }
    }
}

- (BOOL)openTel:(NSString *)tel
{
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", self.responseObject.businessID, self.responseObject.type] type:@"business_call"];
    NSString *str = [NSString stringWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.popupView) {
        [self.popupView hideWithAnimated:NO];
    }
    if (self.isChangeCollection == NO) {
        [self.collectionController changeBusinessCollection];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

@interface SHGBusinessCategoryButton()

@end

@implementation SHGBusinessCategoryButton

- (void)setObject:(id)object
{
    if ([object isKindOfClass:[SHGBusinessPDFObject class]]) {
        SHGBusinessPDFObject *businessPdfObject = (SHGBusinessPDFObject *)object;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = MarginFactor(2.0f);
        style.alignment = NSTextAlignmentCenter;
        NSString *name = businessPdfObject.bpName;
        if (name.length > 16) {
            businessPdfObject.bpName = [NSString stringWithFormat:@"%@...",[name substringToIndex:15]];
        }
        style.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FontFactor(11.0f), NSForegroundColorAttributeName:Color(@"8d8d8d"), NSParagraphStyleAttributeName:style}];
        UIImage *image = [UIImage imageNamed:@"business_pdf"];
        [self setAttributedTitle:title image:image];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel sizeToFit];
    }
    _pdfObject = object;
}


@end


