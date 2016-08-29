//
//  MOCHTTPRequestOperationManager.m
//  
//
//  Created by 吴仕海 on 4/1/15.
//
//

#import "MOCHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import <Mantle/Mantle.h>
#import "MOCNetworkReachabilityManager.h"
#import "SHGEncryptionAlgorithm.h"

NSString * const moc_http_request_operation_manager_response_server_error_message = @"网络不给力，请稍后再试或者\n检查网络设置";
NSString * const moc_http_request_operation_manager_response_server_error_code = @"-9989";
NSString * const moc_http_request_operation_manager_response_network_error_message = @"网络不给力，请稍后再试或者\n检查网络设置";
NSString * const moc_http_request_operation_manager_response_network_error_code = @"-9998";
NSString * const moc_http_request_operation_manager_response_token_error_message = @"token错误";
NSString * const moc_http_request_operation_manager_response_token_error_code = @"-9899";
NSString * const moc_http_request_operation_manager_response_other_error_message = @"系统级错误";
NSString * const moc_http_request_operation_manager_response_other_error_code = @"-8999";

NSString *moc_http_request_operation_manager_base_url_string;//base URL

//http返回的结果key
static NSString *moc_http_request_operation_manager_base_request_success_code;//请求成功码
static NSString *moc_http_request_operation_manager_base_request_result_key;//请求结果code的key
static NSString *moc_http_request_operation_manager_base_request_data_key;//数据部分
static NSString *moc_http_request_operation_manager_base_request_message_key;//错误信息部分

NSString *moc_http_request_operation_manager_token;

@interface MOCHTTPRequestOperationManager ()
@property (nonatomic, strong) MOCHTTPResponse *response;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation MOCHTTPRequestOperationManager

+ (void)setupRequestOperationManagerBaseURLString:(NSString *)baseURLString{
    moc_http_request_operation_manager_base_url_string = baseURLString;
}
+ (void)setupRequestOperationManager:(NSString *)resultKey
                         successCode:(NSString *)successCode
                             dataKey:(NSString *)dataKey 
                          messageKey:(NSString *)messageKey{
    NSAssert(!IsStrEmpty(resultKey), @"结果key不能为空");
    NSAssert(!IsStrEmpty(successCode), @"成功码不能为空");
    NSAssert(!IsStrEmpty(dataKey), @"数据key不能为空");
    NSAssert(!IsStrEmpty(messageKey), @"信息key不能为空");
    moc_http_request_operation_manager_base_request_success_code = successCode;
    moc_http_request_operation_manager_base_request_result_key = resultKey;
    moc_http_request_operation_manager_base_request_data_key = dataKey;
    moc_http_request_operation_manager_base_request_message_key = messageKey;
}

#pragma mark -

+ (void)postWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parameters success:success failed:failed complete:nil];
}

+ (void)postWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [MOCHTTPRequestOperationManager postWithURL:url class:aclass parameters:parameters success:success failed:failed complete:nil];
}

+ (void)postWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete{
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parameters success:success failed:failed complete:complete];
}

+ (void)postWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete{
    [MOCHTTPRequestOperationManager requestWithURL:url method:@"post" class:aclass parameters:parameters success:success failed:failed complete:complete];
}

#pragma mark -
+ (void)getWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [MOCHTTPRequestOperationManager getWithURL:url class:nil parameters:parameters success:success failed:failed complete:nil];
}

+ (void)getWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed{
    [MOCHTTPRequestOperationManager getWithURL:url class:aclass parameters:parameters success:success failed:failed complete:nil];
}

+ (void)getWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete{
    [MOCHTTPRequestOperationManager getWithURL:url class:nil parameters:parameters success:success failed:failed complete:complete];
}

+ (void)getWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete{
    [MOCHTTPRequestOperationManager requestWithURL:url method:@"get" class:aclass parameters:parameters success:success failed:failed complete:complete];
}

+ (void)putWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed
{
    [self putWithURL:url class:nil parameters:parameters success:success failed:failed complete:nil];
}

+ (void)putWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete
{
    [self putWithURL:url class:nil parameters:parameters success:success failed:failed complete:complete];
}

+ (void)putWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed
{
    [self putWithURL:url class:aclass parameters:parameters success:success failed:failed complete:nil];
}

+ (void)putWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete
{
    [MOCHTTPRequestOperationManager requestWithURL:url method:@"put" class:aclass parameters:parameters success:success failed:failed complete:complete];
}



+ (void)deleteWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed
{
    [self deleteWithURL:url class:nil parameters:parameters success:success failed:failed complete:nil];
}

+ (void)deleteWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete
{
    [self putWithURL:url class:nil parameters:parameters success:success failed:failed complete:complete];
}

+ (void)deleteWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed
{
    [self deleteWithURL:url class:aclass parameters:parameters success:success failed:false complete:nil];
}

+ (void)deleteWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete
{
    [MOCHTTPRequestOperationManager requestWithURL:url method:@"delete" class:aclass parameters:parameters success:success failed:failed complete:complete];
}


