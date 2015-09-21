//
//  CircleListTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/4/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
// 15.8   21  8.5  2.8

#import "CircleListTableViewCell.h"
#import "MLEmojiLabel.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"


@interface CircleListTableViewCell()<MLEmojiLabelDelegate>

//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
//赞按钮
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
//评论按钮
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
//评论区
@property (weak, nonatomic) IBOutlet UIView *viewComment;
//包含所有操作界面
@property (weak, nonatomic) IBOutlet UIView *actionView;
//图片区域
@property (weak, nonatomic) IBOutlet UIView *photoView;
//文字内容区域
@property (weak, nonatomic) IBOutlet MLEmojiLabel *lblContent;
//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
//个人信息界面
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
//用户名称
@property (weak, nonatomic) IBOutlet UIButton *btnUserName;
//时间标签
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
//职位标签
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
//公司名称
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
//好友关系、定位标签
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
//用户头像
@property (weak, nonatomic) IBOutlet headerView *imageHeader;
//最下层分割线
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (assign, nonatomic) CGFloat totalHeight;

//内容数据
@property (strong, nonatomic) CircleListObj *dataObj;
@property (weak ,nonatomic) NSArray *photoArr;

- (IBAction)actionDelete:(id)sender;
- (IBAction)actionGoSome:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionComment:(id)sender;
- (IBAction)actionPraise:(id)sender;
- (IBAction)actionAttention:(id)sender;

@end

@implementation CircleListTableViewCell

- (void)awakeFromNib
{
    self.lblContent.numberOfLines = 5;
    self.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblContent.font = [UIFont systemFontOfSize:14.0f];
    self.lblContent.delegate = self;
    self.lblContent.backgroundColor = [UIColor clearColor];

    DDTapGestureRecognizer *hdGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.imageHeader addGestureRecognizer:hdGes];
    self.imageHeader.userInteractionEnabled = YES;

    [self.viewComment setBackgroundColor:BACK_COLOR];

}

-(void)longtap:(UILongPressGestureRecognizer *)rec
{
    [self setSelected:YES];
    [self.delegate clicked:self.index];
}

