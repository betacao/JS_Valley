//
//  CircleSomeOneViewController.m
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleSomeOneViewController.h"
#import "CircleDetailViewController.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
@interface CircleSomeOneViewController ()<MLEmojiLabelDelegate>
{
    BOOL hasDataFinished;
    NSInteger photoIndex;
    NSArray *photoArr;
    CircleListObj *deleteObj;
}
@property (weak, nonatomic) IBOutlet UILabel *lblFriendList;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (nonatomic, strong)BRCommentView *popupView;

//发消息按钮
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnFriendsNum;
@property (weak, nonatomic) IBOutlet UIButton *btnSendNum;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;  //公司名称

@property (nonatomic, strong) NSString *titles;//职称
@property (nonatomic, strong) NSString *rela;
@property (nonatomic, strong) NSString *potname;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *company;
@property (strong ,nonatomic) NSString *userStatus;
@property (nonatomic, strong) NSString *fans;
- (IBAction)actionFriendList:(id)sender;
- (IBAction)actionChat:(id)sender;

@property (nonatomic, strong) NSString *lblCityName;
@end

@implementation CircleSomeOneViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleSomeOneViewController" label:@"onClick"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人动态";
    self.imageHeader.userInteractionEnabled = YES;
    self.imageHeader.layer.masksToBounds = YES;
    self.imageHeader.layer.cornerRadius = CGRectGetHeight(self.imageHeader.frame) / 2.0f;
    UIImage *image = [self.imageBack.image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.imageBack.image = image;
    
    DDTapGestureRecognizer *headGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitTap:)];
    [self.imageHeader addGestureRecognizer:headGes];
    
    if (SCREENHEIGHT == 480) {
        CGRect rect = self.listTable.frame;
        rect.size.height = self.view.height;
        self.listTable.frame = rect;
    }
    
    //处理tableView左边空白
    if ([self.listTable respondsToSelector:@selector(setSeparatorInset:)]){
        [self.listTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.listTable respondsToSelector:@selector(setLayoutMargins:)]){
        [self.listTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.lblFriendList.userInteractionEnabled = YES;
    DDTapGestureRecognizer *ges = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(gesToFriendList:)];
    [self.lblFriendList addGestureRecognizer:ges];
    self.btnFriendsNum.enabled = NO;
    self.btnSendNum.enabled = NO;
    
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:NO andFooter:YES];
    if ([self.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]])
    {
        self.btnChat.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsShareSuccess:) name:NOTIFI_CHANGE_SHARE_TO_FRIENDSUCCESS object:nil];
   
    [self.listTable setTableHeaderView:self.viewHeader];
    [self requestDataWithTarget:@"first" time:@""];
}
-(void)reloadTable
{
    [self.listTable reloadData];
}
-(void)requestDataWithTarget:(NSString *)target time:(NSString *)time
{
    if ([target isEqualToString:@"first"]) {
        [self.listTable.footer resetNoMoreData];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    [Hud showLoadingWithMessage:@"加载中"];

    NSDictionary *param = @{@"uid":uid, @"target":target, @"rid":[NSNumber numberWithInt:[time intValue]], @"num":rRequestNum};
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,actioncircle,self.userId] class:[CircleListObj class] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"=data = %@",response.dataDictionary);
        [self parseDataWithDic:response.dataDictionary];
        [self.listTable.header endRefreshing];
        [self.listTable.footer endRefreshing];
        [self loadUI];
        [self.listTable reloadData];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
        NSLog(@"%@",response.errorMessage);
        [self.listTable.header endRefreshing];
        [self.listTable.footer endRefreshing];
        
    }];
}
-(void)loadUI
{
    [self.imageHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.potname]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.departmentLabel.text = self.titles;
    self.companyLabel.text = self.company;
    self.nameLabel.text = self.nickname;
    [self.btnSendNum setTitle:self.num forState:UIControlStateNormal];
    [self.btnFriendsNum setTitle:self.fans forState:UIControlStateNormal];
    [self.btnFriendsNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSendNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if ([self.rela intValue] == 0){        //未关注
        [self.btnChat setImage:[UIImage imageNamed:@"加关注按钮"] forState:UIControlStateNormal];
        self.btnChat.enabled = YES;
        
    } else if ([self.rela intValue] == 1){
        //已关注
        [self.btnChat setImage:[UIImage imageNamed:@"不能会话"] forState:UIControlStateNormal];
    } else{
        //互相关注
        [self.btnChat setImage:[UIImage imageNamed:@"会话"] forState:UIControlStateNormal];
        self.btnChat.enabled = YES;

    }
}
-(void)parseDataWithDic:(NSDictionary *)dic
{
    self.company = dic[@"company"];
    self.fans = dic[@"fans"];
    self.nickname = dic[@"nickname"];
    self.num = dic[@"num"];
    self.potname = dic[@"potname"];
    self.rela = dic[@"rela"];
    self.titles = dic[@"title"];
    self.userStatus = [dic objectForKey:@"userstatus"];
    
    NSArray *list = dic[@"list"];
    if (IsArrEmpty(list)) {
        hasDataFinished = YES;
    } else{
        hasDataFinished = NO;
    }
    for (NSDictionary *dics in list) {
        CircleListObj *obj = [[CircleListObj alloc] init];
        obj.company = dics[@"company"];
        obj.currcity = dics[@"currcity"];
        obj.detail = dics[@"detail"];
        obj.isattention = dics[@"isattention"];
        obj.ispraise = dics[@"ispraise"];
        obj.nickname = dics[@"nickname"];
        obj.potname = dics[@"potname"];
        obj.praisenum = dics[@"praisenum"];
        obj.publishdate = dics[@"publishdate"];
        obj.rid = dics[@"rid"];
        obj.sharenum = dics[@"sharenum"];
        obj.cmmtnum = dics[@"cmmtnum"];
        obj.photos = dics[@"attach"];
        obj.photoArr = (NSArray *)obj.photos;
        obj.status = dics[@"status"];
        obj.title = dics[@"title"];
        obj.rid = dics[@"rid"];
        obj.type = dics[@"attachtype"];
        obj.userid = dics[@"userid"];
        obj.sizes = dics[@"sizes"];
        obj.friendship = dics[@"friendship"];
        obj.userstatus = dics[@"userstatus"];
        NSArray *comments = dics[@"comments"];
        for (NSDictionary *ment in comments) {
            commentOBj *cmbobj = [[commentOBj alloc] init];
            cmbobj.cdetail = ment[@"cdetail"];
            cmbobj.cnickname = ment[@"cnickname"];

            cmbobj.rnickname = ment[@"rnickname"];

            cmbobj.cid = ment[@"cid"];

            cmbobj.rid = ment[@"rid"];
            [obj.comments addObject:cmbobj];

        }
        NSDictionary *link = dics[@"link"];
        if ([obj.type isEqualToString:@"link"]) {
            linkOBj *linkObj = [[linkOBj alloc] init];
            linkObj.title = link[@"title"];
            linkObj.desc = link[@"desc"];

            linkObj.desc = link[@"desc"];

            linkObj.thumbnail = link[@"thumbnail"];
            obj.linkObj = linkObj;
        }
        [self.dataArr addObject:obj];
    }

}

-(void)refreshHeader
{
    NSLog(@"refreshHeader");
    if (self.dataArr.count > 0){
        CircleListObj *obj = self.dataArr[0];
        [self requestDataWithTarget:@"refresh" time:obj.rid];
    } else{
        [self requestDataWithTarget:@"first" time:@""];
    }
}

-(void)refreshFooter
{
    if (hasDataFinished){
        [self.listTable.footer noticeNoMoreData];
        return;
    }
    NSLog(@"refreshFooter");
    if (self.dataArr.count > 0){
        CircleListObj *obj = [self.dataArr lastObject];
        [self requestDataWithTarget:@"load" time:obj.rid];
    }
    else
    {
        [self requestDataWithTarget:@"first" time:@""];

    }
    
}

- (void)deleteClicked:(CircleListObj *)obj
{
    //删除
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    deleteObj = obj;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self deleteSele:deleteObj];
    }
}

