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
#define k_FirstToTop 5.0f * XFACTOR
#define k_SecondToTop 10.0f * XFACTOR
#define k_ThirdToTop 15.0f * XFACTOR
#define PRAISE_WIDTH 30.0f
#define PRAISE_SEPWIDTH     10.0f
#define PRAISE_RIGHTWIDTH     40.0f

@interface SHGMarketDetailViewController ()<BRCommentViewDelegate, CircleActionDelegate, SHGMarketCommentDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;
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
@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (strong, nonatomic) BRCommentView *popupView;
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
    self.detailTable.dataSource = self;
    [self.detailTable setTableFooterView:[[UIView alloc] init]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];

    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"marketId":self.object.marketId ,@"uid":UID};
    [SHGMarketManager loadMarketDetail:param block:^(SHGMarketObject *object) {
        weakSelf.responseObject = object;
        weakSelf.responseObject.commentList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.commentList class:[SHGMarketCommentObject class]]];
        weakSelf.responseObject.praiseList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.praiseList class:[praiseOBj class]]];
        [weakSelf loadData];
        [weakSelf loadUI];
        [weakSelf.detailTable reloadData];
    }];
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateTypeDeletedMarket;
    }
    return _emptyView;
}

- (void)loadData
{
    self.timeLabel.text = self.responseObject.createTime;
    if (!self.responseObject.price.length == 0) {
        NSString * zjStr = self.responseObject.price;
        self.capitalLabel.text = [NSString stringWithFormat:@"金额： %@",zjStr];
    }else {
        self.capitalLabel.text = [NSString stringWithFormat:@"金额： 暂未说明"];
    }
     self.typeLabel.text = [NSString stringWithFormat:@"类型： %@",self.responseObject.catalog];

      if ([self.responseObject.loginuserstate isEqualToString:@"0" ]) {
        NSString * contactString = @"联系方式： 认证可见";
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:contactString];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(6, 4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4277B2"] range:NSMakeRange(6, 4)];
        self.phoneNumLabel.attributedText = str;
        self.phoneNumLabel.userInteractionEnabled = YES;
          UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactLabelToIdentification:)];
        [self.phoneNumLabel addGestureRecognizer:recognizer];
        
    } else if([self.responseObject.loginuserstate isEqualToString:@"1" ]){
        self.phoneNumLabel.text = [@"联系方式：" stringByAppendingString: self.responseObject.contactInfo];
    }
    self.nameLabel.text = self.responseObject.realname;

    self.companyLabel.text = self.responseObject.company;

    if (self.responseObject.company.length > 6) {
        NSString *str = [self.responseObject.title substringToIndex:6];
        self.positionLabel.text = [NSString stringWithFormat:@"%@…",str];
    }else{
        self.positionLabel.text = self.responseObject.title;
    }
    
    NSString * aStr = self.responseObject.position;
    self.addressLabel.text = [NSString stringWithFormat:@"地区： %@",aStr];
    [self.headImageView updateStatus:[self.responseObject.status isEqualToString:@"1"] ? YES : NO];
    [self.headImageView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.headimageurl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.detailContentLabel.text = self.responseObject.detail;


}

