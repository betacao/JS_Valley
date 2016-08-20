//
//  CircleDetailViewController.m
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "SHGLinkViewController.h"
#import "TWEmojiKeyBoard.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "CircleListDelegate.h"
#import "ReplyTableViewCell.h"
#import "CTTextDisplayView.h"
#import "SHGAuthenticationView.h"
#import "SHGMainPageTableViewCell.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SDPhotoBrowser.h"
#import "CCLocationManager.h"

#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 28.0f
#define kItemMargin 7.0f * XFACTOR

@interface CircleDetailViewController ()<CircleListDelegate, CTTextDisplayViewDelegate, UIWebViewDelegate, SDPhotoBrowserDelegate>
{
    UIControl *backView;
    UIView *PickerBackView;
    NSString *copyString;
    NSString *commentRid;

}
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *faSongBtn;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIView *spliteView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnCollet;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnComment;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnPraise;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnShare;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnDelete;
@property (weak, nonatomic) IBOutlet UIView *viewPraise;
@property (weak, nonatomic) IBOutlet UIButton *praisebtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet CTTextDisplayView *titleLabel;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *lblContent;
@property (weak, nonatomic) IBOutlet SHGMainPageBusinessView *businessView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;
@property (weak, nonatomic) IBOutlet UILabel *lbldepartName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *imageHeader;
@property (strong, nonatomic) BRCommentView *popupView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) UIView *photoView;

@property (strong, nonatomic) NSArray *webPhotoArray;
@property (strong, nonatomic) CircleListObj *responseObject;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态详情";
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
    [self initView];
    [self addSdLayout];

    WEAK(self, weakSelf);
    [Hud showWait];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circledetail"] parameters:@{@"rid":self.rid,@"uid":UID} success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"%@  arr === %@",response.data,response.dataDictionary);
        if (response.dataDictionary) {
            [weakSelf parseDataWithDictionary:response.dataDictionary];
            [weakSelf resetView];
            [weakSelf detailHomeListShouldRefresh:weakSelf.responseObject];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
    [SHGGlobleOperation registerPraiseClass:[self class] method:@selector(loadPraiseState:praiseState:)];
    [SHGGlobleOperation registerDeleteClass:[self class] method:@selector(loadDelete:)];
}

- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.personView.backgroundColor = Color(@"f7f7f7");
    self.nickName.font = kMainNameFont;
    self.nickName.textColor = kMainNameColor;

    self.lblCompanyName.font = kMainCompanyFont;
    self.lblCompanyName.textColor = kMainCompanyColor;

    self.lbldepartName.font = kMainCompanyFont;
    self.lbldepartName.textColor = kMainCompanyColor;

    self.lblTime.font = kMainTimeFont;
    self.lblTime.textColor = kMainTimeColor;


    self.btnCollet = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnCollet setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnCollet target:self addSeletor:@selector(actionCollection:)];

    self.btnDelete = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnDelete setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnDelete target:self addSeletor:@selector(actionDelete:)];

    self.btnPraise = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnPraise setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnPraise target:self addSeletor:@selector(actionPraise:)];

    self.btnComment = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnComment setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnComment target:self addSeletor:@selector(actionComment:)];

    self.btnShare = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnShare setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnShare target:self addSeletor:@selector(actionShare:)];

    [self.actionView sd_addSubviews:@[self.btnCollet, self.btnDelete, self.btnPraise, self.btnComment, self.btnShare]];

    [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailCollection"]];

    [self.btnDelete addImage:[UIImage imageNamed:@"home_delete"]];

    [self.btnPraise addImage:[UIImage imageNamed:@"home_weizan"]];
    self.btnPraise.margin = MarginFactor(7.0f);

    [self.btnComment addImage:[UIImage imageNamed:@"home_comment"]];
    self.btnComment.margin = MarginFactor(7.0f);

    [self.btnShare addImage:[UIImage imageNamed:@"homeShare"]];
    self.btnShare.margin = MarginFactor(7.0f);
    
    self.webView.scrollView.bounces = NO;

    CTTextStyleModel *model = [[CTTextStyleModel alloc] init];
    model.numberOfLines = -1;
    model.lineSpace = MarginFactor(5.0f);
    self.lblContent.styleModel = model;
    self.lblContent.delegate = self;

    CTTextStyleModel *titleModel = [[CTTextStyleModel alloc] init];
    model.numberOfLines = -1;
    titleModel.textColor = kMainTitleColor;
    titleModel.font = kMainTitleFont;
    self.titleLabel.styleModel = titleModel;
    self.titleLabel.delegate = self;

    self.btnSend.titleLabel.font = FontFactor(15.0f);
    self.btnSend.layer.masksToBounds = YES;
    self.btnSend.layer.cornerRadius = 3.0f;

    self.faSongBtn.titleLabel.font = FontFactor(16.0f);
    self.faSongBtn.layer.masksToBounds = YES;
    self.faSongBtn.layer.cornerRadius = 3.0f;
    self.faSongBtn.backgroundColor = [UIColor colorWithHexString:@"f04241"];

    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    self.spliteView.backgroundColor = Color(@"e2e2e2");

    UIImage *image = self.backImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;
}

