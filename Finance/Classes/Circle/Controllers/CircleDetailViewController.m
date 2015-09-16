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
#define PRAISE_SEPWIDTH     6
#define PRAISE_RIGHTWIDTH     40

@interface CircleDetailViewController ()<MLEmojiLabelDelegate>
{
    UIControl *backView;
    CGFloat contentOrigin;
    UIView *PickerBackView;
    NSString *copyString;
    NSString *commentRid;
    
}
- (IBAction)actionDelete:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *linComent;
@property (weak, nonatomic) IBOutlet UILabel *linePraise;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITextField *txtInput;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
- (IBAction)actionGoSome:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNickname;

@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (nonatomic, strong)BRCommentView *popupView;

@property (weak, nonatomic) IBOutlet UIButton *btnCollet;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewPraise;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet headerView *imageHeader;

- (IBAction)actionAttention:(id)sender;
- (IBAction)actionComment:(id)sender;
- (IBAction)actionPraise:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionCollection:(id)sender;

@end

@implementation CircleDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = @"帖子详情";
    }
    return  self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleDetailViewController" label:@"onClick"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lblContent.numberOfLines = 0;
    _lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    _lblContent.font = [UIFont systemFontOfSize:14.0f];
    _lblContent.emojiDelegate = self;
    _lblContent.backgroundColor = [UIColor clearColor];
    _lblContent.isNeedAtAndPoundSign = YES;
    NSLog(@"%@",self.rid);
    [self initData];
    _viewHeader.hidden = YES;
    self.listTable.tag = 1101;
    self.listTable.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.viewInput];
    NSLog(@"%f/%f",SCREENHEIGHT,SCREENWIDTH);
    if (SCREENHEIGHT == 480)
    {
        CGRect rect = self.listTable.frame;
        rect.size.height = self.view.height;
        [self.listTable setFrame:rect];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_FRIENDSUCCESS object:nil];
    
    _btnSend.layer.masksToBounds = YES;
    _btnSend.layer.cornerRadius = 8;
    contentOrigin = _lblContent.origin.y;
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:NO andFooter:NO];
    [Hud showLoadingWithMessage:@"加载中"];
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circledetail"] class:[CircleListObj class] parameters:@{@"rid":self.rid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        
        NSLog(@"%@  arr === %@",response.data,response.dataDictionary);
        if (response.dataDictionary) {
            [self parseObjWithDic:response.dataDictionary];
            [self loadDatasWithObj:self.obj];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        
        [Hud showMessageWithText:response.errorMessage];
    }];
    
    
}
-(void)shareSuccess
{
    self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
}
-(void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
            if ([self.obj.rid isEqualToString:rid]) {
                [self otherShareWithObj:self.obj];
        }
    }
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
    self.obj.sizes = dic[@"sizes"];
    NSDictionary *link = dic[@"link"];
    if ([self.obj.type isEqualToString:@"link"])
    {
        linkOBj *linkObj = [[linkOBj alloc] init];
        linkObj.title = link[@"title"];
        linkObj.desc = link[@"desc"];
        
        linkObj.desc = link[@"desc"];
        
        linkObj.thumbnail = link[@"thumbnail"];
        self.obj.linkObj = linkObj;
    }

}
-(void)initData
{
    if (!self.obj) {
        self.obj = [[CircleListObj alloc] init];
    }
}

