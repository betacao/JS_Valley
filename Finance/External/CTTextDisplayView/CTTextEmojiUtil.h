//
//  CTTextEmojiUtil.h
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/4/1.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTTextEmojiUtil : NSObject

@property (nonatomic,strong) NSDictionary * emojis;

+ (CTTextEmojiUtil *)shareInstance;

@end
