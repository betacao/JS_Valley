//
//  CircleListObj.m
//  Finance
//
//  Created by HuMin on 15/4/15.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListObj.h"
#import "SHGGloble.h"
#import "MLEmojiLabel.h"

const CGFloat kUserInfoHeight = 55.0f;
const CGFloat kMoreCommentHeight = 20.0f;
const CGFloat kCutOffLineHeight = 10.0f;
const CGFloat kActionViewHeight = 34.0f;

@interface CircleListObj()
@property (assign, nonatomic) CGFloat totalHeight;


@end

@implementation CircleListObj

-(id)init{
    self = [super init];
    if (self) {
        self.isPull = NO;
    }
    return self;
}

-(NSMutableArray*)heads
{
    if (!_heads) {
        _heads = [NSMutableArray array];
    }
    return _heads;
}

-(NSMutableArray *)comments
{
    if (!_comments)
    {
        _comments = [NSMutableArray array];
    }
    return _comments;
    
}

-(NSArray *)photoArr
{
    if (!_photoArr)
    {
        _photoArr = [NSArray array];
    }
    return _photoArr;
    
}

-(CGFloat)fetchCellHeight
{
    self.totalHeight = 0.0f;
    if (IsStrEmpty(self.detail)){
        //加1的作用是引入的新的MLEmojiLabel 空字符也算1 的高度
        self.totalHeight = kUserInfoHeight + 1.0f;
    } else{
        MLEmojiLabel *globleLabel = [MLEmojiLabel new];
        globleLabel.numberOfLines = 5;
        globleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        globleLabel.font = [UIFont systemFontOfSize:14.0f];
        globleLabel.text = self.detail;
        CGSize size = [globleLabel preferredSizeWithMaxWidth:kCellContentWidth];
        self.totalHeight = size.height + kUserInfoHeight;
    }
    CGFloat photoHeight = 0.0;
    self.photoArr = (NSArray *)self.photos;
    if(self.photoArr.count > 0){
        NSInteger width = ceilf((SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELL_PHOTO_SEP * 2.0f) / 3.0f);
        if ([self.type isEqualToString:@"link"]){
            //这个是link的固定高度
            photoHeight = 50.0f;
        } else if ([self.type isEqualToString:TYPE_PHOTO]){
            if (IsArrEmpty(self.photoArr)) {
                photoHeight = 0.0f;
            } else{
                if (self.photoArr.count == 1 || self.photoArr.count >= 4){
                    photoHeight = width * 2.0f + CELL_PHOTO_SEP;
                } else if(self.photoArr.count < 4){
                    photoHeight = width;
                }
            }
        }
        self.totalHeight += (photoHeight + kPhotoViewTopMargin);
    }
    NSInteger num = 0;
    if ([self.cmmtnum intValue] > 3){
        if (self.isPull){
            num =  self.comments.count;
        } else{
            num =  3;
        }
    } else{
        num = self.comments.count;
        //评论数小于3条隐藏加载更多按钮
    }
    CGFloat commentHeight = 0.0f;
    if (num == 0) {
        commentHeight = 0.0f;
    } else{
        NSString *text = @"";
        commentHeight = kCommentTopMargin;
        for (int i = 0; i < num; i ++){
            commentOBj *comobj = self.comments[i];
            if (IsStrEmpty(comobj.rnickname)){
                text = [NSString stringWithFormat:@"%@:  %@",comobj.cnickname,comobj.cdetail];
            } else{
                text = [NSString stringWithFormat:@"%@回复%@:  %@",comobj.cnickname,comobj.rnickname,comobj.cdetail];
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:3];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH - (kPhotoViewLeftMargin + kPhotoViewRightMargin) - CELLRIGHT_COMMENT_WIDTH, 0.0f)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:14.0f];

            [attributedString addAttribute:NSFontAttributeName value:label.font range:NSMakeRange(0,text.length)];
            label.attributedText = attributedString;
            CGSize size = [label sizeThatFits:CGSizeMake(CGRectGetWidth(label.frame), MAXFLOAT)];
            CGFloat height = size.height;
            commentHeight += (height + kCommentMargin);
        }
        //这边加10 是为了让分割线和评论区域有个间隔 没有评论则不会加这个10
        self.totalHeight += kObjectMargin;
    }
    self.totalHeight += commentHeight;
    if ([self.cmmtnum integerValue] > 3) {
        self.totalHeight += (kCommentBottomMargin + kMoreCommentHeight);
    }else if([self.cmmtnum integerValue] > 0){
        self.totalHeight += (kCommentBottomMargin - kCommentMargin);
    }
    //加上灰色分割线的高度
    self.totalHeight += kCutOffLineHeight;
    //加上actionview的高度
    return  self.totalHeight + kActionViewHeight;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return  @{@"cmmtnum": @"cmmtnum",
              @"nickname":@"nickname",
              @"comments": @"comments",
              @"company": @"company",
              @"detail": @"detail",
              @"isattention": @"isattention",
              @"potname": @"potname",
              @"praisenum": @"praisenum",
              @"publishdate": @"publishdate",
              @"rid": @"rid",
              @"photos":@"attach",
              @"sharenum": @"sharenum",
              @"status": @"status",
              @"title": @"title",
              @"userid": @"userid",
              @"ispraise":@"ispraise",
              @"type":@"attachtype",
              @"linkObj":@"link",
//              @"sizes":@"sizes",
              @"postType":@"type",
              @"friendship":@"friendship",
              @"userstatus":@"userstatus",
              @"currcity":@"currcity",
              @"feedhtml":@"feedhtml"
              };
}


+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[commentOBj class]];
}

+ (NSValueTransformer *)linkObjJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[linkOBj class]];
}

@end

@implementation commentOBj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"cdetail":@"cdetail",
             @"cid":@"cid",
             @"cnickname":@"cnickname",
             @"rid":@"rid",
             @"rnickname":@"rnickname"};
}

@end

@implementation praiseOBj


@end

@implementation photoObj

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"photos":@"photos"};
}

@end

@implementation linkOBj

-(id)init
{
    self = [super init];
    if (self) {
        self.thumbnail = @"1";
    }
    return self;
}
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"title":@"title",
             @"desc":@"desc",
             @"link":@"link",
             @"thumbnail":@"thumbnail"};
}


@end
