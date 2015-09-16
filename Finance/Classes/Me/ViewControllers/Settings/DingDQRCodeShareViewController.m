//
//  DingDQRCodeShareViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-5-11.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "DingDQRCodeShareViewController.h"
#import <MessageUI/MessageUI.h>

@interface DingDQRCodeShareViewController () < MFMessageComposeViewControllerDelegate >

- (IBAction)showSMSPicker:(id)sender;

@property (nonatomic, strong) IBOutlet UIImageView *qrcodeImageView;
@end

@implementation DingDQRCodeShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title =@"应用二维码";
	self.qrcodeImageView.height = SCREENWIDTH -28;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"应用二维码";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.navigationController navbarLeftItemCustomized:@[btnBack] onwer:self.navigationItem];
	
}

- (IBAction)showSMSPicker:(id)sender
{
    // The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
    // So, we must verify the existence of the above class and log an error message for devices
    //     running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
    //     MFMessageComposeViewController API.
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
//            [UIApplication showToastViewTitle:nil message:@"设备没有短信功能"];
        }
    }
    else {
//        [UIApplication showToastViewTitle:nil message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.messageComposeDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
//            DLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
//            DLog(@"Result: SMS sent");
//            [UIApplication showToastViewTitle:nil message:@"短信发送成功"];
            break;
        case MessageComposeResultFailed:
//            [UIApplication showToastViewTitle:nil message:@"短信发送失败"];
            break;
        default:
//            DLog(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