#pragma mark -
+ (NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSAssert(URLString, @"请求地址不能为空");
    MOCHTTPRequestOperationManager *client = [MOCHTTPRequestOperationManager manager];
    if (![MOCNetworkReachabilityManager isReachable]) {//网络不可达
        // [Hud showMessageWithText:@"断网了~"];
        [client parseResponseFailed:nil failed:nil logInfo:@"网络不可达"];
        return nil;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setObject:[SHGGloble sharedGloble].currentVersion forKey:@"version"];
    [param setObject:@([[NSDate date] timeIntervalSince1970] * 1000) forKey:@"authTimestamp"];
    NSString *secret = [client sortParameter:param];

    if ([URLString hasPrefix:rBaseAddRessHttp]) {
        NSString *code = signCode;
        for (NSInteger i = 0; i < 3; i++) {
            code = [SHGEncryptionAlgorithm textFromBase64String:code];
        }
        secret = [secret stringByAppendingString:code];
        for (NSInteger i = 0; i < 3; i++) {
            secret = [secret md5];
        }
    } else {
        NSString *code = signCodeForCompany;
        for (NSInteger i = 0; i < 3; i++) {
            code = [SHGEncryptionAlgorithm textFromBase64String:code];
        }
        secret = [secret stringByAppendingString:code];
        for (NSInteger i = 0; i < 4; i++) {
            secret = [secret md5];
        }
    }
    [param setObject:secret forKey:@"sign"];
    parameters = [client packageParameters:param];
    return [client.manager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

+ (void)requestWithURL:(NSString *)url method:(NSString *)method class:(Class)class parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete {

    NSAssert(url, @"请求地址不能为空");
    MOCHTTPRequestOperationManager *client = [MOCHTTPRequestOperationManager manager];

    if (![MOCNetworkReachabilityManager isReachable]) {//网络不可达
        // [Hud showMessageWithText:@"断网了~"];
        [client parseResponseFailed:nil failed:failed logInfo:@"网络不可达"];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setObject:[SHGGloble sharedGloble].currentVersion forKey:@"version"];
    [param setObject:@([[NSDate date] timeIntervalSince1970] * 1000) forKey:@"authTimestamp"];
    NSString *secret = [client sortParameter:param];

    if ([url hasPrefix:rBaseAddRessHttp]) {
        NSString *code = signCode;
        for (NSInteger i = 0; i < 3; i++) {
            code = [SHGEncryptionAlgorithm textFromBase64String:code];
        }
        secret = [secret stringByAppendingString:code];
        for (NSInteger i = 0; i < 3; i++) {
            secret = [secret md5];
        }
    } else {
        NSString *code = signCodeForCompany;
        for (NSInteger i = 0; i < 3; i++) {
            code = [SHGEncryptionAlgorithm textFromBase64String:code];
        }
        secret = [secret stringByAppendingString:code];
        for (NSInteger i = 0; i < 4; i++) {
            secret = [secret md5];
        }
    }
    [param setObject:secret forKey:@"sign"];
    parameters = [client packageParameters:param];

    if([method isEqualToString:@"post"]){
        [client.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [client parseResponseSuccess:responseObject class:class success:success failed:failed logInfo:url];
            complete?complete():nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [client parseResponseFailed:error failed:failed logInfo:error.domain];
            complete?complete():nil;
        }];
    } else if([method isEqualToString:@"get"]){
        [client.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [client parseResponseSuccess:responseObject class:class success:success failed:failed logInfo:url];
            complete?complete():nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [client parseResponseFailed:error failed:failed logInfo:error.domain];
            complete?complete():nil;
        }];
    } else if([method isEqualToString:@"put"]){
        [client.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [client parseResponseSuccess:responseObject class:class success:success failed:failed logInfo:url];
            complete?complete():nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [client parseResponseFailed:error failed:failed logInfo:error.domain];
            complete?complete():nil;
        }];
    } else if([method isEqualToString:@"delete"]){
        [client.manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [client parseResponseSuccess:responseObject class:class success:success failed:failed logInfo:url];
            complete?complete():nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [client parseResponseFailed:error failed:failed logInfo:error.domain];
            complete?complete():nil;
        }];
    }
}

