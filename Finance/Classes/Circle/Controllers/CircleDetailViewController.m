//
//  CircleDetailViewController.m
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "LinkViewController.h"
#import "TWEmojiKeyBoard.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGPersonalViewController.h"
#import "CircleListDelegate.h"
#import "ReplyTableViewCell.h"
#import "CTTextDisplayView.h"
#import "SHGAuthenticationView.h"
#import "SHGMainPageTableViewCell.h"

#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 28.0f
#define kItemMargin 7.0f * XFACTOR

@interface CircleDetailViewController ()<CircleListDelegate, ReplyDelegate, CTTextDisplayViewDelegate, UIWebViewDelegate>
{
    UIControl *backView;
    UIView *PickerBackView;
    NSString *copyString;
    NSString *commentRid;

}
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet SHGHorizontalTitleImageButton *btnCollet;
@property (weak, nonatomic) IBOutlet SHGHorizontalTitleImageButton *btnComment;
@property (weak, nonatomic) IBOutlet SHGHorizontalTitleImageButton *btnPraise;
@property (weak, nonatomic) IBOutlet SHGHorizontalTitleImageButton *btnShare;
@property (weak, nonatomic) IBOutlet SHGHorizontalTitleImageButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIView *viewPraise;
@property (weak, nonatomic) IBOutlet UIButton *praisebtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *faSongBtn;

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

    __weak typeof(self) weakSelf = self;
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
}