-(void)loadDatasWithObj:(CircleListObj *)obj
{
    self.totalHeight = 0.0f;
    self.dataObj = obj;

    [self sizeUIWithObj:obj];

    //设置好友关系、定位标签的内容
    self.lblCityName.textColor = RGB(210, 209, 209);
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID] isEqualToString:obj.userid]){
        self.lblCityName.text = [NSString stringWithFormat:@"%@",obj.currcity];
    } else{
        //1.4遗留问题
        NSString *string = @"";
        if(obj.friendship && obj.friendship.length > 0){
            string = obj.friendship;
        }
        if(obj.currcity && obj.currcity.length > 0){
            string = [string stringByAppendingFormat:@",%@",obj.currcity];
        }
        self.lblCityName.text = string;
    }
    [self.lblCityName sizeToFit];
    
    //是否显示删除按钮
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]){
        self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }
    
    //是否显示关注按钮
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]] || [obj.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    } else{
        self.btnAttention.hidden = NO;
        
    }
    
    obj.photoArr = (NSArray *)obj.photos;
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
        self.btnAttention.hidden = YES;
    }
    
    //判断点赞状态
    if (![obj.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise setImage:[UIImage imageNamed:@"未赞"] forState:UIControlStateNormal];
    }else{
        [self.btnPraise setImage:[UIImage imageNamed:@"已赞"] forState:UIControlStateNormal];
    }
    
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.potname] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.imageHeader updateStatus:[obj.userstatus isEqualToString:@"true"] ? YES : NO];

    
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4) {
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    [self.btnUserName setTitle:name forState:UIControlStateNormal];
    
    NSString *str= obj.title;
    if (obj.title.length > 4) {
        str= [obj.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@…",str];
    }
    self.lblPosition.text = str;
    
    self.lblTime.text = obj.publishdate;
    
    [self.btnPraise setTitle:obj.praisenum forState:UIControlStateNormal];
    [self.btnComment setTitle:obj.cmmtnum forState:UIControlStateNormal];
    [self.btnShare setTitle:obj.sharenum forState:UIControlStateNormal];
    
    if ([obj.isattention isEqualToString:@"Y"]){
        [self.btnAttention setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal] ;
    }

    NSString *detail = obj.detail;
    NSLog(@"%@",obj.detail);
    self.lblContent.text = detail;
    CGSize size = [self.lblContent preferredSizeWithMaxWidth:kCellContentWidth];
    CGRect frame = self.lblContent.frame;
    frame.size.width = kCellContentWidth;
    frame.size.height = size.height;
    self.lblContent.frame = frame;
    
    CGFloat photoOriginX = CGRectGetMinX(self.lblContent.frame);
    CGFloat photoOriginY = CGRectGetMaxY(self.lblContent.frame);
    //第一次计算高度
    self.totalHeight = photoOriginY;

    //暂时这么写 不是很好 以后修改
    [self.photoView removeAllSubviews];
    frame = self.photoView.frame;
    frame.origin.x = photoOriginX;
    frame.origin.y = photoOriginY;
    frame.size.height = 0.0f;
    self.photoView.frame = frame;

    if ([obj.type isEqualToString:@"link"]){
        self.photoView.backgroundColor = RGB(245, 245, 241);
        linkOBj *link = obj.linkObj;
        UIImageView *linkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
        if (link.thumbnail) {
            [linkImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,link.thumbnail?:@"a"]] placeholderImage:[UIImage imageNamed:@"default_image"]];
        } else{
            linkImageView.image = [UIImage imageNamed:@"default_image"];
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,5, SCREENWIDTH -CELLRIGHT_WIDTH - 45,20 )];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setTextColor:TEXT_COLOR];
        [titleLabel setText:link.title];
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, SCREENWIDTH -CELLRIGHT_WIDTH - 45,20 )];
        [detailLabel setFont:[UIFont systemFontOfSize:13]];
        [detailLabel setTextColor:TEXT_COLOR];
        detailLabel.text = link.desc;
        [self.photoView addSubview:linkImageView];
        [self.photoView addSubview:titleLabel];
        [self.photoView addSubview:detailLabel];
        [self.photoView setFrame:CGRectMake(60, self.lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, 50)];
        DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTap:)];
        [self.photoView addGestureRecognizer:ges];
        
    } else if ([obj.type isEqualToString:TYPE_PHOTO]){
        self.photoArr = (NSArray *)obj.photoArr;
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [obj.photoArr enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,src];
            [temp addObject:item];
        }];
        photoGroup.photoItemArray = temp;
        [self.photoView addSubview:photoGroup];

        self.photoView.frame = CGRectMake(kPhotoViewLeftMargin, self.lblContent.bottom, CGRectGetWidth(photoGroup.frame),CGRectGetHeight(photoGroup.frame));
        
    }
    CGRect actionViewRect = self.actionView.frame;
    actionViewRect.origin.y = self.photoView.bottom;
    self.actionView.frame = actionViewRect;
    self.totalHeight = CGRectGetMaxY(actionViewRect);

    [self.viewComment removeAllSubviews];
    //显示的评论数
    NSInteger num = obj.comments.count;
    if (obj.comments.count > 0){
        self.viewComment.hidden = NO;
        CGRect commentRect = self.viewComment.frame;
        commentRect.origin.y = self.actionView.bottom;
        
        if ([obj.cmmtnum integerValue] > 3){
            if (obj.isPull){
                num =  [obj.cmmtnum integerValue];
            } else{
                num =  3;
            }
        }
        for (int i = 0; i < num; i ++){
            UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELLRIGHT_COMMENT_WIDTH, i * 20 + 10, SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, 20)];
            replyLabel.numberOfLines = 0;
            replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
            replyLabel.font = [UIFont fontWithName:@"Palatino" size:14];
            replyLabel.userInteractionEnabled = YES;
            replyLabel.tag = i + 1000;
            replyLabel.textColor = TEXT_COLOR;
            
            NSString *text = @"";
            commentOBj *comobj = obj.comments[i];
            
            NSMutableAttributedString *str;
            if (IsStrEmpty(comobj.rnickname)){
                text = [NSString stringWithFormat:@"%@:  %@",comobj.cnickname,comobj.cdetail];
                str = [[NSMutableAttributedString alloc] initWithString:text];
                [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 57, 67) range:NSMakeRange(0,comobj.cnickname.length+1+2 )];
            } else{
                text = [NSString stringWithFormat:@"%@回复%@:  %@",comobj.cnickname,comobj.rnickname,comobj.cdetail];
                str = [[NSMutableAttributedString alloc] initWithString:text];
                [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 57, 67) range:NSMakeRange(0,comobj.cnickname.length)];
                NSInteger cnicklen = comobj.cnickname.length;
                NSInteger rnicklen = comobj.rnickname.length;
                NSRange range = NSMakeRange(cnicklen + 2, rnicklen+1+2 );
                [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 57, 67) range:range];
            }
            [str addAttribute:NSFontAttributeName value:replyLabel.font range:NSMakeRange(0,text.length)];
            replyLabel.attributedText = str;
            CGRect replyRect = replyLabel.frame;
            if (i == 0){
                replyRect.origin.y = kObjectMargin;
            } else{
                replyRect.origin.y = CGRectGetHeight(commentRect);
            }
            CGSize replySize = [text sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(replyRect), MAXFLOAT) lineBreakMode:replyLabel.lineBreakMode];
            
            replyRect.size.height = replySize.height;
            replyLabel.frame = replyRect;
            commentRect.size.height = CGRectGetMaxY(replyRect) + kObjectMargin;
            DDTapGestureRecognizer *cGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick:)];
            cGes.tag = i;
            [self.viewComment addSubview:replyLabel];
        }
        
        if ([obj.cmmtnum integerValue] > 3){
            UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELLRIGHT_COMMENT_WIDTH,CGRectGetHeight(commentRect), SCREENWIDTH-CELLRIGHT_WIDTH, 20)];
            replyLabel.numberOfLines = 1;
            replyLabel.text = @"查看全部";
            replyLabel.font = [UIFont fontWithName:@"Palatino" size:14];
            replyLabel.userInteractionEnabled = YES;
            replyLabel.textColor = RGB(210, 209, 209);
            [self.viewComment addSubview:replyLabel];
            commentRect.size.height = CGRectGetMaxY(replyLabel.frame) + kObjectMargin;
        }
        self.viewComment.frame = commentRect;
        self.totalHeight = CGRectGetMaxY(commentRect) + kObjectMargin;
    } else{
        self.viewComment.hidden = YES;
    }
    
    [self addGraylineToBottom];
}

