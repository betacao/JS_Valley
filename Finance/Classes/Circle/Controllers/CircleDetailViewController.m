//
//  CircleDetailViewController.m
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
#import "TWEmojiKeyBoard.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGNavigationView.h"
#import "SHGPersonalViewController.h"
#import "CircleListDelegate.h"
#import "CircleLinkViewController.h"
#import "ReplyTableViewCell.h"
#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 28.0f
#define kItemMargin 7.0f * XFACTOR

@interface CircleDetailViewController ()<MLEmojiLabelDelegate, CircleListDelegate, ReplyDelegate>
{
    UIControl *backView;
    UIView *PickerBackView;
    NSString *copyString;
    NSString *commentRid;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *btnCollet;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
@property (weak, nonatomic) IBOutlet UIView *viewPraise;
@property (weak, nonatomic) IBOutlet UIButton *praisebtn;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lbldepartName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (weak, nonatomic) IBOutlet SHGUserHeaderView *imageHeader;
@property (strong, nonatomic) BRCommentView *popupView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) UIView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *faSongBtn;


- (IBAction)actionAttention:(id)sender;
- (IBAction)actionComment:(id)sender;
- (IBAction)actionPraise:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionCollection:(id)sender;
- (IBAction)actionDelete:(id)sender;

@end