- (void)initView
{
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
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

    [self.btnCollet setImage:[UIImage imageNamed:@"homeDetailCollection"] forState:UIControlStateNormal];

    [self.btnDelete setImage:[UIImage imageNamed:@"home_delete"] forState:UIControlStateNormal];

    [self.btnPraise setTitleColor:kMainActionColor forState:UIControlStateNormal];
    [self.btnPraise setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    self.btnPraise.margin = MarginFactor(7.0f);
    self.btnPraise.titleLabel.font = kMainActionFont;

    [self.btnComment setTitleColor:kMainActionColor forState:UIControlStateNormal];
    [self.btnComment setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    self.btnComment.margin = MarginFactor(7.0f);
    self.btnComment.titleLabel.font = kMainActionFont;

    [self.btnShare setTitleColor:kMainActionColor forState:UIControlStateNormal];
    [self.btnShare setImage:[UIImage imageNamed:@"homeShare"] forState:UIControlStateNormal];
    self.btnShare.margin = MarginFactor(7.0f);
    self.btnShare.titleLabel.font = kMainActionFont;

    self.titleLabel.textColor = kMainTitleColor;
    self.titleLabel.font = kMainTitleFont;

    self.webView.scrollView.bounces = NO;
    self.webView.hidden = YES;

    self.businessView.hidden = YES;

    CTTextStyleModel *model = [[CTTextStyleModel alloc] init];
    model.numberOfLines = -1;
    model.lineSpace = MarginFactor(5.0f);
    self.lblContent.styleModel = model;
    self.lblContent.delegate = self;

    self.btnSend.titleLabel.font = FontFactor(15.0f);
    self.btnSend.layer.masksToBounds = YES;
    self.btnSend.layer.cornerRadius = 3.0f;

    self.faSongBtn.titleLabel.font = FontFactor(16.0f);
    self.faSongBtn.layer.masksToBounds = YES;
    self.faSongBtn.layer.cornerRadius = 3.0f;
    self.faSongBtn.backgroundColor = [UIColor colorWithHexString:@"f04241"];

    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];

    UIImage *image = self.backImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;

    [self.btnDelete setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnCollet setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnPraise setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnComment setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
    [self.btnShare setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:0.0f];
}

- (void)addSdLayout
{
    self.viewInput.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(45.0f));

    [self.faceBtn sizeToFit];
    CGSize faceSize = self.faceBtn.frame.size;
    self.faceBtn.sd_layout
    .leftSpaceToView(self.viewInput, kMainItemLeftMargin)
    .centerYEqualToView(self.viewInput)
    .widthIs(faceSize.width)
    .heightIs(faceSize.height);

    self.faSongBtn.sd_layout
    .rightSpaceToView(self.viewInput, kMainItemLeftMargin)
    .centerYEqualToView(self.viewInput)
    .widthIs(MarginFactor(70.0f))
    .heightIs(MarginFactor(35.0f));

    self.btnSend.sd_layout
    .rightSpaceToView(self.faSongBtn, MarginFactor(10.0f))
    .leftSpaceToView(self.faceBtn, MarginFactor(10.0f))
    .centerYEqualToView(self.viewInput);

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
    .leftSpaceToView(self.imageHeader, kMainItemLeftMargin)
    .offset(-1.0f)
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
    .bottomEqualToView(self.imageHeader)
    .heightIs(MarginFactor(13.0f));

    self.lblTime.sd_layout
    .leftSpaceToView(self.authenticationView, MarginFactor(5.0f))
    .bottomEqualToView(self.imageHeader)
    .autoHeightRatio(0.0f);
    [self.lblTime setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.btnAttention.sd_layout
    .rightSpaceToView(self.personView, kMainItemLeftMargin)
    .centerYEqualToView(self.imageHeader)
    .widthIs(self.btnAttention.currentImage.size.width)
    .heightIs(self.btnAttention.currentImage.size.height);

    self.webView.sd_layout
    .topSpaceToView(self.personView, 0.0f)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .heightIs(1.0f);

    self.titleLabel.sd_layout
    .topSpaceToView(self.personView, self.lblContent.styleModel.lineSpace)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .heightIs(0.0f);

    self.lblContent.sd_layout
    .topSpaceToView(self.titleLabel, 0.0f)
    .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
    .heightIs(0.0f);

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

    self.praisebtn.sd_layout
    .leftSpaceToView(self.viewPraise, MarginFactor(11.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(self.praisebtn.currentImage.size.width)
    .heightIs(self.praisebtn.currentImage.size.height);

    self.backImageView.sd_layout
    .leftSpaceToView(self.viewPraise, 0.0f)
    .rightSpaceToView(self.viewPraise, 0.0f)
    .topEqualToView(self.viewPraise)
    .bottomEqualToView(self.viewPraise);

    self.scrollPraise.sd_layout
    .leftSpaceToView(self.praisebtn, MarginFactor(10.0f))
    .rightSpaceToView(self.viewPraise, MarginFactor(10.0f) + CGRectGetMaxX(self.praisebtn.frame))
    .centerYEqualToView(self.viewPraise);

    self.lineView.sd_layout
    .leftSpaceToView(self.viewPraise, 0.0f)
    .rightSpaceToView(self.viewPraise, 0.0f)
    .bottomSpaceToView(self.viewPraise,0.0f)
    .heightIs(0.5f);

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
    NSDictionary *link = [dic objectForKey:@"link"];
    if ([self.responseObject.type isEqualToString:@"link"]){
        linkOBj *linkObj = [[linkOBj alloc] init];
        linkObj.title = [link objectForKey:@"title"];
        linkObj.desc = [link objectForKey:@"desc"];
        linkObj.thumbnail = [link objectForKey:@"thumbnail"];
        self.responseObject.linkObj = linkObj;
    }

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
    self.responseObject.photoArr = (NSArray *)self.responseObject.photos;
    if ([self.responseObject.userid isEqualToString:UID] || [self.responseObject.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    }
    if ([self.responseObject.userid isEqualToString:UID]){
        self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }

    BOOL status = [self.responseObject.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.potname] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:self.responseObject.userid];
    [self.authenticationView updateWithVStatus:status enterpriseStatus:self.responseObject.businessStatus];
    if (![self.responseObject.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.btnPraise setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    if (![self.responseObject.iscollection isEqualToString:@"Y"]) {
        [self.btnCollet setImage:[UIImage imageNamed:@"homeDetailNoCollection"] forState:UIControlStateNormal];
    } else{
        [self.btnCollet setImage:[UIImage imageNamed:@"homeDetailCollection"] forState:UIControlStateNormal];
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
    [self.lblCompanyName sizeToFit];
    //设置职位名称
    NSString *department = self.responseObject.title;
    if (self.responseObject.title.length > 4){
        department = [self.responseObject.title substringToIndex:4];
        department = [NSString stringWithFormat:@"%@...",department];
    }
    self.lbldepartName.text = department;

    self.lblTime.text = self.responseObject.publishdate;
    [self.btnShare setTitle:self.responseObject.sharenum forState:UIControlStateNormal];
    [self.btnComment setTitle:self.responseObject.cmmtnum forState:UIControlStateNormal];
    [self.btnPraise setTitle:self.responseObject.praisenum forState:UIControlStateNormal];

    if (self.responseObject.isAttention){
        [self.btnAttention setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
    }

    UIView *contentView = nil;
    if ([self.responseObject.postType isEqualToString:@"normalpc"]) {
        self.webView.hidden = NO;
        contentView = self.webView;
        self.titleLabel.hidden = self.lblContent.hidden = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.responseObject.groupPostUrl]]];
    } else if ([self.responseObject.postType isEqualToString:@"business"]) {
        contentView = self.businessView;
        self.businessView.hidden = NO;
        self.lblContent.hidden = YES;

        NSString *title = self.responseObject.groupPostTitle;
        self.titleLabel.text = title;
        if (title.length > 0) {
            self.titleLabel.sd_resetLayout
            .topSpaceToView(self.personView, 0.0f)
            .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .heightIs(MarginFactor(60.0f));
        }


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
        .topSpaceToView(self.titleLabel, 0.0f)
        .leftSpaceToView(self.tableHeaderView, 0.0f)
        .rightSpaceToView(self.tableHeaderView, 0.0f)
        .heightIs(MarginFactor(59.0f));

    } else {
        contentView = self.lblContent;
        NSString *title = self.responseObject.groupPostTitle;
        self.titleLabel.text = title;
        if (title.length > 0) {
            self.titleLabel.sd_resetLayout
            .topSpaceToView(self.personView, 0.0f)
            .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .heightIs(MarginFactor(60.0f));
        }

        NSString *detail = [[SHGGloble sharedGloble] formatStringToHtml:self.responseObject.detail];
        self.lblContent.text = detail;
        if (detail.length > 0) {
            self.lblContent.sd_resetLayout
            .topSpaceToView(self.titleLabel, -self.lblContent.styleModel.lineSpace)
            .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .heightIs([CTTextDisplayView getRowHeightWithText:detail rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.lblContent.styleModel]);
        }
    }

    if ([self.responseObject.type isEqualToString:TYPE_PHOTO]){
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [self.responseObject.photoArr enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
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
        .topSpaceToView(contentView, kMainPhotoViewTopMargin)
        .widthIs(CGRectGetWidth(photoGroup.frame))
        .heightIs(CGRectGetHeight(photoGroup.frame));
    } else {
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
        .topSpaceToView(contentView, 0.0f)
        .heightIs(0.0f);
    }

    CGFloat praiseWidth = 0;
    if ([self.responseObject.praisenum intValue] > 0){
        for (UIView *subView in self.scrollPraise.subviews){
            if (subView.tag >=1000) {
                [subView removeFromSuperview];
            }
        }
        for (int i = 0; i < self.responseObject.heads.count; i ++ ) {
            praiseOBj *obj = self.responseObject.heads[i];
            praiseWidth = MarginFactor(30.0f);
            CGRect rect = CGRectMake((praiseWidth + MarginFactor(7.0f)) * i , MarginFactor(13.0f), praiseWidth, praiseWidth);
            SHGUserHeaderView *head = [[SHGUserHeaderView alloc] initWithFrame:rect];
            [head updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname] placeholderImage:[UIImage imageNamed:@"default_head"] status:NO userID:obj.puserid];
            [_scrollPraise addSubview:head];
        }
        [self.scrollPraise setContentSize:CGSizeMake(self.responseObject.heads.count *(praiseWidth+PRAISE_SEPWIDTH), CGRectGetHeight(self.scrollPraise.frame))];
    } else{
        [self.scrollPraise removeAllSubviews];
    }

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

- (void)cnickClick:(NSInteger)index
{
    commentOBj *obj = self.responseObject.comments[index];
    [self gotoSomeOneWithId:obj.cid name:obj.cnickname];

}

-(void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)rnickClick:(NSInteger)index
{
    commentOBj *obj = self.responseObject.comments[index];
    [self gotoSomeOneWithId:obj.replyid name:obj.rnickname];
}

-(void)replyClick:(NSInteger )index
{
    [self replyClicked:self.responseObject commentIndex:index];
}

-(void)sizeUIWithObj:(CircleListObj *)obj
{
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4) {
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    self.nickName.text = name;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)actionPraise:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":self.responseObject.rid};

    if (![self.responseObject.ispraise isEqualToString:@"Y"]) {
        [Hud showWait];

        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.responseObject.ispraise = @"Y";
                self.responseObject.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.praisenum integerValue] + 1)];
                praiseOBj *obj = [[praiseOBj alloc] init];
                obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
                obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
                obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                [self.responseObject.heads addObject:obj];

                [Hud showMessageWithText:@"赞成功"];
                [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
                [self resetView];
                [self.tableView reloadData];

                [self.delegate detailPraiseWithRid:self.responseObject.rid praiseNum:self.responseObject.praisenum isPraised:@"Y"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:self.responseObject];
            }
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];

    } else{
        [Hud showWait];
        __weak typeof(self) weakSelf = self;

        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                weakSelf.responseObject.ispraise = @"N";
                weakSelf.responseObject.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.responseObject.praisenum integerValue] - 1)];
                for (praiseOBj *obj in weakSelf.responseObject.heads) {
                    if ([obj.puserid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]) {
                        [weakSelf.responseObject.heads removeObject:obj];
                        break;
                    }
                }
                [Hud showMessageWithText:@"取消点赞"];
                [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
                [weakSelf resetView];
                [weakSelf.tableView reloadData];

                [weakSelf.delegate detailPraiseWithRid:self.responseObject.rid praiseNum:self.responseObject.praisenum isPraised:@"N"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:weakSelf.responseObject];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
}

