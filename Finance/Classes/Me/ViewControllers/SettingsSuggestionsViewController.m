//
//  SettingsSuggestionsViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/5/6.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SettingsSuggestionsViewController.h"

@interface SettingsSuggestionsViewController ()

@property (nonatomic, strong) IBOutlet CPTextViewPlaceholder *textView;

- (IBAction)sugguestButtonClicked:(id)sender;
@end

@implementation SettingsSuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"意见反馈";
    self.textView.delegate = self;
	self.textView.placeholder = @"请输入反馈，我们将为您不断改进。";
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
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

	[MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"feedback"]
									 parameters:@{@"uid":uid,@"method":@"",@"detail":self.textView.text}
										success:^(MOCHTTPResponse *response) {
											[Hud showMessageWithText:@"提交成功"];
											[self.navigationController popViewControllerAnimated:YES];
										}failed:^(MOCHTTPResponse *response) {
											
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