- (void)addSdLayout
{
    self.viewInput.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(45.0f));

    self.faceBtn.sd_layout
    .leftSpaceToView(self.viewInput, kMainItemLeftMargin)
    .centerYEqualToView(self.viewInput)
    .widthIs(self.faceBtn.currentImage.size.width)
    .heightIs(self.faceBtn.currentImage.size.height);

    self.faSongBtn.sd_layout
    .rightSpaceToView(self.viewInput, kMainItemLeftMargin)
    .centerYEqualToView(self.viewInput)
    .widthIs(MarginFactor(70.0f))
    .heightIs(MarginFactor(35.0f));

    self.btnSend.sd_layout
    .rightSpaceToView(self.faSongBtn, MarginFactor(10.0f))
    .leftSpaceToView(self.faceBtn, MarginFactor(10.0f))
    .centerYEqualToView(self.viewInput);

    self.spliteView.sd_layout
    .topSpaceToView(self.viewInput, 0.0f)
    .leftSpaceToView(self.viewInput, 0.0f)
    .rightSpaceToView(self.viewInput, 0.0f)
    .heightIs(1 / SCALE);

    self.tableView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.viewInput, 0.0f);

    //headerView
    self.personView.sd_layout
    .topSpaceToView(self.tableHeaderView, 0.0f)
    .leftSpaceToView(self.tableHeaderView, 0.0f)
    .rightSpaceToView(self.tableHeaderView, 0.0f)
    .heightIs(MarginFactor(55.0f));

    self.imageHeader.sd_layout
    .leftSpaceToView(self.personView, kMainItemLeftMargin)
    .centerYEqualToView(self.personView)
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));

    self.nickName.sd_layout
    .topEqualToView(self.imageHeader)
    .offset(-1.0f)
    .leftSpaceToView(self.imageHeader, kMainItemLeftMargin)
    .autoHeightRatio(0.0f);
    [self.nickName setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lblCompanyName.sd_layout
    .bottomEqualToView(self.nickName)
    .leftSpaceToView(self.nickName,MarginFactor(7.0f))
    .autoHeightRatio(0.0);
    [self.lblCompanyName setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.lbldepartName.sd_layout
    .bottomEqualToView(self.lblCompanyName)
    .leftSpaceToView(self.lblCompanyName, 0.0f)
    .autoHeightRatio(0.0f);
    [self.lbldepartName setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.authenticationView.sd_layout
    .leftEqualToView(self.nickName)
    .bottomEqualToView(self.imageHeader);

    self.lblTime.sd_layout
    .leftSpaceToView(self.authenticationView, 0.0f)
    .bottomEqualToView(self.imageHeader)
    .autoHeightRatio(0.0f);
    [self.lblTime setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.btnAttention.sd_layout
    .rightSpaceToView(self.personView, kMainItemLeftMargin)
    .centerYEqualToView(self.imageHeader)
    .widthIs(self.btnAttention.currentImage.size.width)
    .heightIs(self.btnAttention.currentImage.size.height);

    self.titleLabel.sd_layout
    .topSpaceToView(self.personView, 0.0f)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .heightIs(0.0f);

    self.lblContent.sd_layout
    .topSpaceToView(self.titleLabel, 0.0f)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .heightIs(0.0f);

    self.webView.sd_layout
    .topSpaceToView(self.titleLabel, 0.0f)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin);

    self.photoView = [[UIView alloc] init];
    [self.tableHeaderView addSubview:self.photoView];

    self.btnShare.sd_layout
    .rightSpaceToView(self.actionView, 0.0f)
    .centerYEqualToView(self.actionView);

    self.btnComment.sd_layout
    .rightSpaceToView(self.btnShare, kMainActionButtonMargin)
    .centerYEqualToView(self.btnShare);

    self.btnPraise.sd_layout
    .rightSpaceToView(self.btnComment, kMainActionButtonMargin)
    .centerYEqualToView(self.btnShare);

    self.btnCollet.sd_layout
    .rightSpaceToView(self.btnPraise, kMainActionButtonMargin)
    .centerYEqualToView(self.btnShare);

    self.btnDelete.sd_layout
    .rightSpaceToView(self.btnCollet, kMainActionButtonMargin)
    .centerYEqualToView(self.btnShare);

    self.backImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.scrollPraise.sd_layout
    .leftSpaceToView(self.praisebtn, MarginFactor(10.0f))
    .centerYEqualToView(self.viewPraise)
    .rightSpaceToView(self.viewPraise, MarginFactor(10.0f) + CGRectGetMaxX(self.praisebtn.frame))
    .heightIs(MarginFactor(30.0f));

    self.praisebtn.sd_layout
    .leftSpaceToView(self.viewPraise, MarginFactor(11.0f))
    .centerYEqualToView(self.scrollPraise)
    .widthIs(self.praisebtn.currentImage.size.width)
    .heightIs(self.praisebtn.currentImage.size.height);

    self.lineView.sd_layout
    .leftSpaceToView(self.viewPraise, 0.0f)
    .rightSpaceToView(self.viewPraise, 0.0f)
    .bottomSpaceToView(self.viewPraise, 0.0f)
    .heightIs(1 / SCALE);

    self.tableHeaderView.hidden = YES;

    [self.tableHeaderView setupAutoHeightWithBottomView:self.viewPraise bottomMargin:0.0f];
    self.tableView.tableHeaderView = self.tableHeaderView;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleDetailViewController" label:@"onClick"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.popupView) {
        [self.popupView hideWithAnimated:NO];
    }
}

- (void)parseDataWithDictionary:(NSDictionary *)dictionary
{
    self.responseObject = [[CircleListObj alloc] init];
    NSArray *comments = [dictionary objectForKey:@"comments"];
    if (!IsArrEmpty(comments)) {
        self.responseObject.comments = [NSMutableArray array];
        for (NSDictionary *comment in comments) {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cdetail = [comment objectForKey:@"cdetail"];
            obj.cid = [comment objectForKey:@"cid"];
            obj.cnickname = [comment objectForKey:@"cnickname"];
            obj.rnickname = [comment objectForKey:@"rnickname"];
            obj.rid = [comment objectForKey:@"rid"];
            obj.replyid = [comment objectForKey:@"replyid"];
            [self.responseObject.comments addObject:obj];
        }
    }
    NSDictionary *dic = [[dictionary objectForKey:@"circle"] firstObject];
    self.responseObject.ispraise = [dic objectForKey:@"ispraise"];
    self.responseObject.iscollection = [dictionary objectForKey:@"iscollection"];
    NSArray *heads = [dictionary objectForKey:@"heads"];
    for (NSDictionary *head in heads) {
        praiseOBj *obj = [[praiseOBj alloc] init];
        obj.pnickname = [head objectForKey:@"pnickname"];
        obj.ppotname = [head objectForKey:@"ppotname"];
        obj.puserid = [head objectForKey:@"puserid"];
        [self.responseObject.heads addObject:obj];
    }

    self.responseObject.cmmtnum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cmmtnum"]];
    self.responseObject.company = [dic objectForKey:@"company"];
    self.responseObject.detail = [dic objectForKey:@"detail"];
    self.responseObject.isAttention = [[dic objectForKey:@"isattention"] isEqualToString:@"Y"] ? YES : NO;
    self.responseObject.nickname = [dic objectForKey:@"nickname"];
    self.responseObject.photos = [dic objectForKey:@"attach"];
    self.responseObject.potname = [dic objectForKey:@"potname"];
    self.responseObject.praisenum = [dic objectForKey:@"praisenum"];
    self.responseObject.publishdate = [dic objectForKey:@"publishdate"];
    self.responseObject.type = [dic objectForKey:@"attachtype"];
    self.responseObject.rid = [dic objectForKey:@"rid"];
    self.responseObject.sharenum = [dic objectForKey:@"sharenum"];
    self.responseObject.status = [dic objectForKey:@"status"];
    self.responseObject.title = [dic objectForKey:@"title"];
    self.responseObject.userstatus = [dic objectForKey:@"userstatus"];
    self.responseObject.businessStatus = [[dic objectForKey:@"businessstatus"] boolValue];
    self.responseObject.userid = [dic objectForKey:@"userid"];
    self.responseObject.groupPostTitle = [dic objectForKey:@"groupposttitle"];
    self.responseObject.groupPostUrl = [dic objectForKey:@"groupposturl"];
    self.responseObject.postType = [dic objectForKey:@"type"];
    self.responseObject.businessID = [dic objectForKey:@"businessid"];

}

- (void)shareSuccess
{
    self.responseObject.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.sharenum integerValue] + 1)];
}

- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *rid = obj;
        if ([self.responseObject.rid isEqualToString:rid]) {
            [self otherShareWithObj:self.responseObject];
        }
    }
}

- (void)detailHomeListShouldRefresh:(CircleListObj *)obj
{
    NSString *shareNum = obj.sharenum;
    NSString *commentNum =  obj.cmmtnum;
    NSString *praiseNum = obj.praisenum;
    if(![shareNum isEqualToString:[self.itemInfoDictionary objectForKey:kShareNum]] || ![commentNum isEqualToString:[self.itemInfoDictionary objectForKey:kCommentNum]] || ![praiseNum isEqualToString:[self.itemInfoDictionary objectForKey:kPraiseNum]]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(detailHomeListShouldRefresh:)]){
            [self.delegate detailHomeListShouldRefresh:obj];
        }
    }
}


- (void)resetView
{
    if ([self.responseObject.userid isEqualToString:UID] || [self.responseObject.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    }
    if ([self.responseObject.userid isEqualToString:UID]){
        self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }

    BOOL status = [self.responseObject.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.potname] placeholderImage:[UIImage imageNamed:@"default_head"] userID:self.responseObject.userid];
    [self.authenticationView updateWithStatus:status];
    if (![self.responseObject.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise addImage:[UIImage imageNamed:@"home_weizan"]];
    } else{
        [self.btnPraise addImage:[UIImage imageNamed:@"home_yizan"]];
    }
    if (![self.responseObject.iscollection isEqualToString:@"Y"]) {
        [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailNoCollection"]];
    } else{
        [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailCollection"]];
    }
    NSString *name = self.responseObject.nickname;
    if (self.responseObject.nickname.length > 4){
        name = [self.responseObject.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    self.nickName.text = name;
    //设置公司名称
    NSString *company = self.responseObject.company;
    if (self.responseObject.company.length > 6) {
        NSString *str = [self.responseObject.company substringToIndex:6];
        company = [NSString stringWithFormat:@"%@...",str];
    }
    self.lblCompanyName.text = company;
    //设置职位名称
    NSString *department = self.responseObject.title;
    if (self.responseObject.title.length > 4){
        department = [self.responseObject.title substringToIndex:4];
        department = [NSString stringWithFormat:@"%@...",department];
    }
    self.lbldepartName.text = department;

    self.lblTime.text = self.responseObject.publishdate;
    [self.btnShare addTitle:self.responseObject.sharenum];
    [self.btnComment addTitle:self.responseObject.cmmtnum];
    [self.btnPraise addTitle:self.responseObject.praisenum];

    if (self.responseObject.isAttention){
        [self.btnAttention setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
    }

    NSString *title = [[SHGGloble sharedGloble] formatStringToHtml:self.responseObject.groupPostTitle];
    self.titleLabel.text = title;
    if (title.length > 0) {
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.personView, kMainContentTopMargin)
        .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .heightIs([CTTextDisplayView getRowHeightWithText:title rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.titleLabel.styleModel]);
    }

    UIView *contentView = nil;
    if ([self.responseObject.postType isEqualToString:@"normalpc"]) {
        contentView = self.webView;
        self.lblContent.hidden = self.businessView.hidden = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.responseObject.groupPostUrl]]];
    } else if ([self.responseObject.postType isEqualToString:@"business"]) {
        contentView = self.businessView;
        self.lblContent.hidden = self.webView.hidden = YES;

        NSString *businessID = self.responseObject.businessID;
        SHGBusinessObject *businessObject = [[SHGBusinessObject alloc] init];
        NSArray *array = [businessID componentsSeparatedByString:@"#"];
        if (array.count == 2) {
            businessObject.businessTitle = self.responseObject.detail;
            businessObject.businessID = [array firstObject];
            businessObject.type = [array lastObject];
            self.businessView.object = businessObject;
        }

        self.businessView.sd_resetLayout
        .topSpaceToView(self.titleLabel, kMainContentTopMargin)
        .leftSpaceToView(self.tableHeaderView, 0.0f)
        .rightSpaceToView(self.tableHeaderView, 0.0f)
        .heightIs(MarginFactor(59.0f));

    } else {
        contentView = self.lblContent;
        self.businessView.hidden = self.webView.hidden = YES;

        NSString *detail = [[SHGGloble sharedGloble] formatStringToHtml:self.responseObject.detail];
        self.lblContent.text = detail;
        if (detail.length > 0) {
            self.lblContent.sd_resetLayout
            .topSpaceToView(self.titleLabel, kMainContentTopMargin / 2.0f)
            .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .heightIs([CTTextDisplayView getRowHeightWithText:detail rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.lblContent.styleModel]);
        }
    }
    if ([self.responseObject.type isEqualToString:TYPE_PHOTO]){
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [self.responseObject.photos enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,src];
            item.object = self.responseObject;
            [temp addObject:item];
        }];
        photoGroup.photoItemArray = temp;
        photoGroup.style = SDPhotoGroupStyleThumbnail;
        [self.photoView addSubview:photoGroup];
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .topSpaceToView(contentView, kMainPhotoViewTopMargin - self.lblContent.styleModel.lineSpace)
        .widthIs(CGRectGetWidth(photoGroup.frame))
        .heightIs(CGRectGetHeight(photoGroup.frame));
    } else {
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .topSpaceToView(contentView, 0.0f)
        .heightIs(0.0f);
    }

    CGFloat praiseWidth = CGRectGetHeight(self.scrollPraise.frame);
    [self.scrollPraise removeAllSubviews];
    for (NSInteger i = 0; i < self.responseObject.heads.count; i ++ ) {
        praiseOBj *obj = [self.responseObject.heads objectAtIndex:i];
        CGRect rect = CGRectMake((praiseWidth + MarginFactor(7.0f)) * i , 0.0f, praiseWidth, praiseWidth);
        SHGUserHeaderView *headerView = [[SHGUserHeaderView alloc] initWithFrame:rect];
        [headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname] placeholderImage:[UIImage imageNamed:@"default_head"] userID:obj.puserid];
        [self.scrollPraise addSubview:headerView];
    }
    [self.scrollPraise setContentSize:CGSizeMake(self.responseObject.heads.count *(praiseWidth + PRAISE_SEPWIDTH), praiseWidth)];
    self.actionView.sd_resetLayout
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .topSpaceToView(self.photoView, 0.0f)
    .heightIs(kMainActionHeight);

    self.viewPraise.sd_resetLayout
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .topSpaceToView(self.actionView, 0.0f)
    .heightIs(MarginFactor(56.0f));

    self.tableHeaderView.hidden = NO;

    [self.tableHeaderView setNeedsLayout];
    [self.tableHeaderView layoutIfNeeded];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

