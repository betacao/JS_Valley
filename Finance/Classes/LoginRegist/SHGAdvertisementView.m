//
//  SHGAdvertisementView.m
//  Finance
//
//  Created by changxicao on 16/6/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAdvertisementView.h"
#import "SDWebImageManager.h"

@interface SHGAdvertisementView()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SHGAdvertisementView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self addAutoLayout];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] init];
    self.backgroundColor = self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];

    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SHGAdvertisementManager loadRemoteAdvertisement];
        [SHGAdvertisementManager loadLocalAdvertisementBlock:^(BOOL show, NSString *photoUrl) {
            if (show && photoUrl) {
                [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.dissmissBlock) {
                        self.dissmissBlock();
                    }
                });
            } else{
                if (self.dissmissBlock) {
                    self.dissmissBlock();
                }
            }
        }];
    });
}

- (void)addAutoLayout
{
    self.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

@end




@interface SHGAdvertisementManager()

@end

@implementation SHGAdvertisementManager

+ (void)loadLocalAdvertisementBlock:(void (^)(BOOL, NSString *))block
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kSplashScreenAdCacheImgLocalPath]) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:kSplashScreenAdCacheImgLocalPath]] options:NSJSONReadingAllowFragments error:nil];
        NSString *phototUrl = [dictionary objectForKey:@"phototurl"];
        block([[dictionary objectForKey:@"flag"] isEqualToString:@"1"], [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,phototUrl]);
    } else{
        block(NO, nil);
    }
}

+ (void)loadRemoteAdvertisement
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/appImage/getStartAppImage"] parameters:@{@"os":@"ios", @"width":@(SCREENWIDTH * SCALE), @"height":@(SCREENHEIGHT * SCALE)} success:^(MOCHTTPResponse *response) {
        NSDictionary *dictionary = [response.dataDictionary objectForKey:@"appimage"];
        NSString *phototUrl = [dictionary objectForKey:@"phototurl"];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,phototUrl]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        }];
        if (dictionary) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSLog(@"%@", kSplashScreenAdCacheImgLocalPath);
            [data writeToFile:kSplashScreenAdCacheImgLocalPath atomically:YES];
        }
    } failed:nil];
}




@end