- (void)loadUI
{
    //1.7.2界面修改
    self.timeLabel.hidden = YES;
    
    CGSize nameSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.nameLabel.frame));
    NSDictionary * nameDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15.0],NSFontAttributeName,nil];
    CGSize  nameActualsize =[self.nameLabel.text boundingRectWithSize:nameSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:nameDic context:nil].size;
    self.nameLabel.frame = CGRectMake(self.nameLabel.origin.x,self.nameLabel.origin.y, nameActualsize.width, CGRectGetHeight(self.nameLabel.frame));
    //1.72版本不需要分割线
    self.verticalLine.hidden = YES;
    self.verticalLine.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+k_FirstToTop,self.verticalLine.origin.y, self.verticalLine.frame.size.width, CGRectGetHeight(self.verticalLine.frame));

    self.companyLabel.frame =CGRectMake(self.companyLabel.origin.x,self.companyLabel.origin.y, self.companyLabel.width, CGRectGetHeight(self.companyLabel.frame));

    CGSize positionSize =CGSizeMake(MAXFLOAT,CGRectGetHeight(self.positionLabel.frame));
    NSDictionary * positionDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0],NSFontAttributeName,nil];
    CGSize  positionActualsize =[self.positionLabel.text boundingRectWithSize:positionSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:positionDic context:nil].size;
    self.positionLabel.frame =CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + k_FirstToTop,self.positionLabel.origin.y, positionActualsize.width, CGRectGetHeight(self.positionLabel.frame));

    NSString *title = self.responseObject.marketName;
    self.titleLabel.text = title;
    CGSize tsize =CGSizeMake(self.titleLabel.frame.size.width,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  actualsize =[title boundingRectWithSize:tsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    self.titleLabel.height = actualsize.height;
    //控件位置
    self.typeLabel.frame = CGRectMake(self.typeLabel.origin.x, CGRectGetMaxY(self.titleLabel.frame)+k_SecondToTop, self.typeLabel.width, self.typeLabel.height);

    self.capitalLabel.frame =CGRectMake(self.capitalLabel.frame.origin.x,CGRectGetMaxY(self.typeLabel.frame)+k_FirstToTop, self.capitalLabel.width, CGRectGetHeight(self.capitalLabel.frame));
    self.phoneNumLabel.frame =CGRectMake(self.phoneNumLabel.origin.x, CGRectGetMaxY(self.capitalLabel.frame)+k_FirstToTop, self.phoneNumLabel.width, self.phoneNumLabel.height);
    self.addressLabel.frame =CGRectMake(self.addressLabel.origin.x, CGRectGetMaxY(self.phoneNumLabel.frame)+k_FirstToTop, self.addressLabel.width, self.phoneNumLabel.height);
    self.secondHorizontalLine.frame = CGRectMake(self.secondHorizontalLine.origin.x, CGRectGetMaxY(self.addressLabel.frame)+k_ThirdToTop, self.secondHorizontalLine.width, self.secondHorizontalLine.height);
    self.marketDetialLabel.frame = CGRectMake(self.detailContentLabel.origin.x, CGRectGetMaxY(self.secondHorizontalLine.frame)+k_ThirdToTop, self.marketDetialLabel.width, self.marketDetialLabel.height);
    self.thirdHorizontalLine.frame = CGRectMake(self.thirdHorizontalLine.origin.x, CGRectGetMaxY(self.marketDetialLabel.frame)+k_ThirdToTop, self.thirdHorizontalLine.width, self.thirdHorizontalLine.height);

    //内容详情
    self.detailContentLabel.numberOfLines = 0;
    CGSize dsize =CGSizeMake(self.detailContentLabel.frame.size.width,MAXFLOAT);
    NSDictionary * ddic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil];
    CGSize  dActualsize =[self.detailContentLabel.text boundingRectWithSize:dsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:ddic context:nil].size;
    self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.origin.x, CGRectGetMaxY(self.thirdHorizontalLine.frame)+ k_ThirdToTop, self.detailContentLabel.width, dActualsize.height);
    if (!self.responseObject.url.length == 0) {

        UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.detailContentLabel.frame)+k_FirstToTop*2, 0.0f, 0.0f)];
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.url];
        [temp addObject:item];
        photoGroup.photoItemArray = temp;
        [photoView addSubview:photoGroup];
        photoView.frame = CGRectMake(15.0, self.detailContentLabel.bottom + k_FirstToTop*2, CGRectGetWidth(photoGroup.frame),CGRectGetHeight(photoGroup.frame));
        [self.viewHeader addSubview:photoView];
        self.actionView.frame = CGRectMake(self.actionView.origin.x, CGRectGetMaxY(photoView.frame) + k_FirstToTop, self.actionView.width, self.actionView.height);
    }else{
        self.actionView.frame = CGRectMake(self.actionView.origin.x, CGRectGetMaxY(self.detailContentLabel.frame)+k_FirstToTop, self.actionView.width, self.actionView.height);
    }
    [self loadFooterUI];
    [self loadPraiseButtonState];
    [self loadShareButtonState];

    [self.btnComment setImage:[UIImage imageNamed:@"home_comment"] forState:UIControlStateNormal];
    [self.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];

    self.praiseView.frame = CGRectMake(self.praiseView.origin.x, CGRectGetMaxY(self.actionView.frame)+k_FirstToTop, self.praiseView.width, self.praiseView.height);
    //image处理边帽
    UIImage *image = self.backImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;

    [self addTableHeaderView];
    [self addEmptyViewIfNeeded];
}

