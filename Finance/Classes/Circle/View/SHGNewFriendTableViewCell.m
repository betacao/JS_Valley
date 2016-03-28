//
//  SHGNewFriendTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/3/16.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGNewFriendTableViewCell.h"
#import "SHGHomeViewController.h"
#import "ChatSendHelper.h"
#import "TTTAttributedLabel.h"
@interface SHGNewFriendTableViewCell()

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation SHGNewFriendTableViewCell

- (void)awakeFromNib
{
    [self.contentLabel addObserver:self forKeyPath:@"activeLink" options:NSKeyValueObservingOptionNew context:nil];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    [self.contentView bringSubviewToFront:self.headerView];
    
    self.nameLabel.font = kMainNameFont;
    self.nameLabel.textColor = kMainNameColor;
    
    self.companyLabel.font = kMainTimeFont;
    self.companyLabel.textColor = kMainTimeColor;
    
    self.departmentLabel.font = kMainCompanyFont;
    self.departmentLabel.textColor = kMainCompanyColor;
    
    self.contentLabel.isAttributedContent = YES;
    self.contentLabel.userInteractionEnabled = YES;
    
    self.relationLabel.font = FontFactor(14.0f);
    self.relationLabel.textColor = Color(@"919291");
    
    self.lineView.backgroundColor = kMainLineViewColor;
    
    self.splitView.backgroundColor = kMainSplitLineColor;
    
    [self.closeButton setEnlargeEdge:20.0f];
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
    .autoHeightRatio(0.0f);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.departmentLabel.sd_layout
    .bottomEqualToView(self.nameLabel)
    .leftSpaceToView(self.nameLabel, kMainCompanyToNameLeftMargin)
    .autoHeightRatio(0.0f);
    [self.departmentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.companyLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftEqualToView(self.nameLabel)
    .autoHeightRatio(0.0f);
    [self.companyLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.contentLabel.sd_layout
    .topSpaceToView(self.headerView, kMainHeaderViewTopMargin)
    .leftSpaceToView(self.contentView, MarginFactor(17.0f))
    .autoHeightRatio(0.0f);
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH - 2 * MarginFactor(17.0f)];

    self.relationLabel.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(17.0f))
    .topSpaceToView(self.contentLabel, kMainHeaderViewTopMargin)
    .autoHeightRatio(0.0f);
    [self.relationLabel setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH - 2 * MarginFactor(17.0f)];

    //描边
    self.lineView.sd_layout
    .topSpaceToView(self.relationLabel, kMainHeaderViewTopMargin)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(0.5f);

    //分割线
    self.splitView.sd_layout
    .topSpaceToView(self.lineView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(kMainCellLineHeight);

    CGSize size = self.closeButton.currentImage.size;
    self.closeButton.sd_layout
    .topEqualToView(self.headerView)
    .rightSpaceToView(self.contentView, kMainItemLeftMargin)
    .widthIs(size.width)
    .heightIs(size.height);

    [self setupAutoHeightWithBottomView:self.splitView bottomMargin:0.0f];
}

- (void)setObject:(SHGNewFriendObject *)object
{
    _object = object;
    [self clearCell];

    UIImage *placeHolder = [UIImage imageNamed:@"default_head"];
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.picName] placeholderImage:placeHolder status:NO userID:object.uid];
    self.nameLabel.text = object.realName;
    self.companyLabel.text = object.company;
    self.departmentLabel.text = object.title;
    
    NSString *string = [NSString stringWithFormat:@"您的通讯录联系人%@加入大牛圈啦，快去跟TA 打个招呼 吧！",object.realName];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:string];
    [content addAttributes:@{NSFontAttributeName:kMainContentFont, NSForegroundColorAttributeName:Color(@"545454")} range:NSMakeRange(0, content.length)];
    [content addAttributes:@{NSFontAttributeName:FontFactor(16.0f), NSForegroundColorAttributeName:Color(@"4277b2")} range:[string rangeOfString:@"打个招呼"]];
    self.contentLabel.attributedText = content;
    self.contentLabel.linkAttributes = nil;
    self.contentLabel.activeLinkAttributes = nil;
    [self.contentLabel addLinkToURL:[NSURL URLWithString:@"打个招呼"] withRange:[self.contentLabel.text rangeOfString:@"打个招呼"]];
    
    __block NSString *relation = @"";
    [object.commonFriendList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        relation = [relation stringByAppendingFormat:@"%@、",obj];
    }];
    if (relation.length > 0) {
        relation = [relation substringToIndex:relation.length - 1];
        if ([object.commonFriendCount intValue] > 3) {
            relation = [NSString stringWithFormat:@"你们共同拥有%@等%@位好友！",relation, object.commonFriendCount];
        } else{
            relation = [NSString stringWithFormat:@"你们共同拥有%@%@位好友！",relation, object.commonFriendCount];
        }
        self.relationLabel.text = relation;
    } else{
        self.relationLabel.text = @"";
        self.lineView.sd_resetLayout
        .topSpaceToView(self.contentLabel, kMainHeaderViewTopMargin)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(0.5f);
    }

   
}

- (void)clearCell
{
    self.nameLabel.text = @"";
    self.nameLabel.frame = CGRectZero;

    self.companyLabel.text = @"";
    self.companyLabel.frame = CGRectZero;

    self.departmentLabel.text = @"";
    self.departmentLabel.frame = CGRectZero;

    self.contentLabel.text = @"";
    self.contentLabel.frame = CGRectZero;

    self.relationLabel.text = @"";
    self.relationLabel.frame = CGRectZero;
}

- (IBAction)closeButtonClick:(UIButton *)sender
{
    [SHGHomeViewController sharedController].needShowNewFriend = NO;
    [SHGHomeViewController sharedController].needRefreshTableView = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"activeLink"]) {
        TTTAttributedLabelLink *link = [change objectForKey:@"new"];
        if (link && ![link isEqual:[NSNull null]]) {
            link.linkTapBlock = ^(TTTAttributedLabel *label, TTTAttributedLabelLink *labelLink){
                [ChatSendHelper sendTextMessageWithString:@"原来你也在这里啊～" toUsername:self.object.uid isChatGroup:NO requireEncryption:NO ext:nil];
                [Hud showMessageWithText:[NSString stringWithFormat:@"小信鸽大牛助手已将您的问候传达给%@!",self.object.realName]];
                [SHGHomeViewController sharedController].needShowNewFriend = NO;
                [SHGHomeViewController sharedController].needRefreshTableView = YES;
            };
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [self.contentLabel removeObserver:self forKeyPath:@"activeLink"];
}

@end


@interface SHGNewFriendObject()

@end

@implementation SHGNewFriendObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"uid":@"uid", @"realName":@"realname", @"title":@"title", @"picName":@"picname", @"company":@"company", @"position":@"position", @"commonFriendCount":@"commonfriendcount", @"commonFriendList":@"commonfriendlist"};
}

+ (NSValueTransformer *)commonFriendListJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *result = [NSMutableArray array];
        [value enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = [obj objectForKey:@"commonfriendname"];
            [result addObject:string];
        }];
        return result;
    }];
}

@end