-(void)deleteSele:(CircleListObj *)obj
{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":obj.rid,
                          @"uid":obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [self detailDeleteWithRid:obj.rid];
            [self.delegate detailDeleteWithRid:obj.rid];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
    }];
}
- (void)praiseClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":obj.rid};

    if (![obj.ispraise isEqualToString:@"Y"]) {
        [Hud showLoadingWithMessage:@"正在点赞"];

        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"Y";
                obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([obj.praisenum integerValue] + 1)];
            }
            [Hud showMessageWithText:@"赞成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];

            [self.listTable reloadData];
            [self.delegate detailPraiseWithRid:obj.rid praiseNum:obj.praisenum isPraised:@"Y"];
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
            [Hud hideHud];
        }];
        
    }
    else
    {
        [Hud showLoadingWithMessage:@"正在取消点赞"];

        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                obj.ispraise = @"N";
                obj.praisenum = [NSString stringWithFormat:@"%ld",[obj.praisenum integerValue] -1];

            }
            [Hud showMessageWithText:@"取消点赞"];

            [self.listTable reloadData];
               [self.delegate detailPraiseWithRid:obj.rid praiseNum:obj.praisenum isPraised:@"N"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];

            [Hud hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }
    
}

-(void)headTap:(NSInteger)index{
    
    CircleListObj *obj = self.dataArr[index];
    [self gotoSomeOne:obj.userid name:obj.nickname];
    
}

