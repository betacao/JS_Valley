//
//  SHGActionDetailViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionDetailViewController.h"
#import "SHGActionCommentTableViewCell.h"
#import "SHGActionSignTableViewCell.h"
#import "MLEmojiLabel.h"
#import "SHGActionSignViewController.h"
#import "SHGActionManager.h"
#import "SHGPersonalViewController.h"
#import "SHGActionSendViewController.h"
#import "SHGActionSegmentViewController.h"
#import "CPTextViewPlaceholder.h"

@interface SHGActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate, SHGActionCommentDelegate, BRCommentViewDelegate, CircleActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIView *bottomButtonView;
@property (weak, nonatomic) IBOutlet UIButton *smileImage;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) BRCommentView *popupView;
@property (strong, nonatomic) SHGActionObject *responseObject;
@property (strong, nonatomic) SHGActionSignViewController *signController;
@property (strong, nonatomic) UITableViewCell *firstTableViewCell;
@property (assign, nonatomic) CGFloat firstCellHeight;
@property (strong, nonatomic) NSString *rejectReason;
@property (strong, nonatomic) NSString *copyedString;
@property (strong, nonatomic) CPTextViewPlaceholder *cpTextView;
- (IBAction)actionComment:(id)sender;

@end

@implementation SHGActionDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];
    self.replyTable.delegate = self;
    self.replyTable.dataSource = self;
    self.replyTable.header.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.replyTable setTableFooterView:[[UIView alloc] init]];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.middleButton.hidden = YES;
    self.firstCellHeight = 1.0f;
    [self loadActionDetail:self.object];
}

- (SHGActionSignViewController *)signController
{
    if (!_signController) {
        _signController = [[SHGActionSignViewController alloc] init];
        _signController.delegate = [SHGActionSegmentViewController sharedSegmentController];
        _signController.superController = self;
        __weak typeof(self) weakSelf = self;
        _signController.finishBlock = ^(CGFloat height){
            weakSelf.firstCellHeight = height;
            [weakSelf.replyTable reloadData];
        };
    }
    return _signController;
}

- (UITableViewCell *)firstTableViewCell
{
    if (!_firstTableViewCell) {
        _firstTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_firstTableViewCell.contentView addSubview:self.signController.view];
        _firstTableViewCell.clipsToBounds = YES;
        _firstTableViewCell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _firstTableViewCell;
}

- (CPTextViewPlaceholder *)cpTextView
{
    if (!_cpTextView) {
        _cpTextView = [[CPTextViewPlaceholder alloc] initWithFrame:CGRectMake(kLineViewLeftMargin, 0.0f, kAlertWidth - 2 * kLineViewLeftMargin, 85.0f)];
        _cpTextView.layer.borderWidth = 0.5f;
        _cpTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cpTextView.font = [UIFont systemFontOfSize:13.0f];
        _cpTextView.placeholder = @"对发布者说点什么吧～";
    }
    return _cpTextView;
}

- (void)loadActionDetail:(SHGActionObject *)object
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] loadActionDetail:object finishBlock:^(NSArray *array) {
        weakSelf.responseObject = [array firstObject];
        weakSelf.responseObject.commentList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.commentList class:[SHGActionCommentObject class]]];
        weakSelf.responseObject.praiseList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.praiseList class:[praiseOBj class]]];
        weakSelf.responseObject.attendList = [NSMutableArray arrayWithArray:[[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.attendList class:[SHGActionAttendObject class]]];
        weakSelf.signController.object = weakSelf.responseObject;
        [weakSelf.replyTable reloadData];
        [weakSelf loadUI];
    }];
}


- (void)loadUI
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    //审核中 也只有自己能看到审核中
    if (self.responseObject.meetState == SHGActionStateVerying) {
        self.middleButton.hidden = NO;
        self.middleButton.enabled = NO;
        [self.middleButton setTitle:@"审核中" forState:UIControlStateNormal];
        [self.middleButton setBackgroundColor:[UIColor colorWithHexString:@"FD8D8C"]];
    } else if (self.responseObject.meetState == SHGActionStateSuccess){
        //成功了 如果是自己则只能分享
        if ([self.responseObject.publisher isEqualToString:uid]) {
            self.middleButton.hidden = NO;
            [self.middleButton setTitle:@"分享" forState:UIControlStateNormal];
            [self.middleButton setBackgroundColor:[UIColor colorWithHexString:@"F7514A"]];
        } else{
            //其他用户看到的
            self.middleButton.hidden = YES;
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self.leftButton setTitle:@"报名" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"F7514A"] ];
            [self.rightButton setTitle:@"分享" forState:UIControlStateNormal];
            [self.rightButton setBackgroundColor:[UIColor colorWithHexString:@"474550"]];
            for (SHGActionAttendObject *object in self.responseObject.attendList){
                if ([object.uid isEqualToString:uid]) {
                    if ([object.state isEqualToString:@"0"]) {
                        [self.leftButton setTitle:@"审核中" forState:UIControlStateNormal];
                        [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"FD8D8C"]];
                    } else if ([object.state isEqualToString:@"1"]) {
                        [self.leftButton setTitle:@"审核通过" forState:UIControlStateNormal];
                        [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"FD8D8C"] ];
                    } else if ([object.state isEqualToString:@"2"]) {
                        [self.leftButton setTitle:@"被驳回(查看原因)" forState:UIControlStateNormal];
                        [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"F7514A"]];
                        self.rejectReason = object.reason;
                    }
                    break;
                }
            }
            
        }
    } else if (self.responseObject.meetState == SHGActionStateFailed){
        //被驳回(活动被驳回 不是报名请求)
        self.middleButton.hidden = YES;
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.rejectReason = self.responseObject.reason;
        [self.leftButton setTitle:@"被驳回(查看原因)" forState:UIControlStateNormal];
        [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"474550"]];
        [self.rightButton setTitle:@"重新编辑" forState:UIControlStateNormal];
        [self.rightButton setBackgroundColor:[UIColor colorWithHexString:@"F7514A"]];
    } else{
        self.middleButton.hidden = NO;
        [self.middleButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.middleButton setBackgroundColor:[UIColor colorWithHexString:@"B7B7B7"] ];
    }
}

