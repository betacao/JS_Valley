//
//  BRCommentView.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-9.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "BRCommentView.h"
#import "CPTextViewPlaceholder.h"
#import "TWEmojiKeyBoard.h"
@interface BRCommentView () < UITextViewDelegate >
{
    BOOL isEmojiKeyBoard;
    TWEmojiKeyBoard *keyBoard;//自定义键盘
    
    UITextField *textVTemp;
}
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UITextField *textVComment;
@property (nonatomic, strong) UIButton *btnEmoje;
@end

@implementation BRCommentView

- (void)dealloc
{
    _delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *) type
{
    self = [super initWithFrame:frame superFrame:superFrame isController:isController];
    if (self) {
        // Initialization code
         _type=type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
        [self initContentView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superFrame:(CGRect)superFrame isController:(BOOL)isController type:(NSString *)type name:(NSString *)name
{
    self = [super initWithFrame:frame superFrame:superFrame isController:isController type:type name:name];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
        self.type = type;
        self.replyName = name;
        [self initContentView];
    }
    return self;
}

- (void)initContentView
{
    CGRect rect = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 45);
    UIView *viewTemp = [[UIView alloc] initWithFrame:rect];
    viewTemp.backgroundColor = RGBA(239, 239, 239, 1);
    self.viewContainer = viewTemp;
    [self addSubview:viewTemp];

    
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.viewContainer addSubview:_btnCancel];
    btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTemp setFrame:CGRectMake(SCREENWIDTH - 69, 7, 54, 32)];
    [btnTemp setBackgroundColor:RGB(255, 57, 67)];
    [btnTemp.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    //[btnTemp setBackgroundImage:[UIImage imageNamed:@"comment_btn_ok.png"] forState:UIControlStateNormal];
    [btnTemp setTitle:@"发送" forState:UIControlStateNormal];
    [btnTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTemp addTarget:self action:@selector(btnSendClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSend = btnTemp;
    [self.viewContainer addSubview:_btnSend];
    
    UIButton *emage = [UIButton buttonWithType:UIButtonTypeCustom];
    emage.frame = CGRectMake(10, 7, 30, 27);
    //emage.backgroundColor = [UIColor redColor];
    [emage setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
    [emage addTarget:self action:@selector(btnEmoji:) forControlEvents:UIControlEventTouchUpInside];
    self.btnEmoje = emage;
    [self.viewContainer addSubview:emage];
    
    rect.origin.x = 55;
    rect.origin.y = 7;
    rect.size.height = 30;
    rect.size.width = SCREENWIDTH - 55 - 80;
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:rect];
    lblTemp.textAlignment = NSTextAlignmentCenter;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = RGBA(51, 51, 51, 1);
    lblTemp.font = [UIFont systemFontOfSize:16.0f];
    if([_type isEqualToString:@"reply"])
    {
        lblTemp.text = @"写回复";
    }else
    {
        lblTemp.text = @"写评论";
    }
    [self.viewContainer addSubview:lblTemp];

    
    textVTemp = [[UITextField alloc] initWithFrame:rect];
    textVTemp.font = [UIFont systemFontOfSize:16.0f];
    textVTemp.backgroundColor = [UIColor whiteColor];
    textVTemp.borderStyle = UITextBorderStyleRoundedRect;
    textVTemp.textColor = RGB(51, 51, 51);
    textVTemp.textAlignment = NSTextAlignmentLeft;
    self.textVComment = textVTemp;
    [self.viewContainer addSubview:_textVComment];
    
    if([_type isEqualToString:@"reply"])
    {
         self.textVComment.placeholder = [NSString stringWithFormat:@"回复 %@",self.replyName];
    }else
    {
        self.textVComment.placeholder = @"说点什么吧";

    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(self.viewContainer.frame, point)) {
        
        [self hideWithAnimated:YES];
    }
}

- (void)btnCancelClick:(UIButton *)sender
{
    [self hideWithAnimated:YES];
}

- (void)btnSendClick:(UIButton *)sender
{
    NSString *comment = self.textVComment.text;
    comment = [comment stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([comment validLength].length == 0) {
        if([_type isEqualToString:@"reply"])
        {
            [Hud showMessageWithText:@"请输入回复的内容"];
        }else
        {
            [Hud showMessageWithText:@"请输入评论的内容"];
        }
        return;
    }
    
    if (comment.length > 300) {
        if([_type isEqualToString:@"reply"])
        {
            [Hud showMessageWithText:[NSString stringWithFormat:@"回复字数不能大于%d",300]];
        }else
        {
            [Hud showMessageWithText:[NSString stringWithFormat:@"评论字数不能大于%d",300]];
        }
        return;
    }
    if ([_fid isEqualToString:@"-1"])
    {
        [_delegate commentViewDidComment:_textVComment.text rid:self.rid];
    }
    else
    {
        [_delegate commentViewDidComment:_textVComment.text reply:_detail fid:_fid rid:self.rid];
    }
}
- (void)btnEmoji:(UIButton *)sender{
    NSLog(@"11");
    
    NSLog(@"表情包");
    [textVTemp resignFirstResponder];
    
    if (!isEmojiKeyBoard)
    {
        isEmojiKeyBoard=YES;
        if (!keyBoard)
        {
            keyBoard=[[TWEmojiKeyBoard alloc]init];
            [keyBoard createEmojiKeyBoard];
        }
        [keyBoard bindKeyBoardWithTextField:textVTemp];
    }else
    {
        [keyBoard unbindKeyBoard];
        isEmojiKeyBoard=NO;
    }
    
    [textVTemp becomeFirstResponder];
}
- (void)showWithAnimated:(BOOL)animated
{
    [_textVComment becomeFirstResponder];

    if (animated) {
        self.hidden = NO;

        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect = self.viewContainer.frame;
            
            if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0)
            {
                rect.origin.y = CGRectGetHeight(self.bounds)-rect.size.height-184;
            }else
            {
                rect.origin.y = CGRectGetHeight(self.bounds)-rect.size.height-216;
            }
            self.viewContainer.frame = rect;
        } completion:^(BOOL finished){

        }];
        
    }else {
        self.hidden = NO;
    }
}

- (void)hideWithAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.viewContainer.frame = CGRectMake(0, CGRectGetHeight(self.bounds), SCREENWIDTH, 145);
            
        } completion:^(BOOL finished){
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
        
    }else {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

- (void)keyboardWasChange:(NSNotification *)aNotification
{
    
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect rect = self.viewContainer.frame;
    rect.origin.y = CGRectGetHeight(self.bounds)-kbSize.height-rect.size.height;
    self.viewContainer.frame = rect;

}

@end
