//
//  SHGMainPageTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/8.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMainPageTableViewCell.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "CTTextDisplayView.h"
#import "SHGLinkViewController.h"
#import "SHGAuthenticationView.h"
#import "SHGBusinessNewDetailViewController.h"

@interface SHGMainPageTableViewCell()<CTTextDisplayViewDelegate>

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *titleLabel;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *contentLabel;
@property (weak, nonatomic) IBOutlet SHGMainPageBusinessView *businessView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (strong, nonatomic) SHGHorizontalTitleImageView *btnCollet;
@property (strong, nonatomic) SHGHorizontalTitleImageView *deleteButton;
@property (strong, nonatomic) SHGHorizontalTitleImageView *praiseButton;
@property (strong, nonatomic) SHGHorizontalTitleImageView *commentButton;
@property (strong, nonatomic) SHGHorizontalTitleImageView *shareButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UILabel *firstCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthCommentLabel;

@property (strong, nonatomic) NSArray *commentLabelArray;
@property (strong, nonatomic) CTTextStyleModel *styleModel;
@property (strong, nonatomic) CTTextStyleModel *titleStyleModel;
@end

@implementation SHGMainPageTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{

    self.titleLabel.delegate = self;
    self.titleLabel.styleModel = self.titleStyleModel;

    self.contentLabel.delegate = self;
    self.contentLabel.styleModel = self.styleModel;

    self.nameLabel.font = kMainNameFont;
    self.nameLabel.textColor = kMainNameColor;

    self.companyLabel.font = kMainCompanyFont;
    self.companyLabel.textColor = kMainCompanyColor;

    self.departmentLabel.font = kMainCompanyFont;
    self.departmentLabel.textColor = kMainCompanyColor;

    self.timeLabel.font = kMainTimeFont;
    self.timeLabel.textColor = kMainTimeColor;

    self.relationLabel.font = kMainRelationFont;
    self.relationLabel.textColor = kMainRelationColor;
    
    self.btnCollet = [[SHGHorizontalTitleImageView alloc] init];
    [self.btnCollet setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.btnCollet target:self addSeletor:@selector(actionCollection:)];

    self.deleteButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.deleteButton setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.deleteButton target:self addSeletor:@selector(deleteButtonClick:)];

    self.praiseButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.praiseButton setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.praiseButton target:self addSeletor:@selector(praiseButtonClick:)];

    self.commentButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.commentButton setEnlargeEdge:kMainActionButtonMargin / 2.0f];

    self.shareButton = [[SHGHorizontalTitleImageView alloc] init];
    [self.shareButton setEnlargeEdge:kMainActionButtonMargin / 2.0f];
    [self.shareButton target:self addSeletor:@selector(shareButtonClick:)];

    [self.actionView sd_addSubviews:@[self.btnCollet, self.deleteButton, self.praiseButton, self.commentButton, self.shareButton]];

    [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailCollection"]];
    [self.deleteButton addImage:[UIImage imageNamed:@"home_delete"]];

    [self.praiseButton addImage:[UIImage imageNamed:@"home_weizan"]];
    self.praiseButton.margin = MarginFactor(7.0f);

    [self.commentButton addImage:[UIImage imageNamed:@"home_comment"]];
    self.commentButton.margin = MarginFactor(7.0f);

    [self.shareButton addImage:[UIImage imageNamed:@"homeShare"]];
    self.shareButton.margin = MarginFactor(7.0f);

    [self.attentionButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];

    self.commentView.backgroundColor = kMainCommentBackgroundColor;
    self.firstCommentLabel.isAttributedContent = YES;
    self.secondCommentLabel.isAttributedContent = YES;
    self.thirdCommentLabel.isAttributedContent = YES;
    self.fourthCommentLabel.isAttributedContent = YES;
    self.fourthCommentLabel.font = kMainCommentMoreFont;
    self.fourthCommentLabel.textColor = kMainCommentMoreColor;

    self.lineView.backgroundColor = kMainLineViewColor;

    self.splitView.backgroundColor = kMainSplitLineColor;

    [self.contentView bringSubviewToFront:self.headerView];
}

