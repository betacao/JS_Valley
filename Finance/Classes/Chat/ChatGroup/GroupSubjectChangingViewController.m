//
//  GroupSubjectChangingViewController.m
//  ChatDemo-UI2.0
//
//  Created by Neil on 15-2-25.
//  Copyright (c) 2014年 Neil. All rights reserved.
//

#import "GroupSubjectChangingViewController.h"
#import "UIButton+EnlargeEdge.h"

@interface GroupSubjectChangingViewController () <UITextFieldDelegate>
{
    EMGroup         *_group;
    BOOL            _isOwner;
   
}
@property(nonatomic, strong) UIButton *saveButton;
@property(nonatomic, strong) UITextField *subjectField;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIButton *deleteButton;
@end

@implementation GroupSubjectChangingViewController

- (instancetype)initWithGroup:(EMGroup *)group
{
    self = [self init];
    if (self)
    {
        _group = group;
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        _isOwner = [_group.owner isEqualToString:loginUsername];
        self.view.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");
  
    
    if (_isOwner)
    {
        self.saveButton.hidden = NO;
    } else{
        self.subjectField.enabled = NO;
        self.deleteButton.hidden = YES;
    }
      [self initView];
}

- (void)initView
{
    self.bgView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));
    
    
    UIImage * image = [UIImage imageNamed:@"me_deleteInput"];
    CGSize  size = image.size;
    self.deleteButton.sd_layout
    .rightSpaceToView(self.bgView, MarginFactor(12.0f))
    .centerYEqualToView(self.bgView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.subjectField.sd_layout
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .topSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.deleteButton,12.0f)
    .heightIs(MarginFactor(50.0f));
    
    self.saveButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(15.0f))
    .bottomSpaceToView(self.view, MarginFactor(15.0f))
    .heightIs(MarginFactor(35.0f));
}

- (UITextField *)subjectField
{
    if (!_subjectField) {
        _subjectField = [[UITextField alloc]init];
        _subjectField.placeholder = @"请输入群组名称";
        _subjectField.font = FontFactor(15.0f);
        [_subjectField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];
        _subjectField.text = _group.groupSubject;
        _subjectField.textColor = [UIColor colorWithHexString:@"161616"];
        _subjectField.delegate = self;
        [self.bgView addSubview:_subjectField];
    }
    return _subjectField;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.hidden = YES;
        _saveButton.titleLabel.font = FontFactor(17.0f);
        _saveButton.backgroundColor = [UIColor colorWithHexString:@"f04241"];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [_deleteButton setImage:[UIImage imageNamed:@"me_deleteInput"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setEnlargeEdge:MarginFactor(10.0f)];
        [self.bgView addSubview:_deleteButton];
    }
    return _deleteButton;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)deleteClick:(UIButton *)btn
{
    [self.subjectField resignFirstResponder];
    self.subjectField.text = @"";
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.subjectField resignFirstResponder];
}

#pragma mark - action
- (void)back
{
    if ([_subjectField isFirstResponder])
    {
        [_subjectField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
    [self back];
}

- (void)saveSubject
{
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_subjectField.text forGroup:_group.groupId];
}

@end
