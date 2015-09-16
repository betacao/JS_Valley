//
//  CirclleItemObj.h
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CirclleItemObj : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *tname;

@property (nonatomic, strong) NSString *tcode;


@property (nonatomic, strong) NSString *timg;

@end
