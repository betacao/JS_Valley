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
#import "LinkViewController.h"
#import "SHGAuthenticationView.h"

@interface SHGMainPageTableViewCell()<CTTextDisplayViewDelegate>

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UILabel *firstCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthCommentLabel;

@property (strong, nonatomic) NSArray *commentLabelArray;
@property (strong, nonatomic) CTTextStyleModel *styleModel;
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
    [self.contentView bringSubviewToFront:self.headerView];

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
    
    [self.deleteButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:20.0f];
    [self.praiseButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:10.0f];
    [self.commentButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:10.0f];
    [self.shareButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:10.0f];
    [self.attentionButton setEnlargeEdgeWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
    
    self.praiseButton.titleLabel.font = kMainNameFont;
    self.praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -kMainActionTopMargin);
    [self.praiseButton setTitleColor:kMainActionColor forState:UIControlStateNormal];

    self.commentButton.titleLabel.font = kMainNameFont;
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -kMainActionTopMargin);
    [self.commentButton setTitleColor:kMainActionColor forState:UIControlStateNormal];

    self.shareButton.titleLabel.font = kMainNameFont;
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, -kMainActionTopMargin);
    [self.shareButton setTitleColor:kMainActionColor forState:UIControlStateNormal];

    self.commentView.backgroundColor = kMainCommentBackgroundColor;
    self.firstCommentLabel.isAttributedContent = YES;
    self.secondCommentLabel.isAttributedContent = YES;
    self.thirdCommentLabel.isAttributedContent = YES;
    self.fourthCommentLabel.isAttributedContent = YES;
    self.fourthCommentLabel.font = kMainCommentMoreFont;
    self.fourthCommentLabel.textColor = kMainCommentMoreColor;

    self.lineView.backgroundColor = kMainLineViewColor;

    self.splitView.backgroundColor = kMainSplitLineColor;
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
    .leftSpaceToView(self.headerView, MarginFactor(8.0f))
    .bottomEqualToView(self.headerView)
    .heightIs(MarginFactor(13.0f));

    self.timeLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftSpaceToView(self.authenticationView, MarginFactor(2.0f))
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

    UIImage *image = [UIImage imageNamed:@"newAddAttention"];
    self.attentionButton.sd_layout
    .topEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, kMainItemLeftMargin)
    .widthIs(image.size.width)
    .heightIs(image.size.height);

    //actionView
    [self.shareButton sizeToFit];
    CGSize shareButtonSize = self.shareButton.frame.size;
    self.shareButton.sd_layout
    .rightSpaceToView(self.actionView, kMainActionTopMargin)
    .centerYEqualToView(self.actionView)
    .widthIs(shareButtonSize.width + MarginFactor(10.0f))
    .heightIs(shareButtonSize.height);

    [self.commentButton sizeToFit];
    CGSize commentButtonSize = self.commentButton.frame.size;
    self.commentButton.sd_layout
    .rightSpaceToView(self.shareButton, MarginFactor(24.0f) )
    .centerYEqualToView(self.shareButton)
    .widthIs(commentButtonSize.width + MarginFactor(10.0f))
    .heightIs(commentButtonSize.height);

    [self.praiseButton sizeToFit];
    CGSize praiseButtonSize = self.praiseButton.frame.size;
    self.praiseButton.sd_layout
    .rightSpaceToView(self.commentButton, kMainActionTopMargin * 1.5f)
    .centerYEqualToView(self.shareButton)
    .widthIs(praiseButtonSize.width + MarginFactor(10.0f))
    .heightIs(praiseButtonSize.height);

    [self.deleteButton sizeToFit];
    CGSize deleteButtonSize = self.deleteButton.frame.size;
    self.deleteButton.sd_layout
    .rightSpaceToView(self.praiseButton, kMainActionTopMargin * 1.5f)
    .centerYEqualToView(self.shareButton)
    .widthIs(deleteButtonSize.width)
    .heightIs(deleteButtonSize.height);

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
    .topSpaceToView(self.firstCommentLabel, 0.0f)
    .autoHeightRatio(0.0f);

    self.thirdCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.secondCommentLabel, 0.0f)
    .autoHeightRatio(0.0f);

    self.fourthCommentLabel.sd_layout
    .leftSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .rightSpaceToView(self.commentView, kMainCommentContentLeftMargin)
    .topSpaceToView(self.thirdCommentLabel, 0.0f)
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

    self.nameLabel.text = @"";
    self.companyLabel.text = @"";
    self.departmentLabel.text = @"";
    self.timeLabel.text = @"";
    self.contentLabel.text = @"";
    self.relationLabel.text = @"";

    self.nameLabel.frame = CGRectZero;
    self.companyLabel.frame = CGRectZero;
    self.departmentLabel.frame = CGRectZero;
    self.timeLabel.frame = CGRectZero;
    self.contentLabel.frame = CGRectZero;
    self.relationLabel.frame = CGRectZero;
}

