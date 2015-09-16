//
//  MOWHttpManager.m
//  CommonFramework
//
//  Created by 吴仕海 on 4/3/15.
//  Copyright (c) 2015 408939786@qq.com. All rights reserved.
//

#import "MOWHttpManager.h"

#define METHOD   @"METHOD"    //全部小写
#define REQTIME  @"REQTIME"   //yyMMddHHmmssSSS
#define SIGN     @"SIGN"
#define VERSION  @"VERSION"     //1.0.0
#define CTYPE    @"CTYPE"   //请求类型
#define TOKEN    @"TOKEN"
#define PHONE    @"PHONE"
#define RECDATA  @"RECDATA"

#define CTYPEVALUE  @"mobile"    //请求类型

@implementation MOWHttpManager

#pragma mark - 
+ (void)postWithURL:(NSString *)url method:(NSString *)method parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [super postWithURL:url parameters:[MOWHttpManager packageParameters:method dictionary:parameters] success:success failed:failed];
}
+ (void)postWithURL:(NSString *)url method:(NSString *)method class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [super postWithURL:url class:aclass parameters:[MOWHttpManager packageParameters:method dictionary:parameters] success:success failed:failed];
}

#pragma mark -
+ (NSString *)getToken{
    return @"asdf";
}

+ (NSDictionary *)packageParameters:(NSString *)method dictionary:(NSDictionary *)body{
    
    if (IsStrEmpty(method) ) {
        abort();
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:method forKey:METHOD];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmssSSS"];
    
    NSString *nowStr = [dateFormatter stringFromDate:now];
    
    [parameters setValue:nowStr forKey:REQTIME];
    [parameters setValue:[[NSString stringWithFormat:@"%@%@",[MOWHttpManager getToken],nowStr] md5] forKey:SIGN];
    [parameters setValue:[CommonMethod getVersion] forKey:VERSION];
    [parameters setValue:METHOD forKey:method];
  //  [parameters setValue:[MOWHttpManager getToken] forKey:TOKEN];
    
    NSString *phone = @"5";
    
    [parameters setValue:phone forKey:PHONE];
    
    if(body==nil)
    {
        [parameters setValue:@"{}" forKey:RECDATA];
    }else
    {
        [parameters setValue:[body JSONString]forKey:RECDATA];
    }
    
//    DDLogDebug(@"%@",parameters);
    
    return parameters;
}


#pragma mark -
//override
- (BOOL)validateTokenIsLegal:(id)responseObject{
    return YES;
}

@end
