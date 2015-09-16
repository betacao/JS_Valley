//
//  RecommendPicObj.h
//  DingDCommunity
//
//  Created by JianjiYuan on 14-3-21.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RECOMMENDPICOBJTYPERECORD,//录音
    RECOMMENDPICOBJTYPEPIC//图片
} RECOMMENDTYPEOBJTYPE;

@interface RecommendTypeObj : NSObject

@property (nonatomic, strong)  UIImage *image;
@property (nonatomic, assign)  RECOMMENDTYPEOBJTYPE type;
@property (nonatomic, strong)  NSData *content;
@property (nonatomic, strong)  NSString *pid;
@property (nonatomic, strong)  NSString *name;

@end
