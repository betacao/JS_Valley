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

    [SHGAdvertisementManager loadRemoteAdvertisement];
}

- (void)addAutoLayout
{
    self.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);

    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setDissmissBlock:(SHGAdvertisementViewDismissBlock)dissmissBlock
{
    _dissmissBlock = dissmissBlock;
    __weak typeof(self)weakSelf = self;
    [SHGAdvertisementManager loadLocalAdvertisementBlock:^(BOOL show, NSString *photoUrl) {
        if (show && photoUrl) {
            UIImage *image = [UIImage imageWithContentsOfFile:photoUrl];
            weakSelf.imageView.image = image;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (dissmissBlock) {
                    dissmissBlock();
                }
            });
        } else{
            NSString *imageName = [NSString stringWithFormat:@"%ldx%ld",(long)SCREENWIDTH * 2, (long)SCREENHEIGHT * 2];
            self.imageView.image = [UIImage imageNamed:imageName];
            if (dissmissBlock) {
                dissmissBlock();
            }
        }
    }];
}

@end




@interface SHGAdvertisementManager()

@end

@implementation SHGAdvertisementManager

+ (void)loadLocalAdvertisementBlock:(void (^)(BOOL, NSString *))block
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kSplashScreenAdCacheLocalPath]) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:kSplashScreenAdCacheLocalPath]] options:NSJSONReadingAllowFragments error:nil];
        NSString *phototUrl = kSplashScreenAdCacheImgLocalPath;
        block([[dictionary objectForKey:@"flag"] isEqualToString:@"1"], phototUrl);
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
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            [data writeToFile:kSplashScreenAdCacheImgLocalPath atomically:YES];
        }];
        if (dictionary) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            [data writeToFile:kSplashScreenAdCacheLocalPath atomically:YES];
        } else{
            NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:kSplashScreenAdCacheLocalPath atomically:YES];
        }
    } failed:nil];
}




@end