-(void)loadDatasWithObj:(CircleListObj *)obj
{
    self.viewHeader.hidden = NO;

    self.obj.photoArr = (NSArray *)obj.photos;
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]] || [obj.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    }
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]){
       self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }
    
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.potname] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.imageHeader updateStatus:[obj.userstatus isEqualToString:@"true"] ? YES : NO];
    
    DDTapGestureRecognizer *hdGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.imageHeader addGestureRecognizer:hdGes];
    self.imageHeader.userInteractionEnabled = YES;
    if (![obj.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise setImage:[UIImage imageNamed:@"未赞"] forState:UIControlStateNormal];
    } else{
        [self.btnPraise setImage:[UIImage imageNamed:@"已赞"] forState:UIControlStateNormal];
    }
    if (![obj.iscollection isEqualToString:@"Y"]) {
        [self.btnCollet setImage:[UIImage imageNamed:@"收藏m"] forState:UIControlStateNormal];
    } else{
        [self.btnCollet setImage:[UIImage imageNamed:@"收藏x"] forState:UIControlStateNormal];
    }
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4){
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    self.btnNickname.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.btnNickname setTitle:name forState:UIControlStateNormal];
    [self.btnNickname setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:self.btnNickname.size] forState:UIControlStateHighlighted];
    
    self.lblUserName.text = obj.company;
    NSString *str= obj.title;
    if (obj.title.length > 4){
        str= [obj.title substringToIndex:4];
        str = [NSString stringWithFormat:@"%@…",str];
    }
    self.lblPosition.text = str;
    self.lblTime.text = obj.publishdate;
    [self.btnShare setTitle:obj.sharenum forState:UIControlStateNormal];
    [self.btnComment setTitle:obj.cmmtnum forState:UIControlStateNormal];
    [self.btnPraise setTitle:obj.praisenum forState:UIControlStateNormal];
    
    if ([obj.isattention isEqualToString:@"Y"]){
        [self.btnAttention setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal] ;
    }
    
    [self.lblContent setEmojiText:obj.detail];
    [self.lblContent sizeToFit];
    [self sizeUIWithObj:obj];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, 0)];
    NSInteger width = (SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELL_PHOTO_SEP * 2.0f) / 3.0f;
    
    if ([self.obj.type isEqualToString:@"link"])
    {
        photoView.backgroundColor = RGB(245, 245, 241);
        linkOBj *link = obj.linkObj;
        UIImageView *linkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 40, 40)];
        if (link.thumbnail){
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
        [photoView addSubview:linkImageView];
        [photoView addSubview:titleLabel];
        [photoView addSubview:detailLabel];
        [photoView setFrame:CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, 50)];
        photoView.userInteractionEnabled = YES;
        DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTap:)];
        [photoView addGestureRecognizer:ges];
    } else if ([self.obj.type isEqualToString:TYPE_PHOTO]){
        
        if (!IsArrEmpty(obj.photoArr))
        {
            NSArray *photoArr = obj.photoArr;
            if (photoArr.count == 1)
            {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.userInteractionEnabled = YES;
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.tag = 9999 ;
                
                DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
                ges.tag = 9999;
                [imageView addGestureRecognizer:ges];
                CGSize size = CGSizeZero;
                CGSize imageSize = CGSizeZero;

                NSArray *sizeArr = [obj.sizes[0] componentsSeparatedByString:@"*"];
                if (sizeArr.count > 1){
                    size.width = [sizeArr[0] floatValue];
                    size.height = [sizeArr[1] floatValue];
                    //高度大于宽度
                    if (size.height > size.width){
                        if (size.height > width * 2.5f){
                            //超过3倍尺寸，需要缩放
                            imageSize.width = imageSize.height = 2.0f * width + CELL_PHOTO_SEP;
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                        } else{
                            //用图片尺寸，不需要缩放
                            imageSize.height = size.height;
                            imageSize.width = size.width;
                        }
                    } else{
                        if (size.width > width * 2.5f){
                            //超过3倍尺寸，需要缩放
                            imageSize.width = imageSize.height = 2.0f * width + CELL_PHOTO_SEP;
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                        } else{
                            //用图片尺寸，不需要缩放
                            imageSize.height = size.height;
                            imageSize.width = size.width;
                        }
                    }
                    
                   
                }
                [imageView setFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.photoArr[0]]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_image"]];
                [photoView addSubview:imageView];
                photoView.frame = CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, imageSize.height);
            }
            else if (photoArr.count <4 )
            {
                
                for (int i = 0; i < obj.photoArr.count; i ++)
                {
                    int originY;
                    originY = 0;
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.userInteractionEnabled = YES;
                    imageView.tag = 9999 + i;
                    
                    DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
                    ges.tag = 9999+ i;
                    [imageView addGestureRecognizer:ges];
                    [imageView setFrame:CGRectMake((width +CELL_PHOTO_SEP) * (i%3) ,originY,width , width)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.photoArr[i]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                    [photoView addSubview:imageView];
                }
                photoView.frame = CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH,width);
            }
            
            else if (obj.photoArr.count == 4)
            {
                for (int i = 0; i < obj.photoArr.count; i ++)
                {
                    NSInteger originY = 0;
                    if (i > 1) {
                        originY = width + CELL_PHOTO_SEP;
                    }
                    else
                    {
                        originY = 0;
                    }
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.userInteractionEnabled = YES;
                    imageView.tag = 9999 + i;
                    
                    DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
                    ges.tag = 9999+ i;
                    [imageView addGestureRecognizer:ges];
                    [imageView setFrame:CGRectMake((width +CELL_PHOTO_SEP) * (i%2) ,originY,width , width)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.photoArr[i]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                    [photoView addSubview:imageView];
                }
                photoView.frame = CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, (width*2) + CELL_PHOTO_SEP);
            }
            else
            {
                for (int i = 0; i < obj.photoArr.count; i ++)
                {
                    NSInteger originY = 0;
                    if (i > 2) {
                        originY = width + CELL_PHOTO_SEP;
                    }
                    else
                    {
                        originY = 0;
                    }
                    UIImageView *imageView = [[UIImageView alloc] init];
                    imageView.userInteractionEnabled = YES;
                    imageView.tag = 9999 + i;
                    
                    DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
                    ges.tag = 9999+ i;
                    [imageView addGestureRecognizer:ges];
                    [imageView setFrame:CGRectMake((width +CELL_PHOTO_SEP) * (i%3) ,originY,width , width)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.photoArr[i]]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                    [photoView addSubview:imageView];
                }
                photoView.frame = CGRectMake(60, _lblContent.bottom + 10, SCREENWIDTH-CELLRIGHT_WIDTH, (width*2) + CELL_PHOTO_SEP);
            }
            //   ======================
            
        }

        //=============
      
        
    }else{
    
    }
    [self.viewHeader addSubview:photoView];
    CGRect actionViewRect = _actionView.frame;
    actionViewRect.origin.y = photoView.bottom + 20.0f;
    _actionView.frame = actionViewRect;
    
    CGRect praiseRect = _viewPraise.frame;
    praiseRect.origin.y = _actionView.bottom;
    CGFloat praiseWidth = 0;
    if ([self.obj.praisenum intValue] >0)
    {
        for (UIView *subView in _scrollPraise.subviews)
        {
            if (subView.tag >=1000) {
                [subView removeFromSuperview];
            }
        }
        praiseRect.size.height = 55;
        for (int i = 0; i < self.obj.heads.count; i ++ )
        {
            praiseOBj *obj = self.obj.heads[i];

            praiseWidth = (340-75-6*PRAISE_SEPWIDTH -PRAISE_RIGHTWIDTH )/6;
            NSLog(@"%f",SCREENWIDTH);
            CGRect rect = CGRectMake(0 + (praiseWidth+PRAISE_SEPWIDTH) *i , (55-praiseWidth)/2, praiseWidth, praiseWidth);
            UIImageView *head = [[UIImageView alloc] initWithFrame:rect];
            head.tag = i + 1000;
            [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            head.userInteractionEnabled = YES;
            DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSome:)];
            ges.tag = i+ 1000;
            [head addGestureRecognizer:ges];
            [_scrollPraise addSubview:head];
            
        }
        [_scrollPraise setContentSize:CGSizeMake(self.obj.heads.count *(praiseWidth+PRAISE_SEPWIDTH), 55)];
        _viewPraise.hidden = NO;

        
    }
    else
    {
        praiseRect.size.height = 0;
        _viewPraise.hidden = YES;
    }
    _viewPraise.frame = praiseRect;
    CGRect  commentRect = _viewComment.frame;
    NSInteger num = [self.obj.cmmtnum integerValue];
    num = 0;
    for (int i = 0; i < num; i ++)
    {
        UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, i * 20 + 10, SCREENWIDTH - CELLRIGHT_WIDTH, 20)];

        replyLabel.numberOfLines = 0;
        replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        replyLabel.font = [UIFont fontWithName:@"Palatino" size:14];
        replyLabel.userInteractionEnabled = YES;
        replyLabel.tag = i + 1000;
        replyLabel.textColor = TEXT_COLOR;
        //replyLabel.textColor = [UIColor redColor];
        NSString *text ;
        commentOBj *comobj = obj.comments[i];
        
        NSMutableAttributedString *str;
        UIButton *cnickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *rnickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cnickButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
        [rnickButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
        cnickButton.tag = i;
        rnickButton.tag = i;
        if (IsStrEmpty(comobj.rnickname))
        {
            text = [NSString stringWithFormat:@"%@:x%@",comobj.cnickname,comobj.cdetail];
            
            
            CGSize cSize = [[NSString stringWithFormat:@"%@:",comobj.cnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
            [cnickButton setBackgroundColor:[UIColor whiteColor]];
            [cnickButton setFrame:CGRectMake(-3, 0, cSize.width, cSize.height)];
            [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [cnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.cnickname] forState:UIControlStateNormal];
            [cnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
            [cnickButton.titleLabel setFont:replyLabel.font];
            [replyLabel addSubview:cnickButton];
            str = [[NSMutableAttributedString alloc] initWithString:text];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length+1+1 )];
            [str addAttribute:NSFontAttributeName value:replyLabel.font range:NSMakeRange(0, comobj.cnickname.length+1)];
            
            
        }
        else
        {
            
            text = [NSString stringWithFormat:@"%@回复%@:x%@",comobj.cnickname,comobj.rnickname,comobj.cdetail];
            CGSize cSize = [comobj.cnickname sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
            NSLog(@"%@",comobj.cnickname);
            [cnickButton setBackgroundColor:[UIColor whiteColor]];
            [cnickButton setFrame:CGRectMake(-3, 0, cSize.width, cSize.height)];
            [cnickButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [cnickButton setTitle:comobj.cnickname forState:UIControlStateNormal];
            [cnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
            [cnickButton.titleLabel setFont:replyLabel.font];
            [replyLabel addSubview:cnickButton];
            str = [[NSMutableAttributedString alloc] initWithString:text];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,comobj.cnickname.length)];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(comobj.cnickname.length + 2,1 + comobj.rnickname.length +1)];
            
            NSString *leftText = [NSString stringWithFormat:@"回复"];
            CGSize leftSize = [leftText sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
            CGSize rSize = [[NSString stringWithFormat:@"%@:",comobj.rnickname] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        
            [rnickButton setBackgroundColor:[UIColor whiteColor]];
            [rnickButton setFrame:CGRectMake(leftSize.width+cSize.width, 0, rSize.width, rSize.height)];
            [rnickButton setTitle:[NSString stringWithFormat:@"%@:",comobj.rnickname] forState:UIControlStateNormal];
            [rnickButton setTitleColor:RGB(255, 57, 67) forState:UIControlStateNormal];
            [rnickButton.titleLabel setFont:replyLabel.font];
            [rnickButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            
            [replyLabel addSubview:rnickButton];
            }
        [cnickButton addTarget:self action:@selector(cnickClick:) forControlEvents:UIControlEventTouchUpInside];
        [rnickButton addTarget:self action:@selector(rnickClick:) forControlEvents:UIControlEventTouchUpInside];
        replyLabel.attributedText = str;
      
        // replyLabel.textColor = TEXT_COLOR;
        CGRect replyRect = replyLabel.frame;
        if (i == 0)
        {
            replyRect.origin.y = 10;
        }
        else
        {
            UIView *view = [_viewComment viewWithTag:i + 1000 -1];
            replyRect.origin.y = view.bottom + 10;
        }
        
        CGSize replySize = [text sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(SCREENWIDTH - CELLRIGHT_WIDTH, 400) lineBreakMode:replyLabel.lineBreakMode];
        
        replyRect.size.height = replySize.height;
        replyLabel.frame = replyRect;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, replyLabel.top, SCREENWIDTH, replyRect.size.height)];
        [button addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] andSize:button.size] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor] andSize:button.size] forState:UIControlStateHighlighted];
        [button addSubview:replyLabel];
        DDTapGestureRecognizer *cGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick:)];
        cGes.tag = i;
       // [replyLabel addGestureRecognizer:cGes];
        [_viewComment addSubview:replyLabel];
    }
    commentRect.origin.y = _viewPraise.bottom;
    commentRect.size.height = [_viewComment viewWithTag:(1000 + num -1)].bottom  - [_viewComment viewWithTag:1000].top + 20;
    _viewComment.frame = commentRect;
    [_viewHeader setSize:CGSizeMake(_viewHeader.width, _viewPraise.bottom)];
    //[_listTable setContentSize:CGSizeMake(_viewHeader.width, _viewPraise.bottom)];
    
    if (!IsArrEmpty(self.obj.heads) && !IsArrEmpty(self.obj.comments)) {
        _linComent.hidden = YES;
    }
    [_viewComment removeFromSuperview];
    [self.listTable reloadData];
}