@implementation CircleDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleDetailViewController" label:@"onClick"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态详情";
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
    [self initView];
    [self addSdLayout];
    
    __weak typeof(self) weakSelf = self;
    [Hud showWait];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circledetail"] class:[CircleListObj class] parameters:@{@"rid":self.rid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"%@  arr === %@",response.data,response.dataDictionary);
        if (response.dataDictionary) {
            [weakSelf parseObjWithDic:response.dataDictionary];
            [weakSelf loadDatasWithObj:weakSelf.obj];
            [weakSelf detailHomeListShouldRefresh:weakSelf.obj];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)initView
{
    self.listTable.tableFooterView = [[UIView alloc] init];
    self.listTable.backgroundColor = [UIColor whiteColor];

    self.nickName.font = kMainNameFont;
    self.nickName.textColor = kMainNameColor;

    self.lblCompanyName.font = kMainCompanyFont;
    self.lblCompanyName.textColor = kMainCompanyColor;

    self.lbldepartName.font = kMainCompanyFont;
    self.lbldepartName.textColor = kMainCompanyColor;

    self.lblTime.font = kMainTimeFont;
    self.lblTime.textColor = kMainTimeColor;

    [self.btnComment setTitleColor:kMainActionColor forState:UIControlStateNormal];
    self.btnComment.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -10.0f);
    self.btnComment.titleLabel.font = kMainActionFont;

    [self.btnShare setTitleColor:kMainActionColor forState:UIControlStateNormal];
    self.btnShare.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -10.0f);
    self.btnShare.titleLabel.font = kMainActionFont;

    [self.btnPraise setTitleColor:kMainActionColor forState:UIControlStateNormal];
    self.btnPraise.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -10.0f);
    self.btnPraise.titleLabel.font = kMainActionFont;

    self.lblContent.textColor = kMainContentColor;
    self.lblContent.font = kMainContentFont;
    self.lblContent.numberOfLines = 0;
    self.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblContent.delegate = self;
    self.lblContent.backgroundColor = [UIColor clearColor];

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
    .leftSpaceToView(self.viewInput, MarginFactor(12.0f))
    .centerYEqualToView(self.viewInput)
    .widthIs(faceSize.width)
    .heightIs(faceSize.height);
    
    self.faSongBtn.sd_layout
    .rightSpaceToView(self.viewInput, MarginFactor(12.0f))
    .centerYEqualToView(self.viewInput)
    .widthIs(MarginFactor(70.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.btnSend.sd_layout
    .rightSpaceToView(self.faSongBtn, MarginFactor(10.0f))
    .leftSpaceToView(self.faceBtn, MarginFactor(10.0f))
    .centerYEqualToView(self.viewInput);
    
    self.listTable.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.viewInput, 0.0f);
    
    //headerView
    self.personView.sd_layout
    .topSpaceToView(self.viewHeader, 0.0f)
    .leftSpaceToView(self.viewHeader, 0.0f)
    .rightSpaceToView(self.viewHeader, 0.0f)
    .heightIs(MarginFactor(67.0f));
    
    self.imageHeader.sd_layout
    .leftSpaceToView(self.personView, MarginFactor(12.0f))
    .topSpaceToView(self.personView, MarginFactor(16.0f))
    .topEqualToView(self.personView)
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.nickName.sd_layout
    .topEqualToView(self.imageHeader)
    .leftSpaceToView(self.imageHeader, MarginFactor(9.0f))
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
    
    self.lblTime.sd_layout
    .leftEqualToView(self.nickName)
    .bottomEqualToView(self.imageHeader)
    .autoHeightRatio(0.0f);
    [self.lblTime setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    UIImage *attentionImage = [UIImage imageNamed:@"newAttention"];
    CGSize attentionSize = attentionImage.size;
    self.btnAttention.sd_layout
    .rightSpaceToView(self.personView, MarginFactor(12.0f))
    .centerYEqualToView(self.imageHeader)
    .widthIs(attentionSize.width)
    .heightIs(attentionSize.height);
    
    self.lblContent.sd_layout
    .topSpaceToView(self.personView, 0.0f)
    .leftEqualToView(self.imageHeader)
    .rightEqualToView(self.btnAttention)
    .autoHeightRatio(0.0f);
    self.lblContent.isAttributedContent = YES;
    
    self.photoView = [[UIView alloc]init];
    [self.viewHeader addSubview:self.photoView];
    self.photoView.sd_layout
    .leftEqualToView(self.imageHeader)
    .rightEqualToView(self.btnAttention)
    .topSpaceToView(self.lblContent, MarginFactor(16.0f))
    .heightIs(0.0f);
    
    
    [self.btnShare sizeToFit];
    CGSize shareSize = self.btnShare.frame.size;
    self.btnShare.sd_layout
    .rightSpaceToView(self.actionView, 0.0f)
    .centerYEqualToView(self.actionView)
    .widthIs(shareSize.width)
    .heightIs(shareSize.height);
    
    [self.btnComment sizeToFit];
    CGSize commentSize = self.btnComment.frame.size;
    self.btnComment.sd_layout
    .rightSpaceToView(self.btnShare, MarginFactor(24.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(commentSize.width)
    .heightIs(commentSize.height);
    
    [self.btnPraise sizeToFit];
    CGSize praiseSize = self.btnPraise.frame.size;
    self.btnPraise.sd_layout
    .rightSpaceToView(self.btnComment, MarginFactor(24.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(praiseSize.width)
    .heightIs(praiseSize.height);
    
    [self.btnCollet sizeToFit];
    CGSize colletSize = self.btnCollet.frame.size;
    self.btnCollet.sd_layout
    .rightSpaceToView(self.btnPraise, MarginFactor(24.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(colletSize.width)
    .heightIs(colletSize.height);
    
    [self.btnDelete sizeToFit];
    CGSize delteSize = self.btnDelete.frame.size;
    self.btnDelete.sd_layout
    .rightSpaceToView(self.btnCollet, MarginFactor(24.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(delteSize.width)
    .heightIs(delteSize.height);
    
    
    [self.praisebtn sizeToFit];
    CGSize praiseBtnSize = self.praisebtn.frame.size;
    self.praisebtn.sd_layout
    .leftSpaceToView(self.viewPraise, MarginFactor(11.0f))
    .centerYEqualToView(self.btnShare)
    .widthIs(praiseBtnSize.width)
    .heightIs(praiseBtnSize.height);
    
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

    self.viewHeader.hidden = YES;

    [self.viewHeader setupAutoHeightWithBottomView:self.viewPraise bottomMargin:0.0f];
    self.listTable.tableHeaderView = self.viewHeader;
    
}

-(void)parseObjWithDic:(NSDictionary *)dics
{
    NSDictionary *dic = dics[@"circle"][0];
    NSArray *cmArr = dics[@"comments"];
    if (!IsArrEmpty(cmArr)) {
        self.obj.comments = [NSMutableArray array];
        for (NSDictionary *cmt in cmArr) {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cdetail = cmt[@"cdetail"];
            obj.cid = cmt[@"cid"];
            obj.cnickname = cmt[@"cnickname"];
            obj.rnickname = cmt[@"rnickname"];
            obj.rid = cmt[@"rid"];
            [self.obj.comments addObject:obj];
        }
    }
    self.obj.ispraise = dic[@"ispraise"];
    self.obj.iscollection = dics[@"iscollection"];
    NSArray *heads = dics[@"heads"];
    for (NSDictionary *head in heads) {
        praiseOBj *obj = [[praiseOBj alloc] init];
        obj.pnickname = head[@"pnickname"];
        obj.ppotname = head[@"ppotname"];
        obj.puserid = head[@"puserid"];
        [self.obj.heads addObject:obj];
    }
    self.obj.cmmtnum = [NSString stringWithFormat:@"%@",dic[@"cmmtnum"]];
    self.obj.company = dic[@"company"];
    self.obj.detail = dic[@"detail"];
    self.obj.isattention = dic[@"isattention"];
    self.obj.nickname = dic[@"nickname"];
    self.obj.photos = dic[@"attach"];
    self.obj.potname = dic[@"potname"];
    self.obj.praisenum = dic[@"praisenum"];
    self.obj.publishdate = dic[@"publishdate"];
    self.obj.type = dic[@"attachtype"];
    self.obj.rid = dic[@"rid"];
    self.obj.sharenum = dic[@"sharenum"];
    self.obj.status = dic[@"status"];
    self.obj.title = dic[@"title"];
    self.obj.userstatus = [dic objectForKey:@"userstatus"];
    self.obj.userid = dic[@"userid"];
    NSDictionary *link = dic[@"link"];
    if ([self.obj.type isEqualToString:@"link"]){
        linkOBj *linkObj = [[linkOBj alloc] init];
        linkObj.title = link[@"title"];
        linkObj.desc = link[@"desc"];
        linkObj.thumbnail = link[@"thumbnail"];
        self.obj.linkObj = linkObj;
    }
    
}

- (CircleListObj *)obj
{
    if (!_obj) {
        _obj = [[CircleListObj alloc] init];
    }
    return _obj;
}


- (void)shareSuccess
{
    self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
}

- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *rid = obj;
        if ([self.obj.rid isEqualToString:rid]) {
            [self otherShareWithObj:self.obj];
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

- (void)loadDatasWithObj:(CircleListObj *)obj
{
    self.obj.photoArr = (NSArray *)obj.photos;
    if ([obj.userid isEqualToString:UID] || [obj.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    }
    if ([obj.userid isEqualToString:UID]){
        self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }

    BOOL status = [obj.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.potname] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:obj.userid];

    if (![obj.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.btnPraise setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    if (![obj.iscollection isEqualToString:@"Y"]) {
        [self.btnCollet setImage:[UIImage imageNamed:@"homeDetailNoCollection"] forState:UIControlStateNormal];
    } else{
        [self.btnCollet setImage:[UIImage imageNamed:@"homeDetailCollection"] forState:UIControlStateNormal];
    }
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4){
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@...",name];
    }
    self.nickName.text = name;
    //设置公司名称
    NSString *comp = obj.company;
    if (obj.company.length > 6) {
        NSString *str = [obj.company substringToIndex:6];
        comp = [NSString stringWithFormat:@"%@...",str];
    }
    self.lblCompanyName.text = comp;
    [self.lblCompanyName sizeToFit];
    //设置职位名称
    NSString *str = obj.title;
    if (obj.title.length > 4){
        str= [obj.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@...",str];
    }
    self.lbldepartName.text = str;
    
    self.lblTime.text = obj.publishdate;
    [self.btnShare setTitle:obj.sharenum forState:UIControlStateNormal];
    [self.btnShare sizeToFit];
    [self.btnComment setTitle:obj.cmmtnum forState:UIControlStateNormal];
    [self.btnComment sizeToFit];
    [self.btnPraise setTitle:obj.praisenum forState:UIControlStateNormal];
    [self.btnPraise sizeToFit];
    
    if ([obj.isattention isEqualToString:@"Y"]){
        [self.btnAttention setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal];
    }
    
    self.lblContent.text = obj.detail;
    
    if ([self.obj.type isEqualToString:TYPE_PHOTO]){
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [obj.photoArr enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,src];
            item.object = obj;
            [temp addObject:item];
        }];
        photoGroup.photoItemArray = temp;
        [self.photoView addSubview:photoGroup];
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
        .topSpaceToView(self.lblContent, MarginFactor(16.0f))
        .widthIs(CGRectGetWidth(photoGroup.frame))
        .heightIs(CGRectGetHeight(photoGroup.frame));
        
    }
    
    CGFloat praiseWidth = 0;
    if ([self.obj.praisenum intValue] > 0){
        for (UIView *subView in self.scrollPraise.subviews){
            if (subView.tag >=1000) {
                [subView removeFromSuperview];
            }
        }
        for (int i = 0; i < self.obj.heads.count; i ++ ) {
            praiseOBj *obj = self.obj.heads[i];
            praiseWidth = MarginFactor(30.0f);
            CGRect rect = CGRectMake((praiseWidth + MarginFactor(7.0f)) * i , MarginFactor(13.0f), praiseWidth, praiseWidth);
            SHGUserHeaderView *head = [[SHGUserHeaderView alloc] initWithFrame:rect];
            [head updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname] placeholderImage:[UIImage imageNamed:@"default_head"] status:NO userID:obj.puserid];
            [_scrollPraise addSubview:head];
        }
        [self.scrollPraise setContentSize:CGSizeMake(self.obj.heads.count *(praiseWidth+PRAISE_SEPWIDTH), CGRectGetHeight(self.scrollPraise.frame))];
        self.viewPraise.hidden = NO;
    } else{
        [self.scrollPraise removeAllSubviews];
    }
    
    self.actionView.sd_resetLayout
    .leftEqualToView(self.imageHeader)
    .rightEqualToView(self.btnAttention)
    .topSpaceToView(self.photoView, 0.0f)
    .heightIs(MarginFactor(49.0f));
    
    self.viewPraise.sd_resetLayout
    .leftSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .rightSpaceToView(self.viewHeader, MarginFactor(12.0f))
    .topSpaceToView(self.actionView, 0.0f)
    .heightIs(MarginFactor(56.0f));

    self.viewHeader.hidden = NO;
    [self.viewHeader layoutSubviews];
    self.listTable.tableHeaderView = self.viewHeader;

    [self.listTable reloadData];
}

- (void)cnickClick:(NSInteger)index
{
    commentOBj *obj = self.obj.comments[index];
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
    commentOBj *obj = self.obj.comments[index];
    [self gotoSomeOneWithId:obj.rid name:obj.rnickname];
}

-(void)replyClick:(NSInteger )index
{
    [self replyClicked:self.obj commentIndex:index];
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
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            _popupView.delegate = self;
            _popupView.fid = @"-1";//评论
            _popupView.tag = 222;
            _popupView.detail = @"";
            _popupView.rid = self.obj.rid;
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

#pragma mark -- sdc
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
            [self.obj.comments addObject:obj];
            self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] + 1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
        }
        [self.listTable reloadData];
        [self loadDatasWithObj:self.obj];
        [self.delegate detailCommentWithRid:self.obj.rid commentNum:self.obj.cmmtnum comments:self.obj.comments];
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
    for (commentOBj *cObj in self.obj.comments)
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
            [self.obj.comments addObject:obj];
            self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] + 1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
            [MobClick event:@"ActionCommentClick" label:@"onClick"];
        }
        [self.listTable reloadData];
        [self loadDatasWithObj:self.obj];
        [self.delegate detailCommentWithRid:self.obj.rid commentNum:self.obj.cmmtnum comments:self.obj.comments];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KEY_MEMORY];
        [self loadCommentBtnState];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
    
}

- (void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
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
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":self.obj.rid};
    
    if (![self.obj.ispraise isEqualToString:@"Y"]) {
        [Hud showWait];
        
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.obj.ispraise = @"Y";
                self.obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.praisenum integerValue] + 1)];
                praiseOBj *obj = [[praiseOBj alloc] init];
                obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
                obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
                obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                [self.obj.heads addObject:obj];
                
                [Hud showMessageWithText:@"赞成功"];
                [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
                [self loadDatasWithObj:self.obj];
                [self.listTable reloadData];
                
                [self.delegate detailPraiseWithRid:self.obj.rid praiseNum:self.obj.praisenum isPraised:@"Y"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:self.obj];
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
                weakSelf.obj.ispraise = @"N";
                weakSelf.obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.praisenum integerValue] - 1)];
                for (praiseOBj *obj in weakSelf.obj.heads) {
                    if ([obj.puserid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]) {
                        [weakSelf.obj.heads removeObject:obj];
                        break;
                    }
                }
                [Hud showMessageWithText:@"取消点赞"];
                [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
                [weakSelf loadDatasWithObj:self.obj];
                [weakSelf.listTable reloadData];

                [weakSelf.delegate detailPraiseWithRid:self.obj.rid praiseNum:self.obj.praisenum isPraised:@"N"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:weakSelf.obj];
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
    if(IsStrEmpty(self.obj.detail)){
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = self.obj.detail;
        shareTitle = self.obj.detail;
        shareContent = self.obj.detail;
    }
    if(self.obj.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@...",[self.obj.detail substringToIndex:15]];
    }
    if(self.obj.detail.length > 15){
        shareTitle = [self.obj.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@...",[self.obj.detail substringToIndex:15]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.obj.rid type:@"dynamic_shareDynamic"];
        [self circleShareWithObj:self.obj];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{

        [[SHGGloble sharedGloble] recordUserAction:self.obj.rid type:@"dynamic_shareSystemUser"];
        [self shareToFriendWithText:self.obj.detail];
    }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:self.obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.obj.rid type:@"dynamic_shareMicroCircle"];
        [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:1];
    }];
    
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[SHGGloble sharedGloble] recordUserAction:self.obj.rid type:@"dynamic_shareMicroFriend"];
        [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:0];
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
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:self.obj];
            [[SHGGloble sharedGloble] recordUserAction:self.obj.rid type:@"dynamic_shareQQ"];
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
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",self.obj.nickname,text];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = shareText;
    vc.shareRid = self.obj.rid;
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
            
            [weakSelf loadDatasWithObj:obj];
            [weakSelf.listTable reloadData];
            [Hud showMessageWithText:@"帖子分享成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

-(void)circleShareWithObj:(CircleListObj *)obj
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
            NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
            [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
                
                NSString *code = [response.data valueForKey:@"code"];
                if ([code isEqualToString:@"000"]) {
                    self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
                    [self loadDatasWithObj:self.obj];
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
    NSDictionary *param = @{@"uid":UID, @"rid":self.obj.rid};
    if (![self.obj.iscollection isEqualToString:@"Y"]){
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                weakSelf.obj.iscollection = @"Y";
            }
            [weakSelf loadDatasWithObj:weakSelf.obj];
            [Hud showMessageWithText:@"收藏成功"];
            [MobClick event:@"ActionCollection_On" label:@"onClick"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                [weakSelf.delegate detailCollectionWithRid:weakSelf.obj.rid collected:weakSelf.obj.iscollection];
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
                weakSelf.obj.iscollection = @"N";
            }
            [weakSelf loadDatasWithObj:weakSelf.obj];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                [weakSelf.delegate detailCollectionWithRid:weakSelf.obj.rid collected:weakSelf.obj.iscollection];
            }
            [MobClick event:@"ActionCollection_Off" label:@"onClick"];
            [Hud showMessageWithText:@"取消收藏"];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
}

- (IBAction)actionAttention:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":self.obj.userid};
    [Hud showWait];
    if ([self.obj.isattention isEqualToString:@"N"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                self.obj.isattention = @"Y";
                [Hud showMessageWithText:@"关注成功"];
            }
            [self loadDatasWithObj:self.obj];
            
            [self.delegate detailAttentionWithRid:self.obj.userid attention:self.obj.isattention];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:self.obj];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        __weak typeof(self) weakSelf = self;
        [MOCHTTPRequestOperationManager deleteWithURL:url parameters:param success:^(MOCHTTPResponse *response) {

            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                weakSelf.obj.isattention = @"N";
                [Hud showMessageWithText:@"取消关注成功"];
            }
            [weakSelf loadDatasWithObj:weakSelf.obj];
            [weakSelf.delegate detailAttentionWithRid:weakSelf.obj.userid attention:weakSelf.obj.isattention];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:weakSelf.obj];

        } failed:^(MOCHTTPResponse *response) {

            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];

    }
}