- (void)loadUserInfo:(CircleListObj *)object
{
    BOOL status = [object.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.potname] placeholderImage:[UIImage imageNamed:@"default_head"] status:status userID:object.userid];
    [self.authenticationView updateWithVStatus:status enterpriseStatus:object.businessStatus];
    
    NSString *name = object.nickname;
    if (object.nickname.length > 4){
        name = [object.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@...",name];
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
        str= [object.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@...",str];
    }
    self.departmentLabel.text = str;

    self.timeLabel.text = object.publishdate;

    if ([object.userid isEqualToString:UID]) {
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
    NSString *detail = [[SHGGloble sharedGloble] formatStringToHtml:object.detail];
    self.contentLabel.text = detail;
    if (detail.length > 0) {
        self.contentLabel.sd_resetLayout
        .topSpaceToView(self.headerView, kMainContentTopMargin)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs([CTTextDisplayView getRowHeightWithText:detail rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.styleModel]);
    } else{
        self.contentLabel.sd_resetLayout
        .topSpaceToView(self.headerView, 0.0f)
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .heightIs(0.0);
    }
}

- (void)loadPhotoView:(CircleListObj *)object
{
    [self.photoView removeAllSubviews];
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
        [self.photoView addSubview:photoGroup];

        self.photoView.sd_resetLayout
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .topSpaceToView(self.contentLabel, kMainContentTopMargin)
        .heightIs(CGRectGetHeight(photoGroup.frame));
    } else{
        self.photoView.sd_resetLayout
        .leftEqualToView(self.headerView)
        .rightEqualToView(self.attentionButton)
        .topSpaceToView(self.contentLabel, 0.0f)
        .heightIs(0.0f);
    }
}

- (void)loadActionView:(CircleListObj *)object
{
    //判断好友是一度好友还是二度好友
    if ([object.friendship isEqualToString:@"一度"]) {
        object.friendship = @"我的好友";
    } else if ([object.friendship isEqualToString:@"二度"]){
        object.friendship = @"好友的好友";
    }
    //设置好友关系、定位标签的内容
    if(![object.postType isEqualToString:@"pc"]){
        if ([UID isEqualToString:object.userid]){
            self.relationLabel.text = [NSString stringWithFormat:@"%@",object.currcity];
        } else{
            NSString *string = @"";
            if(object.friendship && object.friendship.length > 0){
                string = object.friendship;
            }
            if(object.currcity && object.currcity.length > 0){
                string = [string stringByAppendingFormat:@" , %@",object.currcity];
            }
            self.relationLabel.text = string;
        }
    } else{
        self.relationLabel.text = object.friendship;
    }

    //是否显示删除按钮
    if ([object.userid isEqualToString:UID]){
        self.deleteButton.hidden = NO;
    } else{
        self.deleteButton.hidden = YES;
    }

    if (![object.ispraise isEqualToString:@"Y"]) {
        [self.praiseButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    }else{
        [self.praiseButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }

    [self.praiseButton setTitle:object.praisenum forState:UIControlStateNormal];
    [self.praiseButton sizeToFit];
    [self.commentButton setTitle:object.cmmtnum forState:UIControlStateNormal];
    [self.commentButton sizeToFit];
    [self.shareButton setTitle:object.sharenum forState:UIControlStateNormal];
    [self.shareButton sizeToFit];

    self.actionView.sd_resetLayout
    .leftEqualToView(self.headerView)
    .rightEqualToView(self.attentionButton)
    .topSpaceToView(self.photoView, 0.0f)
    .heightIs(MarginFactor(49.0f));
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
        [paragraphStyle setLineSpacing:3];
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
    .heightIs(0.5f);

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

- (IBAction)deleteButtonClick:(UIButton *)sender
{
    [self.delegate deleteClicked:self.object];
}

- (IBAction)praiseButtonClick:(UIButton *)sender
{
    [self.delegate praiseClicked:self.object];
}

- (IBAction)commentButtonClick:(UIButton *)sender
{
    [self.delegate clicked:self.index];
}

- (IBAction)shareButtonClick:(UIButton *)sender
{
    [self.delegate shareClicked:self.object];
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
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
