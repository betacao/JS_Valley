//
//  ProdConfigTableViewCell.h
//  Finance
//
//  Created by HuMin on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProdConfigTableViewCell;

@protocol ProdConfigDelegate<NSObject>
@optional

- (void)didUpdateCell:(ProdConfigTableViewCell *)cell height:(CGFloat)height;

@end

@interface ProdConfigTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (assign, nonatomic) id<ProdConfigDelegate> delegate;

- (void)loadRequest:(NSString *)url;
- (void)loadHtml:(NSString *)url;

@end