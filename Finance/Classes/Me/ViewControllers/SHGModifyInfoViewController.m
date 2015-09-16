//
//  SHGModifyInfoViewController.m
//  Finance
//
//  Created by changxicao on 15/9/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SHGModifyInfoViewController.h"

const CGFloat bgWidth = 221.0f;
const CGFloat bgHeight = 253.0f;
const CGFloat keyboardMargin = 64.0f;

@interface SHGModifyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@property (weak, nonatomic) IBOutlet UITextField *departTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (assign, nonatomic) CGRect keyboardRect;
@property (weak, nonatomic) UITextField *currentField;

@end

@implementation SHGModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.frame = CGRectMake(0.0f, 0.0f, bgWidth * XFACTOR, bgHeight * YFACTOR);
    self.bgView.center = self.view.center;
    
    self.cancelButton.layer.masksToBounds = YES;
    self.okButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 5.0f;
    self.okButton.layer.cornerRadius = 5.0f;
    
    CGRect frame = self.nameTextField.frame;
    frame.origin.y *= YFACTOR;
    self.nameTextField.frame = frame;
    
    frame = self.departTextField.frame;
    frame.origin.y *= YFACTOR;
    self.departTextField.frame = frame;
    
    frame = self.companyTextField.frame;
    frame.origin.y *= YFACTOR;
    self.companyTextField.frame = frame;
    
    frame = self.cancelButton.frame;
    frame.origin.y *= YFACTOR;
    self.cancelButton.frame = frame;
    
    frame = self.okButton.frame;
    frame.origin.y *= YFACTOR;
    self.okButton.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadInitInfo:(NSDictionary *)dictionary
{
    NSString *name = [dictionary objectForKey:kNickName];
    NSString *department = [dictionary objectForKey:kDepartment];
    NSString *company = [dictionary objectForKey:kCompany];
    if(name && name.length){
        self.nameTextField.text = name;
    }
    if(department && department.length){
        self.departTextField.text = department;
    }
    if(company && company.length){
        self.companyTextField.text = company;
    }
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self.view removeFromSuperview];
}

- (IBAction)okButtonClick:(UIButton *)sender {
    NSString *name = @"";
    NSString *department = @"";
    NSString *company = @"";
    if(self.nameTextField.text.length == 0){
        [Hud showMessageWithText:@"名字不能为空"];
        return;
    } else if(self.nameTextField.text.length > 12){
        [Hud showMessageWithText:@"名字过长,最大长度为12个字"];
        return;
    } else{
        name = self.nameTextField.text;
    }
    if(self.departTextField.text.length == 0){
        [Hud showMessageWithText:@"部门不能为空"];
        return;
    } else{
        department = self.departTextField.text;
    }
    if(self.companyTextField.text.length == 0){
        [Hud showMessageWithText:@"公司不能为空"];
        return;
    } else{
        company = self.companyTextField.text;
    }
    
    NSDictionary *dictionary = @{kNickName:name, kDepartment:department,kCompany:company};
    if(self.delegate && [self.delegate respondsToSelector:@selector(didModifyUserInfo:)]){
        [self.delegate didModifyUserInfo:dictionary];
    }
    [self.view removeFromSuperview];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardRect = rect;
    [self scrollFieldToVisible];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self scrollFieldToVisible];
}

- (void)scrollFieldToVisible
{
    if(!self.currentField ||CGRectGetHeight(self.keyboardRect) == 0){
        return;
    }
    CGRect frame = self.currentField.frame;
    frame = [self.bgView convertRect:frame toView:self.view];
    if(CGRectGetMaxY(frame) + keyboardMargin > CGRectGetMinY(self.keyboardRect)){
        [UIView animateWithDuration:0.25f animations:^{
            CGRect Vframe = self.view.frame;
            Vframe.origin.y = -CGRectGetMaxY(frame) + CGRectGetMinY(self.keyboardRect) - keyboardMargin;
            self.view.frame = Vframe;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