#pragma mark ------tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            if (!self.responseObject) {
                return 0;
            }
            return 1;
        }
            break;

        default:{
            NSInteger count = self.responseObject.commentList.count;
            return count;
        }
            break;
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            return self.firstTableViewCell;
        }
            break;

        default:{
            NSString *cellIdentifier = @"cellIdentifier";
            SHGActionCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionCommentTableViewCell" owner:self options:nil] lastObject];
                cell.delegate = self;
            }
            cell.index = indexPath.row;
            SHGActionCommentType type = SHGActionCommentTypeNormal;
            NSLog(@"index.row%ld",(long)indexPath.row);
            if(indexPath.row == 0){
                type = SHGActionCommentTypeFirst;
            }else if(indexPath.row == self.responseObject.commentList.count - 1){
                type = SHGActionCommentTypeLast;
            }
            SHGActionCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
            [cell loadUIWithObj:object commentType:type];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            return self.firstCellHeight;
        }
            break;

        default:{
            SHGActionCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
            CGFloat height = [object heightForCell];
            if(indexPath.row == 0){
                height += kCommentTopMargin;
            }
            if (indexPath.row == self.responseObject.commentList.count - 1){
                height += kCommentBottomMargin;
            }
            return height + kCommentMargin;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGActionCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    self.copyedString = object.commentDetail;
    if ([object.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        //复制删除试图
//        [self createPickerView];
    } else{
        [self replyClicked:object commentIndex:indexPath.row];
    }
}

- (IBAction)leftButtonClick:(UIButton *)button
{
    [self buttonClick:button];
}

- (IBAction)middleButtonClick:(UIButton *)button
{
    [self buttonClick:button];
}

- (IBAction)rightButtonClick:(UIButton *)button
{
    [self buttonClick:button];
}

- (void)buttonClick:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    NSString *title = button.titleLabel.text;
    if ([title rangeOfString:@"被驳回"].location != NSNotFound) {
        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"驳回原因" contentText:self.rejectReason leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    } else if([title rangeOfString:@"重新编辑"].location != NSNotFound){
        SHGActionSendViewController *controller =[[SHGActionSendViewController alloc] init];
        controller.object = self.responseObject;
        controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
        [self.navigationController pushViewController:controller animated:YES];
    } else if([title rangeOfString:@"审核中"].location != NSNotFound){

    } else if([title rangeOfString:@"分享"].location != NSNotFound){
        [[SHGActionManager shareActionManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {
            if (success) {
            }
        }];
    } else if([title rangeOfString:@"报名"].location != NSNotFound){
        DXAlertView *alert = [[DXAlertView alloc] initWithCustomView:self.cpTextView leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [weakSelf.cpTextView resignFirstResponder];
            [[SHGActionManager shareActionManager] enterForActionObject:weakSelf.responseObject reason:weakSelf.cpTextView.text finishBlock:^(BOOL success) {
                if (success) {
                    [weakSelf.leftButton setTitle:@"审核中" forState:UIControlStateNormal];
                    [weakSelf.leftButton setEnabled:NO];
                }
            }];
        };
        [alert show];

    }
}

#pragma mark ------分享到圈内好友的通知
- (void)shareToFriendSuccess:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Hud showMessageWithText:@"分享成功"];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 评论代理
- (void)rightUserClick:(NSInteger)index
{
    SHGActionCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentOtherName];
}

- (void)leftUserClick:(NSInteger)index
{
    SHGActionCommentObject *obj = self.responseObject.commentList[index];
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
    [[SHGActionManager shareActionManager] addCommentWithObject:self.responseObject content:comment toOther:nil finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.replyTable reloadData];
            [weakSelf.signController refreshUI];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCommentAction:)]) {
                [weakSelf.delegate didCommentAction:weakSelf.responseObject];
            }
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [[SHGActionManager shareActionManager] addCommentWithObject:self.responseObject content:comment toOther:fid finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.replyTable reloadData];
            [weakSelf.signController refreshUI];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCommentAction:)]) {
                [weakSelf.delegate didCommentAction:weakSelf.responseObject];
            }
        }
    }];
}

- (IBAction)actionComment:(id)sender
{
    self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
    self.popupView.delegate = self;
    self.popupView.type = @"comment";
    self.popupView.fid = @"-1";
    self.popupView.detail = @"";
    [self.navigationController.view addSubview:self.popupView];
    [self.popupView showWithAnimated:YES];
}

- (void)replyClicked:(SHGActionCommentObject *)obj commentIndex:(NSInteger)index
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

- (void)tapUserHeaderImageView:(NSString *)uid
{
    SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init ];
    vc.userId = uid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
