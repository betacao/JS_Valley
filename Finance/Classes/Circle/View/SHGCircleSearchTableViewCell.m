//
//  SHGCircleSearchTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGCircleSearchTableViewCell.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "CTTextDisplayView.h"
#import "SHGLinkViewController.h"
#import "SHGAuthenticationView.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGMainPageTableViewCell.h"

@interface SHGCircleSearchTableViewCell()<CTTextDisplayViewDelegate>

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet SHGAuthenticationView *authenticationView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *titleLabel;
@property (weak, nonatomic) IBOutlet CTTextDisplayView *contentLabel;
@property (weak, nonatomic) IBOutlet SHGMainPageBusinessView *businessView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (strong, nonatomic) NSArray *commentLabelArray;
@property (strong, nonatomic) CTTextStyleModel *styleModel;
@property (strong, nonatomic) CTTextStyleModel *titleStyleModel;
@end

@implementation SHGCircleSearchTableViewCell

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
    
    [self setupAutoHeightWithBottomView:self.splitView bottomMargin:0.0f];
    
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
    [self loadUserInfo:object];
    [self loadContent:object];
    [self loadPhotoView:object];
}

- (void)loadUserInfo:(CircleListObj *)object
{
    BOOL status = [object.userstatus isEqualToString:@"true"] ? YES : NO;
    [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.potname] placeholderImage:[UIImage imageNamed:@"default_head"] userID:object.userid];
    [self.authenticationView updateWithStatus:status];
    
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
        str = [object.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@...",str];
    }
    self.departmentLabel.text = str;
    
    self.timeLabel.text = object.publishdate;
    
}

- (void)loadContent:(CircleListObj *)object
{
    NSString *title = [[SHGGloble sharedGloble] formatStringToHtml:object.groupPostTitle];
    if (title.length > 0) {
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.headerView, kMainContentTopMargin)
        .leftEqualToView(self.headerView)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .heightIs([CTTextDisplayView getRowHeightWithText:title rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.titleStyleModel]);
    } else{
        self.titleLabel.sd_resetLayout
        .topSpaceToView(self.headerView, 0.0f)
        .leftEqualToView(self.headerView)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
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
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .heightIs([CTTextDisplayView getRowHeightWithText:detail rectSize:CGSizeMake(SCREENWIDTH -  2 * kMainItemLeftMargin, CGFLOAT_MAX) styleModel:self.styleModel]);
    } else{
        self.contentLabel.sd_resetLayout
        .topSpaceToView(self.titleLabel, 0.0f)
        .leftEqualToView(self.headerView)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
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
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .topSpaceToView(view, kMainPhotoViewTopMargin)
        .heightIs(CGRectGetHeight(photoGroup.frame));
    } else{
        self.photoView.sd_resetLayout
        .leftEqualToView(self.headerView)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .topSpaceToView(view, 0.0f)
        .heightIs(0.0f);
    }
    
    self.splitView.sd_resetLayout
    .topSpaceToView(self.photoView, MarginFactor(12.0f))
    .leftSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(kMainCellLineHeight);
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


