//
//  SettingAboutUsViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingAboutUsViewController.h"

@interface SettingAboutUsViewController ()

@property (nonatomic, strong) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SettingAboutUsViewController

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
    [MobClick event:@"SettingAboutUsViewController" label:@"onClick"];
	self.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.lblVersion.textAlignment = NSTextAlignmentCenter;
    self.lblVersion.textColor = [UIColor colorWithHexString:@"8c8c8c"];
    self.lblVersion.font = FontFactor(14.0f);
    
    self.companyLabel.font = FontFactor(12.0f);
    self.companyLabel.textAlignment = NSTextAlignmentCenter;
    self.companyLabel.textColor = [UIColor colorWithHexString:@"bcbcbc"];
    
    self.timeLabel.font = FontFactor(12.0f);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor colorWithHexString:@"bcbcbc"];
    
    UIImage *image = [UIImage imageNamed:@"settings_aboutus_logo"];
    CGSize size = image.size;
    self.image.sd_layout
    .topSpaceToView(self.view, MarginFactor(144.0f))
    .centerXIs(SCREENWIDTH / 2.0f)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.lblVersion.sd_layout
    .topSpaceToView(self.image, MarginFactor(15.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .autoHeightRatio(0.0f);
    
    self.timeLabel.sd_layout
    .bottomSpaceToView(self.view, MarginFactor(18.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .autoHeightRatio(0.0f);

    self.companyLabel.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.timeLabel, MarginFactor(7.0f))
    .autoHeightRatio(0.0f);


    self.lblVersion.text = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    [self.lblVersion sizeToFit];
    self.companyLabel.text = @"江苏生活谷信息科技有限责任公司";
    [self.companyLabel sizeToFit];
    self.timeLabel.text = @"Copyright 2015-2017";
    [self.timeLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