- (void)clicked:(NSInteger )index{
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    CircleListObj *obj = self.dataArr[index];
    vc.hidesBottomBarWhenPushed = YES;
    vc.rid = obj.rid;
    
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = self.dataArr[indexPath.row];
    
    if ([obj.status boolValue]) {
        static NSString *cellIdentifier = @"circleListIdentifier";
        CircleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleListTableViewCell" owner:self options:nil] lastObject];
        }
        cell.index = indexPath.row;
        cell.delegate = self;
        [cell loadDatasWithObj:obj];
        
        MLEmojiLabel *mlLable = (MLEmojiLabel *)[cell viewWithTag:521];
        mlLable.delegate = self;
        return cell;
    } else{
        static NSString *cellIdentifier = @"noListIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"原帖已删除";
        cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:16];
        
        return cell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj =self.dataArr[indexPath.row];
    if ([obj.status boolValue]){
        NSInteger height = [obj fetchCellHeight];
        return height;
    } else{
        return 0.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListObj *obj = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
    vc.rid = obj.rid;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
}
//处理tableView左边空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark cellDelegate
- (void)pullClicked:(CircleListObj *)obj
{
    [self.listTable reloadData];
}


- (void)commentClicked:(CircleListObj *)obj
{
    _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES];
    _popupView.delegate = self;
    _popupView.fid=@"-1";//评论
    _popupView.tag = 222;
    _popupView.detail=@"";
    _popupView.rid = obj.rid;
    [self.navigationController.view addSubview:_popupView];
    //    [popupView release];
    [_popupView showWithAnimated:YES];
    //[self.listTable reloadData];
}

- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    CircleListObj *rObj = [[CircleListObj alloc] init];
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            rObj = obj;
            break;
        }
    }
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"rid":rid,
                            @"fid":@"-1",
                            @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [rObj.comments addObject:obj];
            rObj.cmmtnum = [NSString stringWithFormat:@"%ld",[rObj.cmmtnum integerValue] +1];
        }
        [self.listTable reloadData];
        [self.delegate detailCommentWithRid:rObj.rid commentNum:rObj.cmmtnum comments:rObj.comments];

    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
    
}
- (void)commentViewDidComment:(NSString *)comment reply:(NSString *) reply fid:(NSString *) fid rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    CircleListObj *rObj = [[CircleListObj alloc] init];
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            rObj = obj;
            break;
        }
    }
    commentOBj *cmntObj= [[commentOBj alloc] init];
    for (commentOBj *cObj in rObj.comments)
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
        if ([code isEqualToString:@"000"]) {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.rnickname = cmntObj.cnickname;
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [rObj.comments addObject:obj];
            rObj.cmmtnum = [NSString stringWithFormat:@"%ld",[rObj.cmmtnum integerValue] +1];
        }
        [self.listTable reloadData];
        [self.delegate detailCommentWithRid:rObj.rid commentNum:rObj.cmmtnum comments:rObj.comments];

    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
    
}