- (void)addAutoLayout
{
    //头部
    self.headerView.sd_layout
    .topSpaceToView(self.contentView, kMainHeaderViewTopMargin)
    .leftSpaceToView(self.contentView, kMainItemLeftMargin)
    .heightIs(kMainHeaderViewHeight)
    .widthIs(kMainHeaderViewWidth);

    self.nameLabel.sd_layout
    .topEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, kMainNameToHeaderViewLeftMargin)
    .offset(-1.0f)
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.authenticationView.sd_layout
    .leftEqualToView(self.nameLabel)
    .bottomEqualToView(self.headerView);

    self.timeLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftSpaceToView(self.authenticationView, 0.0f)
    .autoHeightRatio(0.0f);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.companyLabel.sd_layout
    .bottomEqualToView(self.nameLabel)
    .leftSpaceToView(self.nameLabel, kMainCompanyToNameLeftMargin)
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.departmentLabel.sd_layout
    .bottomEqualToView(self.nameLabel)
    .leftSpaceToView(self.companyLabel, 0.0f)
    .autoHeightRatio(0.0f);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.attentionButton.sd_layout
    .topEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, kMainItemLeftMargin)
    .widthIs(self.attentionButton.currentImage.size.width)
    .heightIs(self.attentionButton.currentImage.size.height);

    //actionView
    self.shareButton.sd_layout
    .rightSpaceToView(self.actionView, 0.0f)
    .centerYEqualToView(self.actionView);

    self.commentButton.sd_layout
    .rightSpaceToView(self.shareButton, kMainActionButtonMargin)
    .centerYEqualToView(self.shareButton);

    self.praiseButton.sd_layout
    .rightSpaceToView(self.commentButton, kMainActionButtonMargin)
    .centerYEqualToView(self.shareButton);
    
    self.btnCollet.sd_layout
    .rightSpaceToView(self.praiseButton, kMainActionButtonMargin)
    .centerYEqualToView(self.praiseButton);

    self.deleteButton.sd_layout
    .rightSpaceToView(self.praiseButton, kMainActionButtonMargin)
    .centerYEqualToView(self.shareButton);

    self.relationLabel.sd_layout
    .leftSpaceToView(self.actionView, 0.0f)
    .centerYEqualToView(self.shareButton)
    .autoHeightRatio(0.0f);
    [self.relationLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    //评论区域
    self.firstCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.commentView, 0.0f)
    .autoHeightRatio(0.0f);

    self.secondCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.firstCommentLabel, kMainCommentContentMargin)
    .autoHeightRatio(0.0f);

    self.thirdCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.secondCommentLabel, kMainCommentContentMargin)
    .autoHeightRatio(0.0f);

    self.fourthCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.thirdCommentLabel, kMainCommentContentMargin)
    .autoHeightRatio(0.0f);

    [self setupAutoHeightWithBottomView:self.splitView bottomMargin:0.0f];

}

- (NSArray *)commentLabelArray
{
    if (!_commentLabelArray) {
        _commentLabelArray = @[self.firstCommentLabel, self.secondCommentLabel, self.thirdCommentLabel, self.fourthCommentLabel];
    }
    return _commentLabelArray;
}

- (CTTextStyleModel *)styleModel
{
    if (!_styleModel) {
        _styleModel = [[CTTextStyleModel alloc] init];
    }
    return _styleModel;
}

- (CTTextStyleModel *)titleStyleModel
{
    if (!_titleStyleModel) {
        _titleStyleModel = [[CTTextStyleModel alloc] init];
        _titleStyleModel.textColor = kMainTitleColor;
        _titleStyleModel.font = kMainTitleFont;
        _titleStyleModel.numberOfLines = -1;
    }
    return _titleStyleModel;
}

- (void)setObject:(CircleListObj *)object
{
    _object = object;
    [self clearCell];
    [self loadUserInfo:object];
    [self loadContent:object];
    [self loadPhotoView:object];
    [self loadActionView:object];
    [self loadCommentView:object];
}

