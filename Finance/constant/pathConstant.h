//
//  pathConstant.h
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#ifndef Finance_pathConstant_h
#define Finance_pathConstant_h


#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kSplashScreenAdCacheImgLocalPath ([kPathDocument stringByAppendingPathComponent:@"SplashScreenAdCacheImg.ad"])

#define kSplashScreenAdCacheLocalPath ([kPathDocument stringByAppendingPathComponent:@"SplashScreenAdCache.ad"])
#define kBPEmailLocalPath ([kPathDocument stringByAppendingPathComponent:@"kBPEmailLocalPath"])

#endif
