//
//  SHGActionDetailViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionDetailViewController.h"
#import "ReplyTableViewCell.h"
#import "SHGActionSignTableViewCell.h"
#import "MLEmojiLabel.h"
#import "CircleListDelegate.h"
#import "SHGActionSignViewController.h"

@interface SHGActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate, CircleListDelegate>
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIView *bottomButtonView;
@property (weak, nonatomic) IBOutlet UIButton *smileImage;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIButton *baomingButton;
@property (weak, nonatomic) IBOutlet UIButton *my_baomingButton;
@property (weak, nonatomic) IBOutlet UIButton *my_shareButton;
@property (strong, nonatomic) BRCommentView *popupView;
@property (strong, nonatomic) SHGActionObject *responseObject;
@property (strong, nonatomic) SHGActionSignViewController *signController;

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
    [self loadActionDetail:self.object];
}

- (SHGActionSignViewController *)signController
{
    if (!_signController) {
        _signController = [[SHGActionSignViewController alloc] init];
    }
    return _signController;
}

- (void)loadActionDetail:(SHGActionObject *)object
{
    __weak typeof(self) weakSelf = self;
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityById"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param = @{@"meetId":object.meetId, @"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:request class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSArray *array = [NSArray arrayWithObject:response.dataDictionary];
        array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:array class:[SHGActionObject class]];
        weakSelf.signController.object = [array firstObject];
        weakSelf.responseObject = [array firstObject];
        [weakSelf.replyTable setTableHeaderView:weakSelf.signController.view];
    } failed:^(MOCHTTPResponse *response) {

    }];
}


- (void)loadUI
{
   
}

- (void)loadOriginalColor
{

}

- (void)loadOriginalImage
{


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseObject.commentList.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (IBAction)actionComment:(id)sender {
    _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
    _popupView.delegate = self;
    _popupView.fid = @"-1";//评论
    _popupView.tag = 222;
    _popupView.detail = @"";
    [self.navigationController.view addSubview:_popupView];
    [_popupView showWithAnimated:YES];
}
@end