- (void)clearCell
{
    self.firstCommentLabel.text = @"";
    self.secondCommentLabel.text = @"";
    self.thirdCommentLabel.text = @"";
    self.fourthCommentLabel.text = @"";

    self.firstCommentLabel.frame = CGRectZero;
    self.secondCommentLabel.frame = CGRectZero;
    self.thirdCommentLabel.frame = CGRectZero;
    self.fourthCommentLabel.frame = CGRectZero;
}

- (void)loadUserInfo:(CircleListObj *)object
{
    BOOL status = [object.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.potname] placeholderImage:[UIImage imageNamed:@"default_head"] userID:object.userid];
    [self.authenticationView updateWithStatus:status];

    NSString *name = object.nickname;
    if (![object.usertype isEqualToString:@"businessAccount"]) {
        if (object.nickname.length > 4){
            name = [object.nickname substringToIndex:4];
            name = [NSString stringWithFormat:@"%@...",name];
        }
    }
    self.nameLabel.text = name;

    NSString *company = object.company;
    if (object.company.length > 6) {
        NSString *str = [object.company substringToIndex:6];
        company = [NSString stringWithFormat:@"%@...",str];
    }
    self.companyLabel.text = company;

    NSString *str = object.title;
    if (object.title.length > 4) {
        str = [object.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@...",str];
    }
    self.departmentLabel.text = str;

    self.timeLabel.text = object.publishdate;
    
    if ([object.userid isEqualToString:UID] || [object.userid isEqualToString:@"-2"]) {
        self.attentionButton.hidden = YES;
    } else{
        self.attentionButton.hidden = NO;
    }

    if (self.object.isAttention || [object.userid isEqualToString:CHATID_MANAGER]){
        [self.attentionButton setImage:[UIImage imageNamed:@"newAttention"] forState:UIControlStateNormal] ;
    } else{
        [self.attentionButton setImage:[UIImage imageNamed:@"newAddAttention"] forState:UIControlStateNormal] ;
    }
}

- (void)loadContent:(CircleListObj *)object
{
    NSString *title = [[SHGGloble sharedGloble] formatStringToHtml:object.groupPostTitle];
    if (title.length > 0) {
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.headerView, kMainContentTopMargin)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs([CTTextDisplayView getRowHeightWithText:title rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.titleStyleModel]);
    } else{
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.headerView, 0.0f)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs(0.0);
    }

    self.titleLabel.text = title;

    if ([object.postType isEqualToString:@"business"]) {
        self.businessView.hidden = NO;
        self.contentLabel.hidden = YES;
        NSString *businessID = self.object.businessID;
        SHGBusinessObject *businessObject = [[SHGBusinessObject alloc] init];
        NSArray *array = [businessID componentsSeparatedByString:@"#"];
        if (array.count == 2) {
            businessObject.businessTitle = object.detail;
            businessObject.businessID = [array firstObject];
            businessObject.type = [array lastObject];
            self.businessView.object = businessObject;
        }
    } else {
        self.businessView.hidden = YES;
        self.contentLabel.hidden = NO;
    }
    self.businessView.sd_resetLayout
    .topSpaceToView(self.titleLabel, kMainContentTopMargin)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(MarginFactor(59.0f));

    NSString *detail = [[SHGGloble sharedGloble] formatStringToHtml:object.detail];
    if (detail.length > 0) {
        self.contentLabel.sd_resetLayout
        .topSpaceToView(self.titleLabel, kMainContentTopMargin / 2.0f)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs([CTTextDisplayView getRowHeightWithText:detail rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.styleModel]);
    } else{
        self.contentLabel.sd_resetLayout
        .topSpaceToView(self.titleLabel, 0.0f)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs(0.0);
    }
    self.contentLabel.text = detail;
}

- (void)loadPhotoView:(CircleListObj *)object
{
    [self.photoView removeAllSubviews];
    UIView *view = self.businessView.hidden ? self.contentLabel : self.businessView;
    if ([object.type isEqualToString:TYPE_PHOTO]){
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [object.photos enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,src];
            item.object = object;
            [temp addObject:item];
        }];
        photoGroup.photoItemArray = temp;
        photoGroup.style = SDPhotoGroupStyleThumbnail;
        [self.photoView addSubview:photoGroup];

        self.photoView.sd_resetLayout
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .topSpaceToView(view, kMainPhotoViewTopMargin)
        .heightIs(CGRectGetHeight(photoGroup.frame));
    } else{
        self.photoView.sd_resetLayout
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .topSpaceToView(view, 0.0f)
        .heightIs(0.0f);
    }
}

