//
//  SDPhotoGroup.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SDPhotoGroupStyle)
{
    SDPhotoGroupStyleNormal = 0,
    SDPhotoGroupStyleThumbnail
};

@interface SDPhotoGroup : UIView

@property (assign, nonatomic) SDPhotoGroupStyle style;

@property (nonatomic, strong) NSArray *photoItemArray;

@end
