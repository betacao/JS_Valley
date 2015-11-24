//
//  SHGActionSendViewController.m
//  Finance
//
//  Created by changxicao on 15/11/16.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSendViewController.h"
#import "SHGDatePickerView.h"
#import "SHGActionManager.h"

#define kTextViewOriginalHeight 80.0f
#define kTextViewTopBlank 100.0f * XFACTOR

typedef NS_ENUM(NSInteger, SHGActionSendType){
    SHGActionSendTypeNew = 0,
    SHGActionSendTypeReSet = 1
};

@interface SHGActionSendViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SHGDatePickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *actionTitleField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (weak, nonatomic) IBOutlet UITextField *invateNumber;
@property (weak, nonatomic) IBOutlet UITextView *introduceView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIView *nextBgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *introduceCell;
@property (strong, nonatomic) id currentContext;
@property (strong, nonatomic) SHGDatePickerView *pikerView;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (assign, nonatomic) SHGActionSendType sendType;
@property (strong, nonatomic) NSString *meetId;
@end

@implementation SHGActionSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起活动";
    [self.tableView setTableHeaderView:self.bgView];
    [self.tableView setTableFooterView:self.nextBgView];
    [self initView];
    self.sendType = SHGActionSendTypeNew;
    if (self.object) {
        [self editObject:self.object];
        self.sendType = SHGActionSendTypeReSet;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (SHGDatePickerView *)pikerView
{
    if (!_pikerView) {
        _pikerView = [SHGDatePickerView instanceDatePickerView];
        _pikerView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT + 20.0f);
        [_pikerView setBackgroundColor:[UIColor clearColor]];
        _pikerView.delegate = self;
        [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    }
    return _pikerView;
}

- (void)initView
{
    self.actionTitleField.layer.masksToBounds = YES;
    self.actionTitleField.layer.cornerRadius = 3.0f;
    self.startTimeField.layer.masksToBounds = YES;
    self.startTimeField.layer.cornerRadius = 3.0f;
    self.endTimeField.layer.masksToBounds = YES;
    self.endTimeField.layer.cornerRadius = 3.0f;
    self.positionField.layer.masksToBounds = YES;
    self.positionField.layer.cornerRadius = 3.0f;
    self.invateNumber.layer.masksToBounds = YES;
    self.invateNumber.layer.cornerRadius = 3.0f;
    self.introduceView.layer.masksToBounds = YES;
    self.introduceView.layer.cornerRadius = 3.0f;
}

- (void)editObject:(SHGActionObject *)object
{
    self.actionTitleField.text = object.theme;
    self.startTimeField.text = [@"  " stringByAppendingString:object.startTime];
    self.endTimeField.text = [@"  " stringByAppendingString:object.endTime];
    self.positionField.text = object.meetArea;
    self.invateNumber.text = object.meetNum;
    self.introduceView.text = object.detail;
    self.meetId = object.meetId;
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
        [self.currentContext resignFirstResponder];
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
        point.y -= kTextViewTopBlank;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.currentContext isEqual: self.introduceView]) {
        CGSize size = [self.introduceView sizeThatFits:CGSizeMake(CGRectGetWidth(self.introduceView.frame), MAXFLOAT)];
        CGRect frame = self.introduceView.frame;
        frame.size.height = size.height;
        if (!CGRectEqualToRect(self.introduceView.frame, frame) && CGRectGetHeight(frame) > kTextViewOriginalHeight) {
            self.introduceView.frame = frame;
            [self.tableView reloadData];
        } else{
            [self.currentContext resignFirstResponder];
        }
    } else{
        [self.currentContext resignFirstResponder];
    }
}

- (void)selectDate:(UITextField *)textField
{
    if ([textField isEqual:self.startTimeField]) {
        self.pikerView.type = DateTypeOfStart;
    } else{
        self.pikerView.type = DateTypeOfEnd;
    }
    [self.view addSubview:self.pikerView];
}

- (IBAction)nextButtonClick:(id)sender
{
    if ([self checkInputMessage]){
        __weak typeof(self) weakSelf = self;
        switch (self.sendType) {
            case SHGActionSendTypeNew:{
                //新建活动
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                NSDictionary *param = @{@"uid":uid, @"theme":self.actionTitleField.text, @"startTime":[self.startTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], @"endTime":[self.endTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], @"meetArea":self.positionField.text, @"meetNum":self.invateNumber.text, @"detail":self.introduceView.text};
                [[SHGActionManager shareActionManager] createNewAction:param finishBlock:^(BOOL finish) {
                    if (finish) {
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCreateNewAction)]) {
                            [weakSelf.delegate didCreateNewAction];
                        }
                        [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                    }
                }];
            }
                break;
                
            default:{
                //修改活动
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                NSDictionary *param = @{@"uid":uid, @"theme":self.actionTitleField.text, @"startTime":[self.startTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], @"endTime":[self.endTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], @"meetArea":self.positionField.text, @"meetNum":self.invateNumber.text, @"detail":self.introduceView.text, @"meetId":self.meetId};
                [[SHGActionManager shareActionManager] modifyAction:param finishBlock:^(BOOL finish) {
                    if (finish) {
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCreateNewAction)]) {
                            [weakSelf.delegate didCreateNewAction];
                        }
                        [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                    }
                }];

            }
                break;
        }

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

#pragma mark ------选择时间
- (void)getSelectDate:(NSString *)date type:(DateType)type
{
    switch (type) {
        case DateTypeOfStart:{
            if (self.endTimeField.text.length > 0) {
                NSString *text = [self.endTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([date compare:text options:NSNumericSearch] != NSOrderedAscending) {
                    [Hud showMessageWithText:@"开始时间应小于结束时间"];
                    return;
                }
            }
            self.startTimeField.text = [NSString stringWithFormat:@"  %@", date];
        }
            break;

        case DateTypeOfEnd:{
            if (self.startTimeField.text.length > 0) {
                NSString *text = [self.startTimeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([date compare:text options:NSNumericSearch] != NSOrderedDescending) {
                    [Hud showMessageWithText:@"结束时间应大于开始时间"];
                    return;
                }
            }
            self.endTimeField.text = [NSString stringWithFormat:@"  %@", date];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