- (void)replyClick:(NSInteger )index
{
    [self replyClicked:self.responseObject commentIndex:index];
}

- (void)sizeUIWithObj:(CircleListObj *)obj
{
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4) {
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    self.nickName.text = name;
}

- (IBAction)actionComment:(id)sender
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            _popupView.delegate = self;
            _popupView.fid = @"-1";//评论
            _popupView.tag = 222;
            _popupView.detail = @"";
            _popupView.rid = self.responseObject.rid;
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

#pragma mark -- 评论
- (void)loadCommentBtnState
{
    NSString *memory = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_MEMORY];
    if ([memory isEqualToString:@""]){
        [self.btnSend setTitle:@"说点什么吧" forState:UIControlStateNormal];
        [self.btnSend setTitleColor:[UIColor colorWithHexString:@"a5a5a5"] forState:UIControlStateNormal];
    } else{
        [self.btnSend setTitle:memory forState:UIControlStateNormal];
        [self.btnSend setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    }
}

- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"rid":rid, @"fid":@"-1", @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            NSDictionary *dic =response.dataDictionary;
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.rid = [dic valueForKey:@"rid"];
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [self.responseObject.comments addObject:obj];
            self.responseObject.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.cmmtnum integerValue] + 1)];
        }
        [self.tableView reloadData];
        [self resetView];
        [self.delegate detailCommentWithRid:self.responseObject.rid commentNum:self.responseObject.cmmtnum comments:self.responseObject.comments];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
        [self loadCommentBtnState];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];

}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *) reply fid:(NSString *) fid rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    commentOBj *cmntObj= [[commentOBj alloc] init];
    for (commentOBj *cObj in self.responseObject.comments)
    {
        if ([cObj.cid isEqualToString:fid]) {
            cmntObj = cObj;
            break;
        }
    }
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"rid":rid, @"fid":cmntObj.cid, @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            obj.rid = rid;
            obj.rnickname = cmntObj.cnickname;
            [self.responseObject.comments addObject:obj];
            self.responseObject.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.cmmtnum integerValue] + 1)];
            [MobClick event:@"ActionCommentClick" label:@"onClick"];
        }
        [self.tableView reloadData];
        [self resetView];
        [self.delegate detailCommentWithRid:self.responseObject.rid commentNum:self.responseObject.cmmtnum comments:self.responseObject.comments];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
        [self loadCommentBtnState];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];

}