-(void)refreshFooter
{
    
}

#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.obj.comments[indexPath.row];
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
    } else if(indexPath.row == self.obj.comments.count - 1){
        type = SHGCommentTypeLast;
    }
    [cell loadUIWithObj:obj commentType:type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.obj.comments[indexPath.row];
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
    if (indexPath.row == self.obj.comments.count - 1){
        height += kCommentBottomMargin;
    }
    height += kCommentMargin;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.obj.comments.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    commentOBj *obj = self.obj.comments[indexPath.row];
    copyString = obj.cdetail;
    commentRid = obj.rid;
    if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        NSLog(@"%@",obj.cnickname);
        //复制删除试图
        [self createPickerView];
    } else{
        [self replyClick:indexPath.row];
        NSLog(@"%@",obj.cnickname);
        NSLog(@"%@",self.obj.nickname);
    }
}

-(void)linkTap:(DDTapGestureRecognizer *)ges
{
    CircleLinkViewController *vc = [[CircleLinkViewController alloc] init];
    vc.link = self.obj.linkObj.link;
    UINavigationController *nav =  (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    [nav pushViewController:vc animated:YES];
}



#pragma mark - textFieldDelegate

#pragma mark detailDelagte

-(void)detailDeleteWithRid:(NSString *)rid
{
    [self.delegate detailDeleteWithRid:rid];
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    
}

-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    if ([self.obj.rid isEqualToString:rid]) {
        self.obj.praisenum = num;
        self.obj.ispraise = isPrased;
    }
    
    [self loadDatasWithObj:self.obj];
    
    [self.listTable reloadData];
    [self.delegate detailPraiseWithRid:rid praiseNum:num isPraised:isPrased];
    
}

