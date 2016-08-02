/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MessageReadManager.h"
#import "SDPhotoBrowser.h"
#import "EMCDDeviceManager.h"

static MessageReadManager *detailInstance = nil;

@interface MessageReadManager()<SDPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *keyWindow;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) BaseNavigationController *photoNavigationController;

@property (strong, nonatomic) UIAlertView *textAlertView;

@end

@implementation MessageReadManager

+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

#pragma mark - getter

- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (BaseNavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[BaseNavigationController alloc] init];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return _photoNavigationController;
}


#pragma mark - public

- (void)showBrowserWithImages:(NSArray *)imageArray
{
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:imageArray];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    browser.imageCount = imageArray.count;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];

}

- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion
{
    BOOL isPrepare = NO;
    
    if(messageModel.type == eMessageBodyType_Voice)
    {
        MessageModel *prevAudioModel = self.audioMessageModel;
        MessageModel *currentAudioModel = messageModel;
        self.audioMessageModel = messageModel;
        
        BOOL isPlaying = messageModel.isPlaying;
        if (isPlaying) {
            messageModel.isPlaying = NO;
            self.audioMessageModel = nil;
            currentAudioModel = nil;
            [[EMCDDeviceManager sharedInstance] stopPlaying];
        }
        else {
            messageModel.isPlaying = YES;
            prevAudioModel.isPlaying = NO;
            isPrepare = YES;
            
            if (!messageModel.isPlayed) {
                messageModel.isPlayed = YES;
                EMMessage *chatMessage = messageModel.message;
                if (chatMessage.ext) {
                    NSMutableDictionary *dict = [chatMessage.ext mutableCopy];
                    if (![[dict objectForKey:@"isPlayed"] boolValue]) {
                        [dict setObject:@YES forKey:@"isPlayed"];
                        chatMessage.ext = dict;
                        [chatMessage updateMessageExtToDB];
                    }
                }
            }
        }
        
        if (updateCompletion) {
            updateCompletion(prevAudioModel, currentAudioModel);
        }
    }
    
    return isPrepare;
}

- (MessageModel *)stopMessageAudioModel
{
    MessageModel *model = nil;
    if (self.audioMessageModel.type == eMessageBodyType_Voice) {
        if (self.audioMessageModel.isPlaying) {
            model = self.audioMessageModel;
        }
        self.audioMessageModel.isPlaying = NO;
        self.audioMessageModel = nil;
    }
    
    return model;
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return nil;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSURL *urlStr = self.photos[index];
    return urlStr;
}

- (void)photoBrowser:(SDPhotoBrowser *)browser didSlideAtIndex:(NSInteger)index
{

}
@end
