//
//  UITableView+MJRefresh.m
//  Finance
//
//  Created by changxicao on 16/8/17.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "UITableView+MJRefresh.h"
#import "SHGGifHeader.h"

@implementation UITableView (MJRefresh)

- (void)addRefreshHeaderWithTarget:(NSObject *)target
{
    SHGGifHeader *header = [SHGGifHeader headerWithRefreshingTarget:target refreshingAction:@selector(refreshHeader)];
    header.backgroundColor = [UIColor clearColor];
    self.mj_header = header;
}

- (void)addRefreshFooterWithTarget:(NSObject *)target
{
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:target refreshingAction:@selector(refreshFooter)];
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"606060"];
    footer.stateLabel.font = [UIFont systemFontOfSize:12.0f];
    footer.automaticallyHidden = YES;
    self.mj_footer = footer;
}

@end