- (void)loadActionView:(CircleListObj *)object
{

    //判断好友是一度好友还是二度好友
    NSString *friendShip = object.friendship;
    if ([friendShip isEqualToString:@"一度"]) {
        friendShip = @"一度人脉";
    } else if ([friendShip isEqualToString:@"二度"]){
        friendShip = @"二度人脉";
    }
    //设置好友关系、定位标签的内容
    if(![object.postType isEqualToString:@"pc"]){
        if ([UID isEqualToString:object.userid]){
            self.relationLabel.text = [NSString stringWithFormat:@"%@",object.currcity];
        } else{
            NSString *string = @"";
            if(friendShip && friendShip.length > 0){
                string = friendShip;
                if(object.currcity && object.currcity.length > 0){
                    string = [string stringByAppendingFormat:@" , %@",object.currcity];
                }
                self.relationLabel.text = string;
            } else {
                self.relationLabel.text = string;
            }
        }
    } else{
        self.relationLabel.text = friendShip;
    }
    //聚合账号展示
    if ([object.usertype isEqualToString:@"businessAccount"]) {
        self.relationLabel.text = @"";
    }
    //是否显示删除按钮
    if ([object.userid isEqualToString:UID]){
        self.deleteButton.hidden = NO;
    } else{
        self.deleteButton.hidden = YES;
    }

    if (![object.ispraise isEqualToString:@"Y"]) {
        [self.praiseButton addImage:[UIImage imageNamed:@"home_weizan"]];
    }else{
        [self.praiseButton addImage:[UIImage imageNamed:@"home_yizan"]];
    }
    if (self.collectionHidden == YES) {
        [self.btnCollet addImage:nil];
    } else{
        if (![object.iscollection isEqualToString:@"Y"]) {
            [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailNoCollection"]];
        } else{
            [self.btnCollet addImage:[UIImage imageNamed:@"homeDetailCollection"]];
        }
    }
    
    [self.praiseButton addTitle:object.praisenum];
    [self.commentButton addTitle:object.cmmtnum];
    [self.shareButton addTitle:object.sharenum];

    self.actionView.sd_resetLayout
    .leftEqualToView(self.headerView)
    .rightEqualToView(self.attentionButton)
    .topSpaceToView(self.photoView, 0.0f)
    .heightIs(kMainActionHeight);
}

- (void)loadCommentView:(CircleListObj *)object
{
    NSInteger count = self.object.comments.count;
    for(NSInteger i = 0; i < count; i++){
        UILabel *label = [self.commentLabelArray objectAtIndex:i];

        commentOBj *commentObject = [object.comments objectAtIndex:i];
        NSMutableAttributedString *string = nil;
        if (IsStrEmpty(commentObject.rnickname)) {
            //不是对某人的回复
            NSString *text = [NSString stringWithFormat:@"%@：%@",commentObject.cnickname,commentObject.cdetail];
            string = [[NSMutableAttributedString alloc] initWithString:text];
            [string addAttributes:@{NSForegroundColorAttributeName:kMainContentColor, NSFontAttributeName:kMainCommentNameFont} range:NSMakeRange(0, string.length)];

            NSRange range = NSMakeRange(0, commentObject.cnickname.length + 1);
            [string addAttributes:@{NSForegroundColorAttributeName:kMainCommentNameColor, NSFontAttributeName:kMainCommentNameFont} range:range];
        } else{
            NSString *text = [NSString stringWithFormat:@"%@回复%@：%@",commentObject.cnickname,commentObject.rnickname,commentObject.cdetail];
            string = [[NSMutableAttributedString alloc] initWithString:text];
            [string addAttributes:@{NSForegroundColorAttributeName:kMainContentColor, NSFontAttributeName:kMainCommentNameFont} range:NSMakeRange(0, string.length)];

            NSRange range = NSMakeRange(0, commentObject.cnickname.length);
            [string addAttributes:@{NSForegroundColorAttributeName:kMainCommentNameColor, NSFontAttributeName:kMainCommentNameFont} range:range];

            NSInteger cnicklen = commentObject.cnickname.length;
            NSInteger rnicklen = commentObject.rnickname.length;
            range = NSMakeRange(cnicklen + 2, rnicklen + 1);

            [string addAttributes:@{NSForegroundColorAttributeName:kMainCommentNameColor, NSFontAttributeName:kMainCommentNameFont} range:range];
        }
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:kMainCommentContentLineSpace];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        label.attributedText = string;
    }
    if ([object.cmmtnum integerValue] > 3) {
        self.fourthCommentLabel.text = [NSString stringWithFormat:@"查看全部%@条评论",object.cmmtnum];
    }

    CGFloat margin = count == 0 ? 0.0f : kMainCommentContentTopMargin;

    self.firstCommentLabel.sd_resetLayout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.commentView, margin)
    .autoHeightRatio(0.0f);

    UIView *lastView = nil;
    if ([object.cmmtnum integerValue] > 3) {
        lastView = self.fourthCommentLabel;
    } else if (count == 0 || count == 1) {
        lastView = self.firstCommentLabel;
    } else if (count == 2) {
        lastView = self.secondCommentLabel;
    } else if (count == 3) {
        lastView = self.thirdCommentLabel;
    }

    self.commentView.sd_resetLayout
    .topSpaceToView(self.actionView, 0.0f)
    .leftEqualToView(self.headerView)
    .rightEqualToView(self.attentionButton);
    [self.commentView setupAutoHeightWithBottomView:lastView bottomMargin:margin];

    //描边
    self.lineView.sd_resetLayout
    .topSpaceToView(self.commentView, margin)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    //分割线
    self.splitView.sd_resetLayout
    .topSpaceToView(self.lineView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(kMainCellLineHeight);
}

