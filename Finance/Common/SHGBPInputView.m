//
//  SHGBPInputView.m
//  Finance
//
//  Created by changxicao on 16/8/19.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBPInputView.h"

@interface SHGBPInputView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation SHGBPInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    self.dataArray = [[SHGGloble BPInputhistory] reverseArray];

    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"请输入邮箱地址～";
    self.textField.font = FontFactor(15.0f);
    self.textField.layer.borderColor = Color(@"efefef").CGColor;
    self.textField.layer.borderWidth = 1 / SCALE;
    self.textField.textColor = Color(@"3a3a3a");
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.text = [self.dataArray firstObject];
    [self.textField setValue:Color(@"d2d1d1") forKeyPath:@"_placeholderLabel.textColor"];

    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MarginFactor(6.0f), 0.0f)];

    UIView *rightView = [[UIView alloc] init];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setEnlargeEdge:MarginFactor(20.0f)];
    [button setImage:[UIImage imageNamed:@"downArrowImage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];

    button.sd_layout
    .centerXEqualToView(rightView)
    .centerYEqualToView(rightView)
    .widthIs(button.currentImage.size.width)
    .heightIs(button.currentImage.size.height);

    rightView.frame = CGRectMake(0.0f, 0.0f, button.currentImage.size.width + 2.0f * MarginFactor(13.0f),MarginFactor(42.0f));
    self.textField.rightView = rightView;

    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightViewMode = UITextFieldViewModeAlways;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self addSubview:self.textField];
    [self addSubview:self.tableView];
}

- (void)addAutoLayout
{
    self.width = MarginFactor(300.0f);

    self.textField.sd_layout
    .topSpaceToView(self, MarginFactor(30.0f))
    .rightSpaceToView(self, MarginFactor(26.0f))
    .leftSpaceToView(self, MarginFactor(26.0f))
    .heightIs(MarginFactor(42.0f));

    self.tableView.sd_layout
    .topSpaceToView(self.textField, 0.0f)
    .rightEqualToView(self.textField)
    .leftEqualToView(self.textField)
    .heightIs(0.0f);

    [self setupAutoHeightWithBottomView:self.tableView bottomMargin:MarginFactor(13.0f)];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSString *)inputText
{
    return [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)didMoveToSuperview
{
    if (self.superview) {
        [self.textField becomeFirstResponder];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:0.25f animations:^{
        UIView *view = self.superview;
        view.sd_layout
        .widthIs(CGRectGetWidth(self.frame))
        .centerYEqualToView([AppDelegate currentAppdelegate].window)
        .offset(-keyboardSize.height / 2.0f)
        .centerXEqualToView([AppDelegate currentAppdelegate].window);
        [view updateLayout];
    }];
}

- (void)buttonClick:(UIButton *)button
{
    CGFloat height = MIN(3, self.dataArray.count) * MarginFactor(27.0f);
    self.tableView.sd_layout
    .topSpaceToView(self.textField, 0.0f)
    .rightEqualToView(self.textField)
    .leftEqualToView(self.textField)
    .heightIs(height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MarginFactor(27.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGBPInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGBPInputTableViewCell"];
    if (!cell) {
        cell = [[SHGBPInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHGBPInputTableViewCell"];
    }
    cell.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.sd_layout
    .topSpaceToView(self.textField, 0.0f)
    .rightEqualToView(self.textField)
    .leftEqualToView(self.textField)
    .heightIs(0.0f);
    self.textField.text = [self.dataArray objectAtIndex:indexPath.row];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@interface SHGBPInputTableViewCell()

@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation SHGBPInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftView = [[UIView alloc] init];
    self.rightView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.leftView.backgroundColor = self.rightView.backgroundColor = self.bottomView.backgroundColor = Color(@"efefef");
    self.label = [[UILabel alloc] init];
    self.label.font = FontFactor(13.0f);
    self.label.textColor = Color(@"8d8d8d");

    [self.contentView sd_addSubviews:@[self.leftView, self.rightView, self.bottomView, self.label]];
}

- (void)addAutoLayout
{
    self.leftView.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .widthIs(1 / SCALE);

    self.rightView.sd_layout
    .topSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .bottomSpaceToView(self.contentView, 0.0f)
    .widthIs(1 / SCALE);

    self.bottomView.sd_layout
    .bottomSpaceToView(self.contentView, 0.0f)
    .rightSpaceToView(self.contentView, 0.0f)
    .leftSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    self.label.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(12.0f), 1 / SCALE, 1 / SCALE));
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

@end