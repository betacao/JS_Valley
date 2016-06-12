//
//  CTTextEmojiUtil.m
//  CoreTextDemo01
//
//  Created by LiYeBiao on 16/4/1.
//  Copyright © 2016年 LiYeBiao. All rights reserved.
//

#import "CTTextEmojiUtil.h"

@implementation CTTextEmojiUtil

+ (CTTextEmojiUtil *)shareInstance{
    static CTTextEmojiUtil * simple = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        simple = [[CTTextEmojiUtil alloc] init];
    });
    return simple;
}

- (id)init{
    self = [super init];
    if (self) {
        NSString * emojiPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        self.emojis = [[NSDictionary alloc] initWithContentsOfFile:emojiPath];
    }
    return self;
}

@end
