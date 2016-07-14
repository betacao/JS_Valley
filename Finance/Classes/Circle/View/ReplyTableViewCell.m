//
//  ReplyTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/5/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "SHGPersonalViewController.h"

@interface ReplyTableViewCell()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *label;
@property (weak, nonatomic) IBOutlet UIView *spliteView;


@end

@implementation ReplyTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.bgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, kMainItemLeftMargin, 0.0f, kMainItemLeftMargin));

    self.label.font = kMainCommentNameFont;
    self.label.isAttributedContent = YES;
    self.label.delegate = self;
    self.label.numberOfLines = 0;
    self.label.textColor = kMainContentColor;
    self.label.backgroundColor = [UIColor clearColor];

    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];

    [mutableLinkAttributes setObject:kMainCommentMoreColor forKey:(NSString *)kCTForegroundColorAttributeName];

    self.label.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
    self.label.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
    
    self.spliteView.backgroundColor = [UIColor clearColor];

    [self setupAutoHeightWithBottomViewsArray:@[self.label, self.spliteView] bottomMargin:0.0f];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;

    SHGCommentType type = [[dataArray lastObject] integerValue];

    CGFloat margin = 0.0f;
    if (type == SHGCommentTypeFirst) {
        margin = kCommentTopMargin;
        self.spliteView.sd_resetNewLayout
        .topSpaceToView(self.contentView, 0.0f)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(margin);

        self.label.sd_resetNewLayout
        .topSpaceToView(self.spliteView, 0.0f)
        .leftSpaceToView(self.contentView, kMainItemLeftMargin)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .autoHeightRatio(0.0f);

    } else if (type == SHGCommentTypeNormal) {
        margin = kCommentMargin;
        self.spliteView.sd_resetNewLayout
        .topSpaceToView(self.contentView, 0.0f)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(margin);

        self.label.sd_resetNewLayout
        .topSpaceToView(self.spliteView, 0.0f)
        .leftSpaceToView(self.contentView, kMainItemLeftMargin)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .autoHeightRatio(0.0f);

    } else {
        margin = kCommentBottomMargin;

        self.label.sd_resetNewLayout
        .topSpaceToView(self.contentView, kCommentMargin)
        .leftSpaceToView(self.contentView, kMainItemLeftMargin)
        .rightSpaceToView(self.contentView, kMainItemLeftMargin)
        .autoHeightRatio(0.0f);

        self.spliteView.sd_resetNewLayout
        .topSpaceToView(self.label, 0.0f)
        .leftSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(margin);
    }

    commentOBj *object = [dataArray firstObject];
    NSString *string = @"";
    if (IsStrEmpty(object.rnickname)){
        string = [NSString stringWithFormat:@"%@:x%@",object.cnickname,object.cdetail];
        self.label.text = string;
        [self.label addLinkToPhoneNumber:object.cid withRange:[string rangeOfString:object.cnickname]];
    } else{
        string = [NSString stringWithFormat:@"%@回复%@:x%@",object.cnickname,object.rnickname,object.cdetail];
        self.label.text = string;
        [self.label addLinkToPhoneNumber:object.cid withRange:[string rangeOfString:object.cnickname]];
        [self.label addLinkToAddress:@{@"replyid":object.replyid} withRange:[string rangeOfString:object.rnickname]];
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = phoneNumber;
    controller.delegate = self.controller;
    [[TabBarViewController tabBar].navigationController pushViewController:controller animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents;
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.userId = [addressComponents objectForKey:@"replyid"];
    controller.delegate = self.controller;
    [[TabBarViewController tabBar].navigationController pushViewController:controller animated:YES];
}

@end
