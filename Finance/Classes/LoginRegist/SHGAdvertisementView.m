//
//  SHGAdvertisementView.m
//  Finance
//
//  Created by changxicao on 16/6/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGAdvertisementView.h"

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
    WEAK(self, weakSelf);
    [SHGAdvertisementManager loadLocalAdvertisementBlock:^(BOOL show, NSString *photoUrl) {
        NSString *imageName = [NSString stringWithFormat:@"%ldx%ld",(long)(SCREENWIDTH * SCALE), (long)(SCREENHEIGHT * SCALE)];
        UIImage *image = [UIImage imageNamed:imageName];

        if (show && photoUrl) {
            [weakSelf.imageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,photoUrl]] placeholder:image options:kNilOptions manager:[SHGAdvertisementManager adImageManager] progress:nil transform:nil completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (dissmissBlock) {
                    dissmissBlock();
                }
            });
        } else{
            weakSelf.imageView.image = image;
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
        dictionary = [dictionary objectForKey:@"appimage"];
        NSString *phototUrl = [dictionary objectForKey:@"phototurl"];
        block([[dictionary objectForKey:@"flag"] isEqualToString:@"1"], phototUrl);
    } else{
        block(NO, nil);
    }
}

+ (void)loadRemoteAdvertisement
{
    [MOCHTTPRequestOperationManager postWithURL:[rBaseAddressForHttp stringByAppendingString:@"/appImage/getStartAppImage"] parameters:@{@"os":@"ios", @"width":@(SCREENWIDTH * SCALE), @"height":@(SCREENHEIGHT * SCALE)} success:^(MOCHTTPResponse *response) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response.dataDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@", kSplashScreenAdCacheLocalPath);
        [data writeToFile:kSplashScreenAdCacheLocalPath atomically:YES];
    } failed:nil];
}

+ (YYWebImageManager *)adImageManager
{
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = kSplashScreenAdCacheImgLocalPath;
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            return image;
        };
    });
    return manager;
}




@end