-(void)cnickClick:(NSInteger)index
{
    commentOBj *obj = self.obj.comments[index];
    [self gotoSomeOneWithId:obj.cid name:obj.cnickname];
    
}
-(void)pushSome:(DDTapGestureRecognizer *)ges
{
    
    praiseOBj *obj = self.obj.heads[ges.tag-1000];
    [self gotoSomeOneWithId:obj.puserid name:obj.pnickname];
    
}
-(void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = uid;
    vc.userName = name;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)showReplyWithObj
{
    backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 45)];
    backView.backgroundColor = RGBA(210, 210, 210,0.8);
    [backView addTarget:self action:@selector(replyCancel:) forControlEvents:UIControlEventTouchDown];
    [[AppDelegate currentAppdelegate].window addSubview:backView];
}

-(void)replyCancel:(UIControl *)view
{
    [backView removeFromSuperview];
}
-(void)sizeUIWithObj:(CircleListObj *)obj
{
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4) {
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    CGSize nameSize = [name sizeForFont:self.btnNickname.titleLabel.font constrainedToSize:CGSizeMake(100.0f, 20.0f) lineBreakMode:self.btnNickname.titleLabel.lineBreakMode];
    CGRect userRect = self.btnNickname.frame;
    userRect.size.width = nameSize.width;
    self.btnNickname.frame = userRect;
    
    CGRect companRect = self.lblUserName.frame;
    companRect.origin.x = self.btnNickname.right + kObjectMargin;
    NSString *comp = obj.company;
    if (obj.company.length > 5) {
        NSString *str = [obj.company substringToIndex:5];
        comp = [NSString stringWithFormat:@"%@…",str];
    }
    CGSize companSize = [comp sizeForFont:self.lblUserName.font constrainedToSize:CGSizeMake(84.0f, 15.0f) lineBreakMode:self.lblUserName.lineBreakMode];
    companRect.size.width = companSize.width;
    self.lblUserName.frame = companRect;
    
    CGRect positionRect = self.lblPosition.frame;
    positionRect.origin.x = self.lblUserName.right + kObjectMargin / 2.0f;
    self.lblPosition.frame = positionRect;
 
    
    [self.btnNickname setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:nameSize] forState:UIControlStateHighlighted];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageTap:(DDTapGestureRecognizer *)ges
{
    MWPhotoBrowser *vc = [[MWPhotoBrowser alloc] initWithDelegate:self];
    NSInteger imageIndex=ges.tag-9999;
    [vc setCurrentPhotoIndex:imageIndex];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [ [AppDelegate currentAppdelegate].window.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}
// [ap setCurrentPhotoIndex:ges.tag - 9999];

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.obj.photoArr.count;
}
- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.photoArr[index]]]];
}