-(void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
        for (CircleListObj *objs in self.dataArr) {
            if ([objs.rid isEqualToString:rid]) {
                [self otherShareWithObj:objs];
            }
        }
    }
}

-(void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
{
    commentOBj *cmbObj = obj.comments[index];
    _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES];
    _popupView.delegate = self;
    _popupView.fid=cmbObj.cid;//评论
    _popupView.tag = 222;
    _popupView.detail=@"";
    _popupView.rid = obj.rid;
    [self.navigationController.view addSubview:_popupView];
    //    [popupView release];
    [_popupView showWithAnimated:YES];
}
-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}
- (void)shareClicked:(CircleListObj *)obj
{
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *postContent;
    NSString *shareContent;
    
    NSString *shareTitle ;
    if (IsStrEmpty(obj.detail)) {
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = obj.detail;
        shareTitle = obj.detail;
        shareContent = obj.detail;
    }
    if (obj.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
        shareTitle = [obj.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@…",[obj.detail substringToIndex:15]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"大牛说" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [self circleShareWithObj:obj];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        [self shareToFriendWithObj:obj];
    }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:1];
    }];
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:obj shareType:0];
    }];
    NSArray *shareList = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1,item2,nil];
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    //创建弹出菜单容器
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareList content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            [self otherShareWithObj:obj];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            [Hud showMessageWithText:@"分享失败"];
        }
    }];
    
}