- (void)tapContactLabelToIdentification:(UIButton *)button
{
    
    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            if([weakSelf respondsToSelector:@selector(tapContactLabelToIdentification:)]){
                [weakSelf performSelector:@selector(tapContactLabelToIdentification:) withObject:button];
            }
        } else{
            VerifyIdentityViewController * vc = [[VerifyIdentityViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failString:@"认证后才能查看联系方式～"];
}

- (void)addTableHeaderView
{
    CGRect frame = self.viewHeader.frame;
    frame.size.height = CGRectGetMaxY(self.praiseView.frame);
    self.viewHeader.frame = frame;
    [self.detailTable setTableHeaderView: self.viewHeader];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGMarketCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    //    self.copyedString = object.commentDetail;
    if ([object.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        //复制删除试图
        //        [self createPickerView];
    } else{
        [self replyClicked:object commentIndex:indexPath.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark ----btnClick---

- (IBAction)zan:(id)sender
{
    __weak typeof(self)weakSelf = self;
    [[SHGMarketSegmentViewController sharedSegmentController] addOrDeletePraise:self.responseObject block:^(BOOL success) {
        if ([weakSelf.responseObject.isPraise isEqualToString:@"N"]) {
            weakSelf.responseObject.praiseNum = [NSString stringWithFormat:@"%ld",(long)[weakSelf.responseObject.praiseNum integerValue] + 1];
            weakSelf.responseObject.isPraise = @"Y";
            praiseOBj *obj = [[praiseOBj alloc] init];
            obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
            obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
            obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [weakSelf.responseObject.praiseList addObject:obj];

            [weakSelf loadPraiseButtonState];
            [weakSelf loadFooterUI];
        } else{
            weakSelf.responseObject.praiseNum = [NSString stringWithFormat:@"%ld",(long)[weakSelf.responseObject.praiseNum integerValue] - 1];
            weakSelf.responseObject.isPraise = @"N";
            for (praiseOBj *obj in weakSelf.responseObject.praiseList) {
                NSString *uid = UID;
                if ([obj.puserid isEqualToString:uid]) {
                    [weakSelf.responseObject.praiseList removeObject:obj];
                    break;
                }
            }
            [weakSelf loadPraiseButtonState];
            [weakSelf loadFooterUI];
        }
    }];
}

- (void)loadPraiseButtonState
{
    //设置点赞的状态
    if ([self.responseObject.isPraise isEqualToString:@"N"]) {
        [self.btnZan setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.btnZan setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    [self.btnZan setTitle:self.responseObject.praiseNum forState:UIControlStateNormal];
}

- (void)loadShareButtonState
{
    [self.btnShare setImage:[UIImage imageNamed:@"shareImage"] forState:UIControlStateNormal];
    [self.btnShare setTitle:[NSString stringWithFormat:@"%@",self.responseObject.shareNum] forState:UIControlStateNormal];
}

- (void)loadFooterUI
{
    UIImage *image = self.backImageView.image;
    self.backImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    [self.scrollPraise removeAllSubviews];
    CGRect praiseRect = self.praiseView.frame;
    CGFloat praiseWidth = 0;
    if ([self.responseObject.praiseNum integerValue] > 0){
        NSArray *array = self.responseObject.praiseList;
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
            [self.scrollPraise addSubview:head];
        }
        [self.scrollPraise setContentSize:CGSizeMake(array.count * (praiseWidth + PRAISE_SEPWIDTH), CGRectGetHeight(self.scrollPraise.frame))];
    }
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
            [weakSelf.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];
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
            [weakSelf.btnComment setTitle:[NSString stringWithFormat:@"%@",self.responseObject.commentNum] forState:UIControlStateNormal];
        }
    }];
}



- (IBAction)share:(id)sender
{
    [[SHGMarketManager shareManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {

    }];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateToNewestMarket:)]) {
        [self.delegate updateToNewestMarket:self.responseObject];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
