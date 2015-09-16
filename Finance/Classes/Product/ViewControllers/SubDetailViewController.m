//
//  SubDetailViewController.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SubDetailViewController.h"

@interface SubDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDataWithMethod:self.method];
    NSString *title;
    if (IsStrEmpty(self.method)) {
        title = @"产品信息";
    }else if ([self.method isEqualToString:@"businessintroduction"])
    {
        title = @"业务介绍";
    }else if ([self.method isEqualToString:@"businessprocess"])
    {
        title = @"业务流程";
    }
    self.title = title;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)requestDataWithMethod:(NSString *)method
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpProd,method,self.pid];
    if (IsStrEmpty(method)) {
        url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpProd,self.pid];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return;
    }
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager getWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSLog(@"%@",response.data);
        NSString *value = [response.dataDictionary valueForKey:@"value"];
        [self.webView loadHTMLString:value baseURL:nil];
    } failed:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.errorMessage);

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
