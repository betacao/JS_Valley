//
//  MeViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()
- (IBAction)actionInvite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
- (IBAction)actionAuth:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAuth;
@property (weak, nonatomic) IBOutlet UILabel *lblYuan;
@property (weak, nonatomic) IBOutlet UILabel *lblCommission;
- (IBAction)actionEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UITextField *txtNickName;
- (IBAction)actionUserpic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnUserPic;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
   // [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)initUI
{
    self.btnAuth.layer.masksToBounds = YES;
    self.btnInvite.layer.masksToBounds = YES;
    self.btnAuth.layer.cornerRadius = 2;
    self.btnInvite.layer.cornerRadius = 2;
    self.btnAuth.layer.borderWidth = 0.5;
    self.btnInvite.layer.borderWidth = 0.5;
    self.btnInvite.layer.borderColor = [labletextColor CGColor];
    self.btnAuth.layer.borderColor = [labletextColor CGColor];

}
-(void)loadUI
{
    CGSize size = [self.txtNickName.text sizeWithFont:self.txtNickName.font
                            constrainedToSize:CGSizeMake(200, 25)
                                ];
    CGRect rect = self.btnEdit.frame;
    rect.origin.x = self.txtNickName.frame.origin.x + size.width + 15;
    self.btnEdit.frame = rect;
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

- (IBAction)actionUserpic:(id)sender {
}
- (IBAction)actionEdit:(id)sender {
}
- (IBAction)actionAuth:(id)sender {
}
- (IBAction)actionInvite:(id)sender {
}
@end