- (IBAction)actionComment:(id)sender
{

    
    _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
    _popupView.delegate = self;
    _popupView.fid=@"-1";//评论
    _popupView.tag = 222;
    _popupView.detail=@"";
    _popupView.rid = self.obj.rid;
    [self.navigationController.view addSubview:_popupView];
    //    [popupView release];
    [_popupView showWithAnimated:YES];
   
}

#pragma mark -- sdc
#pragma mark -- 评论
- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];

    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"rid":rid,
                            @"fid":@"-1",
                            @"detail":comment};
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
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}
- (void)commentViewDidComment:(NSString *)comment reply:(NSString *) reply fid:(NSString *) fid rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
//    if ([CommonMethod stringContainsEmoji:comment]) {
//        [Hud showMessageWithText:@"评论内容不能含有表情"];
//        return;
//    }
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    commentOBj *cmntObj= [[commentOBj alloc] init];
    for (commentOBj *cObj in self.obj.comments)
    {
        if ([cObj.cid isEqualToString:fid]) {
            cmntObj = cObj;
            break;
        }
    }
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"rid":rid,
                            @"fid":cmntObj.cid,
                            @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
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

    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
    
}

-(void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
{
 
    commentOBj *cmbObj = obj.comments[index];
    _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:cmbObj.cnickname];
    _popupView.delegate = self;
    _popupView.fid=cmbObj.cid;//评论
    _popupView.tag = 222;
    _popupView.detail=@"";
    _popupView.rid = obj.rid;

    [self.navigationController.view addSubview:_popupView];
    [_popupView showWithAnimated:YES];

}