- (void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            commentOBj *cmbObj = obj.comments[index];
            _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:cmbObj.cnickname];
            _popupView.delegate = self;
            _popupView.fid=cmbObj.cid;//评论
            _popupView.tag = 222;
            _popupView.detail=@"";
            _popupView.rid = obj.rid;
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

- (void)actionPraise:(id)sender
{
    [SHGGlobleOperation addPraise:self.responseObject];
}

- (void)actionShare:(id)sender
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *postContent = @"";
    NSString *shareContent = @"";
    NSString *shareTitle = @"";
    NSString *title = @" ";
    if (self.responseObject.groupPostTitle.length > 0) {
        title = self.responseObject.groupPostTitle;
    }
    if(IsStrEmpty(self.responseObject.detail)){
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = self.responseObject.detail;
        shareTitle = self.responseObject.detail;
        shareContent = self.responseObject.detail;
    }
    if(self.responseObject.detail.length > 30){
        postContent = [NSString stringWithFormat:@"%@...",[self.responseObject.detail substringToIndex:30]];
    }
    if(self.responseObject.detail.length > 30){
        shareTitle = [self.responseObject.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@...",[self.responseObject.detail substringToIndex:30]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.responseObject.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.responseObject.rid type:@"dynamic_shareDynamic"];
        [self circleShareWithObj:self.responseObject];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{

        [[SHGGloble sharedGloble] recordUserAction:self.responseObject.rid type:@"dynamic_shareSystemUser"];
        [self shareToFriendWithText:self.responseObject.detail];
    }];

    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:self.responseObject.rid];
    }];

    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.responseObject.rid type:@"dynamic_shareMicroCircle"];
        [[AppDelegate currentAppdelegate]wechatShare:self.responseObject shareType:1];
    }];

    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.responseObject.rid type:@"dynamic_shareMicroFriend"];
        [[AppDelegate currentAppdelegate]wechatShare:self.responseObject shareType:0];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item3,item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType:  item5, item4, item3, item1, item2, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: SHARE_TYPE_NUMBER(ShareTypeQQ), item3, item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, item2, nil];
        }
    }

    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.responseObject.rid];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:title url:shareUrl description:shareContent mediaType:SHARE_TYPE];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:self.responseObject];
            [[SHGGloble sharedGloble] recordUserAction:self.responseObject.rid type:@"dynamic_shareQQ"];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"帖子分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}