-(void)sizeUIWithObj:(CircleListObj *)obj
{
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4){
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    CGSize nameSize = [name sizeForFont:self.btnUserName.titleLabel.font constrainedToSize:CGSizeMake(100.0f, 20.0f) lineBreakMode:self.btnUserName.titleLabel.lineBreakMode];
    CGRect userRect = self.btnUserName.frame;
    userRect.size.width = nameSize.width;
    self.btnUserName.frame = userRect;
    
    CGRect companRect = self.lblCompanyName.frame;
    companRect.origin.x = self.btnUserName.right + kObjectMargin;
    NSString *comp = obj.company;
    if (obj.company.length > 5)
    {
        NSString *str = [obj.company substringToIndex:5];
        comp = [NSString stringWithFormat:@"%@…",str];
    }
    self.lblCompanyName.text = comp;
    
    CGSize companSize = [comp sizeForFont:self.lblCompanyName.font constrainedToSize:CGSizeMake(84, 15) lineBreakMode:self.lblCompanyName.lineBreakMode];
    companRect.size.width = companSize.width;
    self.lblCompanyName.frame = companRect;
    
    CGRect positionRect = self.lblPosition.frame;
    positionRect.origin.x = self.lblCompanyName.right + kObjectMargin / 2.0f;
    self.lblPosition.frame = positionRect;
    [self.btnUserName setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:nameSize] forState:UIControlStateHighlighted];
}

#pragma mark ------单元格之间灰条------
- (void)addGraylineToBottom
{
    //单元格之间灰条
    CGFloat originY = self.totalHeight;
    CGRect frame = self.bottomView.frame;
    frame.origin.y = originY;
    self.bottomView.frame = frame;
}

-(void)cnickClick:(UIButton *)sender
{
    
    NSLog(@"cnickCLick");
    commentOBj *obj = self.dataObj.comments[sender.tag];
    [self.delegate cnickCLick:obj.cid name:obj.cnickname];
}

-(void)rnickClick:(UIButton *)sender
{
    
    NSLog(@"rnickCLick");
    commentOBj *obj = self.dataObj.comments[sender.tag];
    [self.delegate cnickCLick:obj.rid name:obj.rnickname];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)actionAttention:(id)sender
{
    
    if ([self.dataObj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]])
    {
        [Hud showMessageWithText:@"不能关注自己"];
        return;
    }
    [self.delegate attentionClicked:self.dataObj];
    
}
- (IBAction)actionComment:(id)sender
{
    
    [self.delegate clicked:self.index];
    // [self.delegate clicked:self.inde]
}
- (IBAction)actionPraise:(id)sender
{
    [self.delegate praiseClicked:self.dataObj];
    
}
- (IBAction)actionShare:(id)sender
{
    
    [self.delegate shareClicked:self.dataObj];
}

- (IBAction)actionPull:(id)sender
{
    [self.delegate clicked:self.index];
}

-(void)headTap:(DDTapGestureRecognizer *)ges
{
    
    [self.delegate headTap:self.index];
}
-(void)click:(id )ges
{
    
    NSLog(@"click");
    [self.delegate clicked:self.index];
}
-(void)replyClick:(UIButton *)ges
{
    [self.delegate replyClicked:self.dataObj commentIndex:ges.tag];
}
-(void)imageTap:(DDTapGestureRecognizer *)ges
{
    NSInteger imageIndex=ges.tag-9999;
    [self.delegate photosTapWIthIndex:self.index imageIndex:imageIndex];
}

-(void)linkTap:(DDTapGestureRecognizer *)ges
{
    CircleLinkViewController *vc = [[CircleLinkViewController alloc] init];
    vc.link = self.dataObj.linkObj.link;
    UINavigationController *nav =  (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    [nav pushViewController:vc animated:YES];
}

- (IBAction)actionGoSome:(id)sender {
    [self headTap:nil];
}

- (IBAction)actionDelete:(id)sender {
    [self.delegate deleteClicked:self.dataObj];
}

@end