- (IBAction)actionPraise:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":self.obj.rid};
    
    if (![self.obj.ispraise isEqualToString:@"Y"]) {
        [Hud showLoadingWithMessage:@"正在点赞"];

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
        
    }
    else
    {
        [Hud showLoadingWithMessage:@"正在取消点赞"];

        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"])
            {
                self.obj.ispraise = @"N";
                self.obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.praisenum integerValue] - 1)];
                for (praiseOBj *obj in self.obj.heads) {
                    if ([obj.puserid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]) {
                        [self.obj.heads removeObject:obj];
                        break;
                    }
                }
                [Hud showMessageWithText:@"取消点赞"];
                [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
                [self loadDatasWithObj:self.obj];
                [self.listTable reloadData];
                
                [self.delegate detailPraiseWithRid:self.obj.rid praiseNum:self.obj.praisenum isPraised:@"N"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:self.obj];

            }
               [Hud hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }
}

- (IBAction)actionShare:(id)sender {

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];

    if (!IsArrEmpty(self.obj.photoArr)  ) {
      //  image = [ShareSDK imageWithUrl:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.obj.photoArr[0]]];
    }
    NSString *postContent;
    NSString *shareContent;
    
    NSString *shareTitle ;
    if (IsStrEmpty(self.obj.detail)) {
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    }
    else
    {
        postContent = self.obj.detail;
        shareTitle = self.obj.detail;
        shareContent = self.obj.detail;
    }
    if (self.obj.detail.length > 15)
    {
        postContent = [NSString stringWithFormat:@"%@…",[self.obj.detail substringToIndex:15]];
    }
    if (self.obj.detail.length > 15)
    {
 
        shareTitle = [self.obj.detail substringToIndex:15];
        
        shareContent = [NSString stringWithFormat:@"%@…",[self.obj.detail substringToIndex:15]];
        
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态"
                                                                           icon:[UIImage imageNamed:@"圈子图标"]
                                                                   clickHandler:^{
                                                                       [self circleShareWithObj:self.obj];
                                                                   }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友"
                                                                           icon:[UIImage imageNamed:@"圈内好友图标"]
                                                                   clickHandler:^{
                                                                    
                                                                       [self shareToFriendWithText:self.obj.detail];
                                                                   }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信"
                                                                           icon:[UIImage imageNamed:@"sns_icon_19"]
                                                                   clickHandler:^{
                                                                       [self shareToSMS:content rid:self.obj.rid];
                                                                   }];
    
    
    id<ISSShareActionSheetItem> item0 = [ShareSDK shareActionSheetItemWithTitle:@"新浪微博"
                                                                           icon:[UIImage imageNamed:@"sns_icon_1"]
                                                                   clickHandler:^{
                                                                       [self shareToWeibo:content rid:self.obj.rid];
                                                                   }];
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈"
                                                                           icon:[UIImage imageNamed:@"sns_icon_23"]
                                                                   clickHandler:^{
                                                                       [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:1];
                                                                   }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友"
                                                                           icon:[UIImage imageNamed:@"sns_icon_22"]
                                                                   clickHandler:^{
                                                                       [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:0];
                                                                   }];
    NSArray *shareList = [ShareSDK customShareListWithType:
                          item3,
                          item5,
                          item4,
                          SHARE_TYPE_NUMBER(ShareTypeQQ),                          

                          item1,item2,nil];
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          item3,
//                          item5,
//                          item4,
//                          item0,
//                          item1,item2,nil];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:shareContent
                                                image:image
                                                title:SHARE_TITLE
                                                  url:shareUrl
                                          description:shareContent
                                            mediaType:SHARE_TYPE];
    //创建弹出菜单容器

        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [self otherShareWithObj:self.obj];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                        [Hud showMessageWithText:@"分享失败"];
                                    }
                                }];
}
-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}
-(void)shareToFriendWithText:(NSString *)text
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",self.obj.nickname,text];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = shareText;
    vc.shareRid = self.obj.rid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            // [self refreshData];
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

            [self loadDatasWithObj:obj];
            [self.listTable reloadData];
            [Hud showMessageWithText:@"分享成功"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];

    }];
}
-(void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
            [self loadDatasWithObj:self.obj];
            [Hud showMessageWithText:@"分享成功"];
            [self.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

#pragma mark -收藏
- (IBAction)actionCollection:(id)sender {
    
//    if ([self.obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
//        [Hud showMessageWithText:@"不能收藏自己的帖子"];
//        return;
//    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circlestore"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"rid":self.obj.rid};
    if (![self.obj.iscollection isEqualToString:@"Y"])
    {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.obj.iscollection = @"Y";
            }
            [self loadDatasWithObj:self.obj];
            [Hud showMessageWithText:@"收藏成功"];
            [MobClick event:@"ActionCollection_On" label:@"onClick"];
            if (_delegate && [_delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)])
            {
                  [self.delegate detailCollectionWithRid:self.obj.rid collected:self.obj.iscollection];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
    else
    {
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.obj.iscollection = @"N";
            }
            [self loadDatasWithObj:self.obj];
            if (_delegate && [_delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)])
            {
                [self.delegate detailCollectionWithRid:self.obj.rid collected:self.obj.iscollection];
            }
            [MobClick event:@"ActionCollection_Off" label:@"onClick"];
            [Hud showMessageWithText:@"取消收藏成功"];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
        }];
    }
}
- (IBAction)actionAttention:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"oid":self.obj.userid};
    if ([self.obj.isattention isEqualToString:@"N"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"])
            {
                self.obj.isattention = @"Y";
                [Hud showMessageWithText:@"关注成功"];

            }
            NSString *state = [response.dataDictionary valueForKey:@"state"];
            if ([state isEqualToString:@"2"]) {
                 [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
            }
            [self loadDatasWithObj:self.obj];
            
            [self.delegate detailAttentionWithRid:self.obj.userid attention:self.obj.isattention];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:self.obj];


        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
        }];
    }
    else
    {
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
     
            if ([code isEqualToString:@"000"])
            {
                self.obj.isattention = @"N";
                [Hud showMessageWithText:@"取消关注成功"];
                NSDictionary *data = [[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
                NSString *state = [data valueForKey:@"state"];
                if ([state isEqualToString:@"0"]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                }
            }
            [self loadDatasWithObj:self.obj];

              [self.delegate detailAttentionWithRid:self.obj.userid attention:self.obj.isattention];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:self.obj];


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
        }];
    }
}

