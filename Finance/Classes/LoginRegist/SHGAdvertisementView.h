//
//  SHGAdvertisementView.h
//  Finance
//
//  Created by changxicao on 16/6/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHGAdvertisementViewDismissBlock)(void);

@interface SHGAdvertisementView : UIView

@property (copy, nonatomic) SHGAdvertisementViewDismissBlock dissmissBlock;

@end

@interface SHGAdvertisementManager : NSObject

+ (void)loadLocalAdvertisementBlock:(void (^)(BOOL show, NSString *photoUrl))block;

+ (void)loadRemoteAdvertisement;

@end