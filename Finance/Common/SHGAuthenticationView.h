//
//  SHGAuthenticationView.h
//  Finance
//
//  Created by changxicao on 16/6/23.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHGAuthenticationView : UIView

@property (assign, nonatomic) BOOL showGray;

@property (nonatomic, copy) dispatch_block_t VBlock;
@property (nonatomic, copy) dispatch_block_t enterpriseBlock;

- (void)updateWithVStatus:(BOOL)vStatus enterpriseStatus:(BOOL)enterpriseStatus;

@end