-(void)headTap:(DDTapGestureRecognizer *)ges
{
    [self gotoSomeOneWithId:self.obj.userid name:self.obj.nickname];
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
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    [cell loadUIWithObj:obj];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.obj.comments[indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Palatino" size:14.0f];
    
    NSString *text;
    if (IsStrEmpty(obj.rnickname))
    {
      text = [NSString stringWithFormat:@"%@:x%@",obj.cnickname,obj.cdetail];
    }else{
      text = [NSString stringWithFormat:@"%@回复%@:x%@",obj.cnickname,obj.rnickname,obj.cdetail];
    }
    CGSize replySize = [text sizeForFont:font constrainedToSize:CGSizeMake(SCREENWIDTH - CELLRIGHT_WIDTH, 250) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",SCREENWIDTH);
    return replySize.height + 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
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
    }else{
        [self replyClick:indexPath.row];
        NSLog(@"%@",obj.cnickname);
        NSLog(@"%@",self.obj.nickname);
    }
}



- (IBAction)actionGoSome:(id)sender {
    [self gotoSomeOneWithId:self.obj.userid name:self.obj.nickname];
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

-(void)deleteSelf
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":self.obj.rid,
                          @"uid":self.obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [self.delegate detailDeleteWithRid:self.obj.rid];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
    }];
}
- (IBAction)actionDelete:(id)sender {
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
           // [self openURL:[NSURL URLWithString:link]];
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
- (void)longPressGesturecognized:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [longPress locationInView:self.listTable];
    NSIndexPath *indexPath = [self.listTable indexPathForRowAtPoint:location];
    switch (state)
    {
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
- (void)createPickerView{
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
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response)
     {
         [Hud hideHud];
         NSLog(@"%@",response.dataDictionary);
         for (commentOBj *obj in self.obj.comments)
         {
             if ([obj.rid  isEqualToString:commentRid])
             {
                 [self.obj.comments removeObject:obj];
                 self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] - 1)];
                 break;
             }
         }
         [self loadDatasWithObj:self.obj];
         [self.listTable reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
     } failed:^(MOCHTTPResponse *response)
     {
         [Hud showMessageWithText:response.errorMessage];
         NSLog(@"response.errorMessage==%@",response.errorMessage);
     }];
    //listTable适应屏幕
    self.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
    
}

@end
