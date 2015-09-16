//
//  ContactView.h
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-11-11.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import "EMRemarkImageView.h"
@class ContactView;

@protocol ChatListContactViewDelegate <NSObject>

- (void)didSelecedView:(ContactView *)view;

@end

@interface ContactView : EMRemarkImageView
{
    UIButton *_deleteButton;
}
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) id<ChatListContactViewDelegate>delegate;
@property (copy) void (^deleteContact)(NSInteger index);

@end