-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[SHGGloble sharedGloble] recordUserAction:rid type:@"dynamic_shareSms"];
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}

- (void)shareToFriendWithText:(NSString *)text
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",self.responseObject.nickname,text];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = shareText;
    vc.shareRid = self.responseObject.rid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)otherShareWithObj:(CircleListObj *)obj
{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":UID};
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [weakSelf.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

            [weakSelf resetView];
            [weakSelf.tableView reloadData];
            [Hud showMessageWithText:@"帖子分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

-(void)circleShareWithObj:(CircleListObj *)obj
{
    if ([[SHGGloble sharedGloble].cityName isEqualToString:@""]) {
        [[CCLocationManager shareLocation] getCity:nil];
    }
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:@{@"uid":UID,@"currCity":[SHGGloble sharedGloble].cityName} success:^(MOCHTTPResponse *response) {

                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    self.responseObject.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.sharenum integerValue] + 1)];
                    [self resetView];
                    [Hud showMessageWithText:@"帖子分享成功"];
                    [self.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
                }
            } failed:^(MOCHTTPResponse *response) {
                [Hud showMessageWithText:response.errorMessage];
            }];
        }else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity"];
        }

        
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity_cancel"];
    } failString:@"认证后才能发起分享哦～"];
}

#pragma mark -收藏
- (void)actionCollection:(id)sender
{
    [Hud showWait];
    WEAK(self, weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circlestore"];
    NSDictionary *param = @{@"uid":UID, @"rid":self.responseObject.rid};
    if (![self.responseObject.iscollection isEqualToString:@"Y"]){
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                weakSelf.responseObject.iscollection = @"Y";
            }
            [weakSelf resetView];
            [Hud showMessageWithText:@"收藏成功"];
            [MobClick event:@"ActionCollection_On" label:@"onClick"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                [weakSelf.delegate detailCollectionWithRid:weakSelf.responseObject.rid collected:weakSelf.responseObject.iscollection];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{

        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                weakSelf.responseObject.iscollection = @"N";
            }
            [weakSelf resetView];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                [weakSelf.delegate detailCollectionWithRid:weakSelf.responseObject.rid collected:weakSelf.responseObject.iscollection];
            }
            [MobClick event:@"ActionCollection_Off" label:@"onClick"];
            [Hud showMessageWithText:@"取消收藏"];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    if ([self.responseObject.userid isEqualToString:targetUserID]) {
        self.responseObject.isAttention = [attationState boolValue];
        if (self.responseObject.isAttention){
            [self.btnAttention setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
        } else{
            [self.btnAttention setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
        }
    }
}

- (void)loadPraiseState:(NSString *)targetID praiseState:(NSNumber *)praiseState
{
    if ([praiseState boolValue]) {
        self.responseObject.ispraise = @"Y";
        self.responseObject.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.praisenum integerValue] + 1)];
        praiseOBj *obj = [[praiseOBj alloc] init];
        obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
        obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
        obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
        [self.responseObject.heads addObject:obj];
        [self resetView];
    } else {
        self.responseObject.ispraise = @"N";
        self.responseObject.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.praisenum integerValue] - 1)];
        for (praiseOBj *obj in self.responseObject.heads) {
            if ([obj.puserid isEqualToString:UID]) {
                [self.responseObject.heads removeObject:obj];
                break;
            }
        }
        [self resetView];
    }
}