- (IBAction)attentionButtonClick:(UIButton *)sender
{
    if ([self.object.userid isEqualToString:UID]){
        [Hud showMessageWithText:@"不能关注自己"];
        return;
    }
    [SHGGlobleOperation addAttation:self.object];
}

- (void)deleteButtonClick:(UIButton *)sender
{
    [SHGGlobleOperation deleteObject:self.object];
}

- (void)praiseButtonClick:(UIButton *)sender
{
    [SHGGlobleOperation addPraise:self.object];
}

- (void)shareButtonClick:(UIButton *)sender
{
    [self.delegate shareClicked:self.object];
}

- (void)actionCollection:(UIButton *)sender
{
    [SHGGlobleOperation collectObject:self.object];
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
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end



@interface SHGMainPageBusinessView()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation SHGMainPageBusinessView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = kMainCommentBackgroundColor;

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_head"]];

    self.label = [[UILabel alloc] init];
    self.label.textColor = kMainContentColor;
    self.label.font = kMainContentFont;

    [self.contentView sd_addSubviews:@[self.label, self.imageView]];
    [self addSubview:self.contentView];
}

- (void)addAutoLayout
{
    self.contentView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, kMainItemLeftMargin, 0.0f, kMainItemLeftMargin));

    self.imageView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(8.0f))
    .topSpaceToView(self.contentView, MarginFactor(8.0f))
    .bottomSpaceToView(self.contentView, MarginFactor(8.0f))
    .widthEqualToHeight();

    self.label.sd_layout
    .leftSpaceToView(self.imageView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0.0f);

}

- (void)setObject:(SHGBusinessObject *)object
{
    _object = object;
    NSString *title = object.businessTitle;
    if (title.length > 20) {
        title = [[title substringToIndex:20] stringByAppendingString:@"..."];
    }
    title = [@"【业务】 " stringByAppendingString:title];
    self.label.text = title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.object) {
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        self.object.auditState = @"0";
        controller.object = self.object;
        [[SHGHomeViewController sharedController].navigationController pushViewController:controller animated:YES];
    }
}

@end
