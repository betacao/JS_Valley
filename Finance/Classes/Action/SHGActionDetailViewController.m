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

@interface SHGActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate, SHGActionCommentDelegate>
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
@property (strong, nonatomic) NSString *rejectReason;
@property (strong, nonatomic) NSString *copyedString;

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
    self.replyTable.delegate = self;
    self.replyTable.dataSource = self;
    self.replyTable.backgroundColor = [UIColor whiteColor];
    [self.replyTable setTableFooterView:[[UIView alloc] init]];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.middleButton.hidden = YES;
    [self loadActionDetail:self.object];
}

- (SHGActionSignViewController *)signController
{
    if (!_signController) {
        _signController = [[SHGActionSignViewController alloc] init];
    }
    return _signController;
}

- (BRCommentView *)popupView
{
    if (!_popupView) {
        _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"" name:@""];
        _popupView.delegate = self;
    }
    return _popupView;
}

- (void)loadActionDetail:(SHGActionObject *)object
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] loadActionDetail:object finishBlock:^(NSArray *array) {
        weakSelf.signController.object = [array firstObject];
        weakSelf.responseObject = [array firstObject];
        weakSelf.responseObject.commentList = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:weakSelf.responseObject.commentList class:[SHGActionCommentObject class]];
        [weakSelf.replyTable setTableHeaderView:weakSelf.signController.view];
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
    } else if (self.responseObject.meetState == SHGActionStateSuccess){
        //成功了 如果是自己则只能分享
        if ([self.responseObject.publisher isEqualToString:uid]) {
            self.middleButton.hidden = NO;
            self.middleButton.enabled = NO;
            [self.middleButton setTitle:@"分享" forState:UIControlStateNormal];
        } else{
            //其他用户看到的
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self.leftButton setTitle:@"报名" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"分享" forState:UIControlStateNormal];
            for (NSDictionary *dictionary in self.responseObject.attendList){
                if ([[dictionary objectForKey:@"uid"] isEqualToString:uid]) {
                    if ([[dictionary objectForKey:@"state"] isEqualToString:@"0"]) {
                        [self.leftButton setTitle:@"审核中" forState:UIControlStateNormal];
                    } else if ([[dictionary objectForKey:@"state"] isEqualToString:@"1"]) {
                        [self.leftButton setTitle:@"审核通过" forState:UIControlStateNormal];
                    } else if ([[dictionary objectForKey:@"state"] isEqualToString:@"2"]) {
                        [self.leftButton setTitle:@"被驳回(查看原因)" forState:UIControlStateNormal];
                        self.rejectReason = [dictionary objectForKey:@"reason"];
                    }
                    break;
                }
            }
            
        }
    } else if (self.responseObject.meetState == SHGActionStateFailed){
        //被驳回(活动被驳回 不是报名请求)
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        [self.leftButton setTitle:@"被驳回(查看原因)" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"重新编辑" forState:UIControlStateNormal];
    }
}

#pragma mark ------tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseObject.commentList.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    SHGActionCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionCommentTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
    }
    cell.index = indexPath.row;
    SHGActionCommentType type = SHGActionCommentTypeNormal;
    if(indexPath.row == 0){
        type = SHGActionCommentTypeFirst;
    }else if(indexPath.row == self.responseObject.attendList.count - 1){
        type = SHGActionCommentTypeLast;
    }
    SHGActionCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    [cell loadUIWithObj:object commentType:type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHGActionCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    self.copyedString = object.commentDetail;
//    commentRid = obj.rid;
    if ([object.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        //复制删除试图
//        [self createPickerView];
    }else{
//        [self replyClick:indexPath.row];
    }
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
    [[SHGActionManager shareActionManager] addCommentWithObject:self.object content:comment toOther:nil finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.replyTable reloadData];
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [[SHGActionManager shareActionManager] addCommentWithObject:self.object content:comment toOther:fid finishBlock:^(BOOL success) {
        if (success) {
            [weakSelf.replyTable reloadData];
        }
    }];
}

- (IBAction)actionComment:(id)sender {

    self.popupView.type = @"comment";
    self.popupView.fid = @"-1";
    self.popupView.detail = @"";
    [self.navigationController.view addSubview:self.popupView];
    [self.popupView showWithAnimated:YES];
}

-(void)replyClicked:(SHGActionCommentObject *)obj commentIndex:(NSInteger)index
{
    self.popupView.fid = obj.commentUserId;
    self.popupView.detail = @"";
    self.popupView.rid = obj.commentId;
    self.popupView.type = @"repley";
    [self.navigationController.view addSubview:self.popupView];
    [self.popupView showWithAnimated:YES];
}
@end
