//
//  SettingsSuggestionsViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/5/6.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SettingsSuggestionsViewController.h"
#import "CPTextViewPlaceholder.h"

@interface SettingsSuggestionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet CPTextViewPlaceholder *textView;

- (IBAction)sugguestButtonClicked:(id)sender;
@end

@implementation SettingsSuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"意见反馈";
    [self initView];
    self.textView.delegate = self;
	self.textView.placeholder = @"请输入反馈，我们将为您不断改进。";
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.sureButton.titleLabel.font = FontFactor(15.0f);
    [self.sureButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = FontFactor(17.0f);
    [self.sureButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
    self.textView.font = FontFactor(15.0f);
    self.textView.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.bgView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(175.0f));
    
    self.textView.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(10.0f))
    .bottomSpaceToView(self.bgView, MarginFactor(19.0f))
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .rightSpaceToView(self.bgView, MarginFactor(19.0f));
    
    self.sureButton.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(35.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(40.0f));
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingsSuggestionsViewController" label:@"onClick"];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return  NO;
    }
    return YES;
}

- (IBAction)sugguestButtonClicked:(id)sender
{
	if (IsStrEmpty(self.textView.text)) {
        [Hud showMessageWithText:@"请输入反馈意见！"];
        return;
    }
    
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"feedback"] parameters:@{@"ctype":@"iPhone", @"os":@"iOS", @"osv":[UIDevice currentDevice].systemVersion, @"uid":UID, @"method":@"", @"detail":self.textView.text, @"phoneType":[SHGGloble sharedGloble].platform, @"appv":LOCAL_Version } success:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