-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    if ([self.obj.rid isEqualToString:rid]) {
        self.obj.sharenum = num;
    }
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    [self.delegate detailShareWithRid:rid shareNum:num];
    
}

-(void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    if ([self.obj.userid isEqualToString:rid]) {
        self.obj.isattention = atten;
    }
    [self loadDatasWithObj:self.obj];
    
    [self.listTable reloadData];
    [self.delegate detailAttentionWithRid:rid attention:atten];
    
}

-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    if ([self.obj.rid isEqualToString:rid]){
        self.obj.cmmtnum = num;
        self.obj.comments = comments;
    }
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    [self.delegate detailCommentWithRid:rid commentNum:num comments:comments];
    
}

- (void)deleteSelf
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":self.obj.rid, @"uid":self.obj.userid};
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager deleteWithURL:url parameters:dic success:^(MOCHTTPResponse *response) {

        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [weakSelf.delegate detailDeleteWithRid:weakSelf.obj.rid];
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
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alert.rightBlock = ^{
        [weakSelf deleteSelf];
        
    };
    [alert show];
    
}

#pragma mark -- sdc
#pragma mark -- url点击
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    NSLog(@"1111");
    LinkViewController *vc=  [[LinkViewController alloc]init];
    vc.url = link;
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            [self openTel:link];
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
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
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -- sdc
#pragma mark -- 打开url
- (BOOL)openURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"] ;
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -- sdc
#pragma mark -- 删除评论
- (void)longPressGesturecognized:(UIGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [recognizer locationInView:self.listTable];
    NSIndexPath *indexPath = [self.listTable indexPathForRowAtPoint:location];
    switch (state){
        case UIGestureRecognizerStateBegan:{
            if (indexPath){
                //判断是否是自己
                commentOBj *obj = self.obj.comments[indexPath.row];
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
    NSLog(@"....%@",copyString);
    [UIPasteboard generalPasteboard].string = copyString;
    self.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
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
        for (commentOBj *obj in self.obj.comments){
            if ([obj.rid  isEqualToString:commentRid]){
                [self.obj.comments removeObject:obj];
                self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] - 1)];
                break;
            }
        }
        [self loadDatasWithObj:self.obj];
        [self.listTable reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
    } failed:^(MOCHTTPResponse *response){
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"response.errorMessage==%@",response.errorMessage);
    }];
    //listTable适应屏幕
    self.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
    
}

@end