- (void)loadDelete:(NSString *)targetID
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAttention:(id)sender
{
    [SHGGlobleOperation addAttation:self.responseObject];
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.responseObject.comments.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil] lastObject];
    }

    cell.controller = self;
    SHGCommentType type = SHGCommentTypeNormal;
    if(indexPath.row == 0){
        type = SHGCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.comments.count - 1){
        type = SHGCommentTypeLast;
    }
    if (indexPath.row == 0 && indexPath.row == self.responseObject.comments.count - 1) {
        type = SHGCommentTypeOnly;
    }
    cell.dataArray = @[obj, @(type)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    SHGCommentType type = SHGCommentTypeNormal;
    if(indexPath.row == 0){
        type = SHGCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.comments.count - 1){
        type = SHGCommentTypeLast;
    }
    if (indexPath.row == 0 && indexPath.row == self.responseObject.comments.count - 1) {
        type = SHGCommentTypeOnly;
    }
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:@[obj, @(type)] keyPath:@"dataArray" cellClass:[ReplyTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    copyString = obj.cdetail;
    commentRid = obj.rid;
    if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        [self createPickerView];
    } else{
        [self replyClick:indexPath.row];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (![request.URL.absoluteString isEqualToString:self.responseObject.groupPostUrl]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud showWait];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Hud hideHud];
        WEAK(self, weakSelf);
        [SHGGloble addHtmlListener:webView key:@"openImageBrowser" block:^{
            NSArray *args = [JSContext currentArguments];
            NSInteger index = 0;
            index = [[args firstObject] toInt32];
            weakSelf.webPhotoArray = [[args lastObject] toArray];

            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            browser.imageCount = weakSelf.webPhotoArray.count;
            browser.currentImageIndex = index;
            browser.delegate = weakSelf;
            [browser show];
        }];

        CGRect frame = webView.frame;
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        webView.frame = frame;

        [self.tableHeaderView setNeedsLayout];
        [self.tableHeaderView layoutIfNeeded];
        self.tableView.tableHeaderView = self.tableHeaderView;
    });
}