- (IBAction)actionShare:(id)sender
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *postContent = @"";
    NSString *shareContent = @"";
    NSString *shareTitle = @"";
    NSString *title = self.responseObject.groupPostTitle;
    if(IsStrEmpty(self.responseObject.detail)){
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = self.responseObject.detail;
        shareTitle = self.responseObject.detail;
        shareContent = self.responseObject.detail;
    }
    if(self.responseObject.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@...",[self.responseObject.detail substringToIndex:15]];
    }
    if(self.responseObject.detail.length > 15){
        shareTitle = [self.responseObject.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@...",[self.responseObject.detail substringToIndex:15]];
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
    __weak typeof(self) weakSelf = self;
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
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
            NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {

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
- (IBAction)actionCollection:(id)sender
{
    [Hud showWait];
    __weak typeof(self) weakSelf = self;
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

- (void)loadAttationState:(NSString *)targetUserID attationState:(BOOL)attationState
{
    if ([self.responseObject.userid isEqualToString:targetUserID]) {
        self.responseObject.isAttention = attationState;
        if (self.responseObject.isAttention){
            [self.btnAttention setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
        } else{
            [self.btnAttention setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
        }
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifier";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil] lastObject];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
        [cell.contentView addGestureRecognizer:longPress];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    SHGCommentType type = SHGCommentTypeNormal;
    if(indexPath.row == 0){
        type = SHGCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.comments.count - 1){
        type = SHGCommentTypeLast;
    }
    [cell loadUIWithObj:obj commentType:type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    UIFont *font = FontFactor(14.0f);

    NSString *text;
    if (IsStrEmpty(obj.rnickname)){
        text = [NSString stringWithFormat:@"%@:x%@",obj.cnickname,obj.cdetail];
    } else{
        text = [NSString stringWithFormat:@"%@回复%@:x%@",obj.cnickname,obj.rnickname,obj.cdetail];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = [UIFont systemFontOfSize:14.0f];
    replyLabel.attributedText = string;
    CGSize size = [replyLabel sizeThatFits:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, MAXFLOAT)];
    NSLog(@"%f",size.height);
    CGFloat height = size.height;
    if(indexPath.row == 0){
        height += kCommentTopMargin;
    }
    if (indexPath.row == self.responseObject.comments.count - 1){
        height += kCommentBottomMargin;
    }
    height += kCommentMargin;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseObject.comments.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    commentOBj *obj = self.responseObject.comments[indexPath.row];
    copyString = obj.cdetail;
    commentRid = obj.rid;
    if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        NSLog(@"%@",obj.cnickname);
        //复制删除试图
        [self createPickerView];
    } else{
        [self replyClick:indexPath.row];
        NSLog(@"%@",obj.cnickname);
        NSLog(@"%@",self.responseObject.nickname);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud showWait];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Hud hideHud];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = [[change objectForKey:@"new"] CGSizeValue].height;
        if (height > 0 && height != CGRectGetHeight(self.webView.frame)) {

            self.webView.sd_resetLayout
            .topSpaceToView(self.personView, 0.0f)
            .leftSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .rightSpaceToView(self.tableHeaderView, kMainItemLeftMargin)
            .heightIs(height);

            [self.tableHeaderView setNeedsLayout];
            [self.tableHeaderView layoutIfNeeded];
            self.tableView.tableHeaderView = self.tableHeaderView;
        }
    }
}

#pragma mark detailDelagte

- (void)detailDeleteWithRid:(NSString *)rid
{
    [self.delegate detailDeleteWithRid:rid];
    [self resetView];
    [self.tableView reloadData];

}

-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    if ([self.responseObject.rid isEqualToString:rid]) {
        self.responseObject.praisenum = num;
        self.responseObject.ispraise = isPrased;
    }

    [self resetView];

    [self.tableView reloadData];
    [self.delegate detailPraiseWithRid:rid praiseNum:num isPraised:isPrased];

}

-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
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

- (void)deleteSelf
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":self.responseObject.rid, @"uid":self.responseObject.userid};
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager deleteWithURL:url parameters:dic success:^(MOCHTTPResponse *response) {

        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [weakSelf.delegate detailDeleteWithRid:weakSelf.responseObject.rid];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (IBAction)actionDelete:(id)sender
{
    //删除
    __weak typeof(self)weakSelf = self;
    SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alert.rightBlock = ^{
        [weakSelf deleteSelf];

    };
    [alert show];

}

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)obj;
        NSString *key = [[dictionary objectForKey:@"key"] lowercaseString];
        if ([key isEqualToString:@"u"]) {
            LinkViewController *controller = [[LinkViewController alloc] init];
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

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
