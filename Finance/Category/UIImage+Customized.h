//
//  UIImage+Customized.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-12.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Customized)

- (UIImage *)reSizeImagetoSize:(CGSize)reSize;

- (UIImage *)reSizeImagetoFillWidth:(CGSize)imageSize;

+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
@end