- (void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    if ([self.responseObject.rid isEqualToString:rid]) {
        self.responseObject.sharenum = num;
    }
    [self resetView];
    [self.tableView reloadData];
    [self.delegate detailShareWithRid:rid shareNum:num];

}

-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    if ([self.responseObject.rid isEqualToString:rid]){
        self.responseObject.cmmtnum = num;
        self.responseObject.comments = comments;
    }
    [self resetView];
    [self.tableView reloadData];
    [self.delegate detailCommentWithRid:rid commentNum:num comments:comments];

}

- (void)actionDelete:(id)sender
{
    [SHGGlobleOperation deleteObject:self.responseObject];

}

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)obj;
        NSString *key = [[dictionary objectForKey:@"key"] lowercaseString];
        if ([key isEqualToString:@"u"]) {
            SHGLinkViewController *controller = [[SHGLinkViewController alloc] init];
            controller.url = [dictionary objectForKey:@"value"];
            [[SHGHomeViewController sharedController].navigationController pushViewController:controller animated:YES];
        } else if([key isEqualToString:@"p"]) {
            [self openTel:[dictionary objectForKey:@"value"]];
        }
    }
}

- (BOOL)openTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -- sdc
#pragma mark -- 删除评论
- (void)longPressGesturecognized:(UIGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    switch (state){
        case UIGestureRecognizerStateBegan:{
            if (indexPath){
                //判断是否是自己
                commentOBj *obj = self.responseObject.comments[indexPath.row];
                commentRid = obj.rid;
                copyString = obj.cdetail;

                if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]){
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
    [UIPasteboard generalPasteboard].string = copyString;
    [self.view sendSubviewToBack:PickerBackView];
}

//删除
- (void)deleteButton
{
    NSDictionary *param = @{@"rid":commentRid};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"deleteComments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"%@",response.dataDictionary);
        for (commentOBj *obj in self.responseObject.comments){
            if ([obj.rid  isEqualToString:commentRid]){
                [self.responseObject.comments removeObject:obj];
                self.responseObject.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.cmmtnum integerValue] - 1)];
                break;
            }
        }
        [self resetView];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.responseObject];
    } failed:^(MOCHTTPResponse *response){
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"response.errorMessage==%@",response.errorMessage);
    }];
    //tableView适应屏幕
    self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
    
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [self.webPhotoArray objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
