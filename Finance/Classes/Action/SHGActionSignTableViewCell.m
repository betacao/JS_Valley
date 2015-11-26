//
//  SGHActionSignTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignTableViewCell.h"
#import "CPTextViewPlaceholder.h"

@interface SHGActionSignTableViewCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *action_signHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *action_signNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *action_signCommpanyLable;
@property (weak, nonatomic) IBOutlet UIButton *action_signRightButton;
@property (weak, nonatomic) IBOutlet UIImageView *action_bottomXuXian;

@property (weak, nonatomic) IBOutlet UIButton *action_signLeftButton;
@property (weak, nonatomic) IBOutlet UIView *action_bottomView;

@property (strong, nonatomic) SHGActionAttendObject *object;
@property (strong, nonatomic) CPTextViewPlaceholder *textView;
@end

@implementation SHGActionSignTableViewCell

- (void)awakeFromNib {
    self.action_signNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.action_signCommpanyLable.textColor = [UIColor colorWithHexString:@"C1C1C1"];
    [self.action_signLeftButton setBackgroundColor:[UIColor colorWithHexString:@"FFA2BC"]];
    [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.action_signLeftButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    self.action_signLeftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.action_signRightButton setBackgroundColor:[UIColor colorWithHexString:@"95DAFB"]];
    [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
    [self.action_signRightButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
     self.action_signRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.action_bottomXuXian.hidden = YES;
    self.action_signHeadImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHeaderImageView:)];
    [self.action_signHeadImage addGestureRecognizer:recognizer];
}


- (CPTextViewPlaceholder *)textView
{
    if (!_textView) {
        _textView = [[CPTextViewPlaceholder alloc] initWithFrame:CGRectMake(kLineViewLeftMargin, 0.0f, kAlertWidth - 2 * kLineViewLeftMargin, 85.0f)];
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.font = [UIFont systemFontOfSize:13.0f];
        _textView.placeholder = @"请输入驳回理由～";
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.action_bottomView.frame;
    frame.size.height = 0.5f;
    frame.size.width = SCREENWIDTH - CGRectGetMinX(frame);
    self.action_bottomView.frame = frame;
}

- (void)loadLastCellLineImage
{
    self.action_bottomXuXian.hidden = NO;
    self.action_bottomView.hidden = YES;
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.action_bottomXuXian.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];

}

- (void)loadCellWithObject:(SHGActionAttendObject *)object publisher:(NSString *)publisher
{
    [self clearCell];
    self.object = object;
    self.action_signNameLabel.text = object.realname;
    self.action_signCommpanyLable.text = object.company;
    [self.action_signHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.headimageurl]] placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    if ([uid isEqualToString:publisher]) {
        if ([object.state isEqualToString:@"0"]) {
            //审核中
            self.action_signLeftButton.hidden = NO;
            self.action_signRightButton.hidden = NO;
            [self.action_signLeftButton setTitle:@"同意" forState:UIControlStateNormal];
            [self.action_signRightButton setTitle:@"驳回" forState:UIControlStateNormal];
        } else if ([object.state isEqualToString:@"1"]) {
            //已同意
            self.action_signRightButton.hidden = NO;
            [self.action_signRightButton setTitle:@"已同意" forState:UIControlStateNormal];
            [self.action_signRightButton setEnabled:NO];
        } else if ([object.state isEqualToString:@"2"]) {
            //已驳回
            self.action_signRightButton.hidden = NO;
            [self.action_signRightButton setTitle:@"已驳回" forState:UIControlStateNormal];
            [self.action_signRightButton setEnabled:NO];
        }
    } else{
        self.action_signLeftButton.hidden = YES;
        self.action_signRightButton.hidden = YES;
    }
}

- (void)clearCell
{
    self.action_signNameLabel.text = @"";
    self.action_signCommpanyLable.text = @"";
    [self.action_signHeadImage setImage:nil];
    self.action_signLeftButton.hidden = YES;
    self.action_signRightButton.hidden = YES;
}

- (IBAction)clickLeftButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetAttend:clickCommitButton:)]) {
        [self.delegate meetAttend:self.object clickCommitButton:button];
    }
}


- (IBAction)clickRightButton:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;
    DXAlertView *alert = [[DXAlertView alloc] initWithCustomView:self.textView leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.rightBlock = ^{
        [weakSelf.textView resignFirstResponder];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(meetAttend:clickRejectButton:reason:)]) {
            [weakSelf.delegate meetAttend:weakSelf.object clickRejectButton:button reason:weakSelf.textView.text];
        }
    };
    [alert show];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)tapUserHeaderImageView:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapUserHeaderImageView:)]) {
        [self.delegate tapUserHeaderImageView:self.object.uid];
    }
}
@end
