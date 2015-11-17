//
//  SHGActionSendViewController.m
//  Finance
//
//  Created by changxicao on 15/11/16.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSendViewController.h"

#define kTextViewOriginalHeight 80.0f
#define kTextFieldMaxMargin 77.0f

@interface SHGActionSendViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *actionTitleField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (weak, nonatomic) IBOutlet UITextField *invateNumber;
@property (weak, nonatomic) IBOutlet UITextView *introduceView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) IBOutlet UIView *nextBgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *introduceCell;
@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;

@end

@implementation SHGActionSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起活动";
    [self.tableView setTableHeaderView:self.bgView];
    [self.tableView setTableFooterView:self.nextBgView];
    [self initView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initView
{
    self.actionTitleField.layer.masksToBounds = YES;
    self.actionTitleField.layer.cornerRadius = 5.0f;
    self.startTimeField.layer.masksToBounds = YES;
    self.startTimeField.layer.cornerRadius = 5.0f;
    self.endTimeField.layer.masksToBounds = YES;
    self.endTimeField.layer.cornerRadius = 5.0f;
    self.positionField.layer.masksToBounds = YES;
    self.positionField.layer.cornerRadius = 5.0f;
    self.invateNumber.layer.masksToBounds = YES;
    self.invateNumber.layer.cornerRadius = 5.0f;
    self.introduceView.layer.masksToBounds = YES;
    self.introduceView.layer.cornerRadius = 5.0f;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentContext = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.startTimeField] || [textField isEqual:self.endTimeField]) {
        [self selectDate:textField];
        return NO;
    }
    return YES;
}

- (void)keyBoardDidShow:(NSNotification *)notificaiton
{
    NSDictionary *info = [notificaiton userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint keyboardOrigin = [value CGRectValue].origin;
    self.keyBoardOrginY = keyboardOrigin.y;
    UIView *view = (UIView *)self.currentContext;
    CGPoint point = CGPointMake(0.0f, CGRectGetMinY(view.frame));
    if ([self.currentContext isEqual:self.introduceView]) {
        if (CGRectGetHeight(self.introduceView.frame) > kTextViewOriginalHeight) {
            point = CGPointMake(0.0f, CGRectGetMaxY(view.frame));
        }
        point = [self.introduceCell convertPoint:point toView:self.tableView];
        point.y -= kTextFieldMaxMargin;
    }
    [self.tableView setContentOffset:point animated:YES];
}

- (void)keyBoardDidHide:(NSNotification *)notificaiton
{

}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currentContext = textView;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    if (!CGRectEqualToRect(textView.frame, frame) && CGRectGetHeight(frame) > kTextViewOriginalHeight) {
        textView.frame = frame;
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.01f];
    }
    return YES;

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentContext resignFirstResponder];
}

- (void)selectDate:(UITextField *)textField
{
    CGRect frame = self.pickerBgView.frame;
    frame.origin.y = SCREENHEIGHT - CGRectGetHeight(frame);
    self.pickerBgView.frame = frame;
    [self.view.window addSubview:self.pickerBgView];
}

- (IBAction)nextButtonClick:(id)sender
{
    if ([self checkInputMessage]){
        __weak typeof(self) weakSelf = self;
        NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/v1/meetingactivity/saveMeetingActivity"];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
        NSDictionary *param = @{@"uid":uid, @"theme":self.actionTitleField.text, @"startTime":self.startTimeField.text, @"endTime":self.endTimeField.text, @"meetArea":self.positionField.text, @"meetNum":self.invateNumber.text, @"detail":self.introduceView.text};
        [MOCHTTPRequestOperationManager postWithURL:request parameters:param success:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:@"活动发布成功"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:@"活动发布失败"];
        }];
    }
}

- (BOOL)checkInputMessage
{
    if (self.actionTitleField.text == 0) {
        [Hud showMessageWithText:@"请输入活动标题"];
        return NO;
    }
    if (self.startTimeField.text == 0) {
        [Hud showMessageWithText:@"请输入活动开始时间"];
        return NO;
    }
    if (self.endTimeField.text == 0) {
        [Hud showMessageWithText:@"请输入活动结束时间"];
        return NO;
    }
    if (self.positionField.text == 0) {
        [Hud showMessageWithText:@"请输入活动地点"];
        return NO;
    }
    if (self.invateNumber.text == 0) {
        [Hud showMessageWithText:@"请输入活动邀请人数"];
        return NO;
    }
    if (self.introduceView.text == 0) {
        [Hud showMessageWithText:@"请输入活动简介"];
        return NO;
    }
    return YES;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.introduceView.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.introduceCell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