#pragma mark -
//data为对应部分的数据
- (void)parseResponseSuccess:(id)responseObject class:(Class)class success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed logInfo:(NSString *)info{
    
    self.response.data = responseObject;
    
    if ([self validateTokenIsLegal:responseObject]){//token合法
        NSString *code = [responseObject valueForKey:moc_http_request_operation_manager_base_request_result_key];\
        if ([code isEqualToString:moc_http_request_operation_manager_base_request_success_code]) {//返回成功
            id data = [responseObject objectForKey:moc_http_request_operation_manager_base_request_data_key];
            
            if ([data isKindOfClass:[NSString class]]) {
                NSString *dataStr = (NSString *)data;
                id parseData = [dataStr parseToArrayOrNSDictionary];//解析前的数据保存
                if ([parseData isKindOfClass:[NSDictionary class]]) {
                    self.response.dataDictionary = parseData;
                }else if ([parseData isKindOfClass:[NSArray class]]) {
                    [self parseServerJsonArrayToJSONModel:parseData class:class];
                }
            }
            success?success(self.response):nil;
        }else{
            [self parseResponseFailed:responseObject failed:failed logInfo:info];
        }
    }else{//token不合法
        self.response.errorCode = moc_http_request_operation_manager_response_token_error_code;
        self.response.errorMessage = moc_http_request_operation_manager_response_token_error_message;
        failed?failed(self.response):nil;
    }
}
//data 可能为NSError 或者NSDictionary
- (void)parseResponseFailed:(id)responseObject
                     failed:(MOCResponseBlock)failed
                    logInfo:(NSString *)info{
    if (![MOCNetworkReachabilityManager isReachable]) {//网络可达
        self.response.errorCode = moc_http_request_operation_manager_response_server_error_code;
        self.response.errorMessage = moc_http_request_operation_manager_response_network_error_message;
        MOCLogDebug(@"网络错误");
    }else{
        if ([responseObject isKindOfClass:[NSError class]]) {//failed block里面的error
            NSLog(@"本地请求报错:%@:%@",info,responseObject);
            
            self.response.errorCode = moc_http_request_operation_manager_response_server_error_code;
            self.response.errorMessage = moc_http_request_operation_manager_response_server_error_message;
            
            self.response.error = responseObject;
        }else{//服务器请求成功,但是操作失败,这个需要由外部定义成功码
            if ([responseObject isKindOfClass:[NSDictionary class]]) {//如果错误中全为英文,那么则可以认为是系统级的错误,统一处理为服务器错误
            
                self.response.errorCode = [responseObject valueForKey:moc_http_request_operation_manager_base_request_result_key];
                if ([self.response.errorCode isEqualToString:@"99999"]) {
                    self.response.errorMessage = moc_http_request_operation_manager_response_server_error_message;
                }
                else
                {
                        self.response.errorMessage = [responseObject valueForKey:moc_http_request_operation_manager_base_request_message_key] ;
                }
            }else{
                  self.response.errorMessage = [responseObject valueForKey:moc_http_request_operation_manager_base_request_message_key] ;
                self.response.errorCode = moc_http_request_operation_manager_response_other_error_code;
                
                MOCLogDebug(@"服务器返回非字典的数据类型,暂时无法解析");
            }
            self.response.data = responseObject;
        }
    }
    failed?failed(self.response):nil;
}

//解析服务器的数据到对应的response里面去
- (void)parseServerJsonArrayToJSONModel:(NSArray *)array class:(Class)class{
    if ([class isSubclassOfClass:[MTLModel class]]) {
        NSMutableArray *saveArray = [[NSMutableArray alloc] init];
        for(id obj in array){
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSError *error;
                id model = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:obj error:&error];
                if (error) {
                    MOCLogDebug(error.domain);
                }else{
                    [saveArray addObject:model];
                }
            }else{
                MOCLogDebug(@"服务器返回的数据应该为字典形式");
            }
        }
        self.response.dataArray = [saveArray copy];
    }else{
        MOCLogDebug(@"class没有继承于JSONModel,只做单纯的返回数据,不处理");
        self.response.dataArray = array;
    }
}
#pragma mark -
+ (MOCHTTPRequestOperationManager *)manager{
    
    NSAssert(moc_http_request_operation_manager_base_request_result_key != nil, @"请有且仅调一次setupRequestOperationManager:successCode:dataKey:messageKey:方法进行网络请求的配置");
    MOCHTTPRequestOperationManager *client = [[MOCHTTPRequestOperationManager alloc] init];

    if (IsStrEmpty(moc_http_request_operation_manager_base_url_string)){
        client.manager= [AFHTTPSessionManager manager];
        client.response = [[MOCHTTPResponse alloc] init];
        [client clientSetup];
        return client;
    }else{
        NSURL *baseURL = [[NSURL alloc] initWithString:moc_http_request_operation_manager_base_url_string];
        if (baseURL) {
            client.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        }else{
            client.manager = [AFHTTPSessionManager manager];
        }
        client.response = [[MOCHTTPResponse alloc] init];
        [client clientSetup];
        return client;
    }
}

- (void)clientSetup{
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 30;
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
}

- (NSString *)sortParameter:(id)param
{
    NSArray *keys = [param allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for(id key in sortedArray) {
        id object = [param objectForKey:key];
        object = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)[NSString stringWithFormat:@"%@",object],NULL,CFSTR(":/=？：?#[]@!$ '()*+,;\"<>%&{}|\\^~`"),kCFStringEncodingUTF8));
        [sortedValues addObject:object];
    }

    __block NSString *result = @"";
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key, [sortedValues objectAtIndex:idx]]];
    }];
    if (!IsStrEmpty(result)) {
        result = [result substringToIndex:result.length - 1];

    }
    return result;
}

#pragma mark -
//具体工程中建议重载的部分
- (BOOL)validateTokenIsLegal:(id)responseObject{
    return YES;
}
- (id)packageParameters:(id)parameters{
    return parameters;
}

@end
