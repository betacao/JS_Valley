//
//  ProdConfigTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProdConfigTableViewCell.h"

@interface ProdConfigTableViewCell ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) BOOL hasLoaded;
@property (assign, nonatomic) CGFloat height;

@end

@implementation ProdConfigTableViewCell

- (void)awakeFromNib {
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.height = 0.0f;
    self.hasLoaded = NO;
}

- (void)loadRequest:(NSString *)url
{
    if(!self.hasLoaded){
        self.hasLoaded = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (void)loadHtml:(NSString *)url
{
    if(!self.hasLoaded){
        self.hasLoaded = YES;
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
        [MOCHTTPRequestOperationManager getWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *value = [response.dataDictionary valueForKey:@"value"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadHTMLString:value baseURL:nil];
            });
        } failed:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.errorMessage);

        }];
    }

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud showMessageWithText:@"正在加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    self.height = CGRectGetMaxY(frame);
    [self updateCellHeight];
    [Hud hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Hud hideHud];
}

- (void)updateCellHeight
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateCell:height:)]){
        [self.delegate didUpdateCell:self height:self.height];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
