//
//  SHGMyComplainDetailViewController.m
//  Finance
//
//  Created by weiqiankun on 16/8/10.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMyComplainDetailViewController.h"
#import "SHGComplianObject.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SDPhotoBrowser.h"

@interface SHGMyComplainDetailViewController ()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *nameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UILabel *reasonDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLaebl;

@property (strong, nonatomic) SHGComplianObject *object;

@property (strong, nonatomic) UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *photobgView;

@end

@implementation SHGMyComplainDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投诉详情";
    self.scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    [self loadData];

}

- (UIView *)photoView
{
    if (!_photoView) {
        _photoView = [[UIView alloc] init];
        [self.photobgView addSubview:_photoView];
    }
    return _photoView;
}

- (void)loadData
{
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"complain/business/getComplainById"] parameters:@{@"uid":UID,@"complainId":weakSelf.complainId} success:^(MOCHTTPResponse *response) {
        NSArray *array = [[SHGGloble sharedGloble] parseServerJsonArrayToJSONModel:@[response.dataDictionary ] class:[SHGComplianObject class]];
        weakSelf.object = [array firstObject];
        [self addSdLyout];
        [self initView];
        
    } failed:^(MOCHTTPResponse *response) {
    }];
}
- (void)addSdLyout
{
    self.nameLabel.sd_layout
    .topSpaceToView(self.scrollView, 0.0f)
    .leftSpaceToView(self.scrollView, MarginFactor(14.0f))
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(37.0f));
    
    self.nameView.sd_layout
    .topSpaceToView(self.nameLabel, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(40.0f));
    
    self.nameDetailLabel.sd_layout
    .leftSpaceToView(self.nameView, MarginFactor(14.0f))
    .rightSpaceToView(self.nameView, MarginFactor(14.0f))
    .centerYEqualToView(self.nameView)
    .heightIs(MarginFactor(40.0f));
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.nameView, 0.0f)
    .leftSpaceToView(self.scrollView, MarginFactor(14.0f))
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(37.0f));
    
    self.timeView.sd_layout
    .topSpaceToView(self.timeLabel, 0.0f)
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .heightIs(MarginFactor(40.0f));
    
    self.timeDetailLabel.sd_layout
    .leftSpaceToView(self.timeView, MarginFactor(14.0f))
    .rightSpaceToView(self.timeView, MarginFactor(14.0f))
    .centerYEqualToView(self.timeView)
    .heightIs(MarginFactor(40.0f));
    
    UIImage *image = [UIImage imageNamed:@"complain_checked"];
    CGSize size = image.size;
    self.reasonLabel.sd_layout
    .topSpaceToView(self.timeView, 0.0f)
    .leftSpaceToView(self.scrollView, MarginFactor(14.0f))
    .rightSpaceToView(self.scrollView,  MarginFactor(14.0f) + size.width)
    .heightIs(MarginFactor(37.0f));

    self.stateImageView.sd_layout
    .rightSpaceToView(self.scrollView, MarginFactor(14.0f))
    .centerYEqualToView(self.reasonLabel)
    .widthIs(size.width)
    .heightIs(size.height);
    
    
    self.reasonView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.reasonLabel, 0.0f);
    
    self.reasonDetailLabel.sd_layout
    .leftSpaceToView(self.reasonView, MarginFactor(14.0f))
    .rightSpaceToView(self.reasonView, MarginFactor(14.0f))
    .topSpaceToView(self.reasonView, MarginFactor(16.0f))
    .autoHeightRatio(0.0);
    
    [self.reasonView setupAutoHeightWithBottomView:self.reasonDetailLabel bottomMargin:MarginFactor(14.0f)];
    
    self.urlLaebl.sd_layout
    .leftSpaceToView(self.scrollView, MarginFactor(14.0f))
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.reasonView, 0.0f)
    .heightIs(MarginFactor(37.0f));
    
    self.photobgView.sd_layout
    .leftSpaceToView(self.scrollView, 0.0f)
    .rightSpaceToView(self.scrollView, 0.0f)
    .topSpaceToView(self.urlLaebl, 0.0f);

    [self.scrollView setupAutoContentSizeWithBottomView:self.photobgView bottomMargin:10.0f];
}

- (void)initView
{
    self.nameDetailLabel.text = self.object.title;
    self.timeDetailLabel.text = self.object.createTime;
    self.reasonDetailLabel.text = self.object.content;
    if (self.object.urlArray.count > 0) {
        self.urlLaebl.hidden = NO;
        self.photobgView.hidden = NO;
        SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        [self.object.urlArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,src];
            [temp addObject:item];
        }];
        photoGroup.photoItemArray = temp;
        photoGroup.style = SDPhotoGroupStyleThumbnail;
        [self.photoView addSubview:photoGroup];
        
        self.photoView.sd_layout
        .leftSpaceToView(self.photobgView, MarginFactor(14.0f))
        .topSpaceToView(self.photobgView,MarginFactor(14.0f))
        .widthIs(CGRectGetWidth(photoGroup.frame))
        .heightIs(CGRectGetHeight(photoGroup.frame));
        
        self.photobgView.sd_resetLayout
        .leftSpaceToView(self.scrollView, 0.0f)
        .rightSpaceToView(self.scrollView, 0.0f)
        .topSpaceToView(self.urlLaebl, MarginFactor(14.0f))
        .heightIs(CGRectGetHeight(photoGroup.frame) + 2 * MarginFactor(14.0f));
        
    } else{
        self.urlLaebl.hidden = YES;
        self.photobgView.hidden = YES;
    }

    if ([self.object.complainAuditstate isEqualToString:@"0"]) {
        self.stateImageView.hidden = YES;
    } else if ([self.object.complainAuditstate isEqualToString:@"1"]){
        self.stateImageView.hidden = NO;
        self.stateImageView.image = [UIImage imageNamed:@"complain_checked"];
    } else if ([self.object.complainAuditstate isEqualToString:@"9"]){
        self.stateImageView.hidden = NO;
        self.stateImageView.image = [UIImage imageNamed:@"complain_reject"];
    }
    self.scrollView.backgroundColor = Color(@"f7f7f7");
    self.nameView.backgroundColor = self.timeView.backgroundColor = self.reasonView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.textColor = self.reasonLabel.textColor = self.timeLabel.textColor = self.urlLaebl.textColor = Color(@"bebebe");
    
    self.nameLabel.font = self.reasonLabel.font = self.timeLabel.font = self.urlLaebl.font = FontFactor(14.0f);
    
    self.nameLabel.textAlignment = self.reasonLabel.textAlignment = self.timeLabel.textAlignment = self.urlLaebl.textAlignment = NSTextAlignmentLeft;
    
    self.nameDetailLabel.textColor = self.reasonDetailLabel.textColor = self.timeDetailLabel.textColor = Color(@"161616");
    
    self.nameDetailLabel.font = self.reasonDetailLabel.font = self.timeDetailLabel.font = FontFactor(15.0f);
    
    self.nameDetailLabel.textAlignment = self.reasonDetailLabel.textAlignment = self.timeDetailLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView setNeedsLayout];
    [self.scrollView layoutIfNeeded];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
