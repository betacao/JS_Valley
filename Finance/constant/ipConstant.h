//
//  ipConstant.h
//  Finance
//
//  Created by HuMin on 15/4/9.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#ifndef Finance_ipConstant_h
#define Finance_ipConstant_h


/**
 *  各环境接口定义
 */
#define kSitTest
#define kReleaseH
//#define kDevelopT
//192.168.1.90:8080   本地
//120.26.114.154:8080  测试
//120.26.114.181:8080  生产

#ifdef kSitTest
#define rBaseAddRessHttp                @"http://120.26.114.154:8080/api"
//#define rBaseAddRessHttp                @"http://192.168.0.127:8080/api"
//#define rBaseAddRessHttp                @"http://192.168.1.116:8080/api"
//#define rBaseAddRessHttp                @"http://192.168.0.112:8080/api"

#define rBaseAddressForHttp				[NSString stringWithFormat:@"%@/v1",rBaseAddRessHttp]
#define rBaseAddressForHttpCircle		[NSString stringWithFormat:@"%@/v1/group",rBaseAddRessHttp]
#define rBaseAddressForHttpProd         [NSString stringWithFormat:@"%@/v1/prod",rBaseAddRessHttp]
#define rBaseAddressForHttpUser         [NSString stringWithFormat:@"%@/v1/user",rBaseAddRessHttp]
#define rBaseAddressForHttpUBpush		[NSString stringWithFormat:@"%@/v1/device/baidupush",rBaseAddRessHttp]
#define rBaseAddressForHttpShare		[NSString stringWithFormat:@"%@/v1/share/postDetail?rid=",rBaseAddRessHttp]
#define rBaseAddressForHttpProductShare [NSString stringWithFormat:@"%@/productDetail/productDetail.html?pid=",rBaseAddRessHttp]
#define SHARE_YAOQING_URL               [NSString stringWithFormat:@"%@/Invitation/invite.html",rBaseAddRessHttp]
#define rBaseAddressForHttpProduct      [NSString stringWithFormat:@"%@/v1/discover",rBaseAddRessHttp]
#define rBaseAddressForImage            @"http://daniuquan-test.oss-cn-qingdao.aliyuncs.com/"
#define kNetworkCheckAddress            @"http://www.baidu.com"
#define KEY_HUANXIN                     @"daniuquan123#daniuquan"
#define kUMENGAppKey                    @"558e0e1367e58ea419006a14"

#define kAppId      @"YJVwxGvDAm9xzBUj6ECms"
#define kAppKey     @"rn8Nk0eHBGAQ1rf4IFSVi2"
#define kAppSecret  @"ryyfVg7IiI6LIaUVGYVzr3"

#else
#define rBaseAddRessHttp                 @"http://120.26.114.181:8080/api"
#define rBaseAddressForHttp				[NSString stringWithFormat:@"%@/v1",rBaseAddRessHttp]
#define rBaseAddressForHttpCircle		[NSString stringWithFormat:@"%@/v1/group",rBaseAddRessHttp]
#define rBaseAddressForHttpProd         [NSString stringWithFormat:@"%@/v1/prod",rBaseAddRessHttp]
#define rBaseAddressForHttpUser         [NSString stringWithFormat:@"%@/v1/user",rBaseAddRessHttp]
#define rBaseAddressForHttpUBpush		[NSString stringWithFormat:@"%@/v1/device/baidupush",rBaseAddRessHttp]

//微信分享单独拿出来
#define rBaseAddressForHttpShare		@"http://www.daniuq.com/api/v1/share/postDetail?rid="

#define rBaseAddressForHttpProductShare [NSString stringWithFormat:@"%@/productDetail/productDetail.html?pid=",rBaseAddRessHttp]
#define SHARE_YAOQING_URL               [NSString stringWithFormat:@"%@/Invitation/invite.html",rBaseAddRessHttp]
#define rBaseAddressForHttpProduct      [NSString stringWithFormat:@"%@/v1/discover",rBaseAddRessHttp]
#define rBaseAddressForImage            @"http://daniuquan.oss-cn-qingdao.aliyuncs.com/"
#define kNetworkCheckAddress            @"http://www.baidu.com"
#define KEY_HUANXIN                     @"daniuquan123#daniuquanproduction"
#define kUMENGAppKey                    @"558e0e1367e58ea419006a14"

//#define kAppId      @"YJVwxGvDAm9xzBUj6ECms"
//#define kAppKey     @"rn8Nk0eHBGAQ1rf4IFSVi2"
//#define kAppSecret  @"ryyfVg7IiI6LIaUVGYVzr3"
#define kAppId      @"KaNF1q1jSd68efMI4z5Nk4"
#define kAppKey     @"MCzODNoIuQALHdoWnney96"
#define kAppSecret  @"HbQaMqPHbj7i7Y3NddS9V7"

#endif

#define actionlogin             @"login"
#define actioncircle            @"circle"
#define circleBak               @"circleBak"
#define circleNew               @"circleNew"
#define circleListNew           @"circleListNew"

#endif