-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
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
            [self.listTable reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            [Hud showMessageWithText:@"分享成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];

    }];
}
-(void)shareToFriendWithObj:(CircleListObj *)obj
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",obj.nickname,obj.detail];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareRid = obj.rid;
    vc.shareContent = shareText;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.listTable reloadData];
            [Hud showMessageWithText:@"转发成功"];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        
    }];
}
-(void)cnickCLick:(NSString *)userId name:(NSString *)name
{
    if ([userId isEqualToString:self.userId]) {
        return;
    }
    [self gotoSomeOne:userId name:name];
}
-(void)gotoSomeOne:(NSString *)uid name:(NSString *)name
{
    if ([uid isEqualToString:self.userId]) {
        return;
    }
    CircleSomeOneViewController *vc = [[CircleSomeOneViewController alloc] initWithNibName:@"CircleSomeOneViewController" bundle:nil];
    vc.userId = uid;
    vc.userName = name;
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)attentionClicked:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":obj.userid};
    if (![obj.isattention isEqualToString:@"Y"]) {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataArr) {
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"Y";
                    }
                }
                [self.delegate detailAttentionWithRid:obj.userid attention:obj.isattention];
                [Hud showMessageWithText:@"关注成功"];
                NSString *state = [response.dataDictionary valueForKey:@"state"];
                self.rela = state;

                if ([state isEqualToString:@"2"]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                }
                [self loadUI];
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
            [self.listTable reloadData];
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                for (CircleListObj *cobj in self.dataArr){
                    if ([cobj.userid isEqualToString:obj.userid]) {
                        cobj.isattention = @"N";
                    }
                }
                self.rela = [NSString stringWithFormat:@"%d",[self.rela intValue] -1];
                [self.delegate detailAttentionWithRid:obj.userid attention:obj.isattention];
                [self loadUI];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:obj];
                NSDictionary *data = [[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
                NSString *state = [data valueForKey:@"state"];
                if ([state isEqualToString:@"0"]) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KEY_UPDATE_SQL];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_SHOULD_UPDATE object:nil];
                }
                
                [Hud showMessageWithText:@"取消关注成功"];
            }
            [self.listTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
        }];
    }
    [self.listTable reloadData];
    
}
-(void)imageTap:(DDTapGestureRecognizer *)ges
{
    MWPhotoBrowser *vc = [[MWPhotoBrowser alloc] initWithDelegate:self];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [ [AppDelegate currentAppdelegate].window.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}


-(void)action
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"oid":self.userId};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            self.rela = [response.dataDictionary valueForKey:@"state"];
            for (CircleListObj *cobj in self.dataArr)
            {
                if ([cobj.userid isEqualToString:self.userId]) {
                    cobj.isattention = @"Y";
                }
            }
            
            [self.delegate detailAttentionWithRid:self.userId attention:@"Y"];
            CircleListObj *cObj = [[CircleListObj alloc] init];
            cObj.userid = self.userId;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:cObj];

            [self loadUI];
            [self.listTable reloadData];
        
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}
-(void)chat{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:self.userId isGroup:NO];
    chatVC.title = self.userName;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)actionChat:(id)sender {

    if ([self.rela intValue] == 0) {
        [self action];
    }
    else if ([self.rela intValue] == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您与对方还不是好友，对方关注您后可进行对话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self chat];
    }
    
}
-(void)portraitTap:(DDTapGestureRecognizer *)ges
{
    MWPhotoBrowser *vc = [[MWPhotoBrowser alloc] initWithDelegate:self];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    photoArr = @[self.potname];
    photoIndex = 0;
    [ [AppDelegate currentAppdelegate].window.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

-(void)photosTapWIthIndex:(NSInteger)index imageIndex:(NSInteger) imageIndex
{
    CircleListObj *obj =self.dataArr[index];
    photoIndex = index;
    photoArr = obj.photoArr;
    MWPhotoBrowser *vc = [[MWPhotoBrowser alloc] initWithDelegate:self];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [vc setCurrentPhotoIndex:imageIndex];
    [ [AppDelegate currentAppdelegate].window.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
   return photoArr.count;
    
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSString *url = photoArr[index];

    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,url]]];
}


#pragma mark detailDelagte

-(void)detailDeleteWithRid:(NSString *)rid
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            [self.dataArr removeObject:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_DELETE_CLICK object:obj];
            break;
        }
    }
    [self.listTable reloadData];
}
-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.praisenum = num;
            obj.ispraise = isPrased;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:obj];

            break;
        }
        
    }
     [self.delegate detailPraiseWithRid:rid praiseNum:num isPraised:isPrased];

    [self.listTable reloadData];
}

-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.sharenum = num;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];

            break;
        }
    }
    [self.delegate detailShareWithRid:rid shareNum:num];
    [self.listTable reloadData];
    
}
-(void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    CircleListObj *bobj;

    for (CircleListObj *obj in self.dataArr) {
        if ([obj.userid isEqualToString:rid])
        {
            obj.isattention = atten;
            bobj = obj;
        }

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:bobj];

    [self.delegate detailAttentionWithRid:rid attention:atten];
    [self.listTable reloadData];
}
-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    for (CircleListObj *obj in self.dataArr) {
        if ([obj.rid isEqualToString:rid]) {
            obj.cmmtnum = num;
            obj.comments = comments;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:obj];

            break;
        }
        
    }
    [self.delegate detailCommentWithRid:rid commentNum:num comments:comments];
    [self.listTable reloadData];
    
}

-(void)gesToFriendList:(DDTapGestureRecognizer *)ge
{
    [self gotoFriendList];
}
-(void)gotoFriendList
{
    if (![self.userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]) {
        return;
    }
    ChatListViewController *vc = [[ChatListViewController alloc] init];
    vc.chatListType = ContactListView;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionFriendList:(id)sender {
    [self gotoFriendList];
}

@end
