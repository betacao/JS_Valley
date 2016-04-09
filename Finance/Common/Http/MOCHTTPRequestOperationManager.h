//
//  MOCHTTPRequestOperationManager.h
//  
//
//  Created by 吴仕海 on 4/1/15.
//
//

#import <Foundation/Foundation.h>
#import "MOCHTTPResponse.h"

extern NSString * const moc_http_request_operation_manager_response_server_error_message;
extern NSString * const moc_http_request_operation_manager_response_server_error_code;
extern NSString * const moc_http_request_operation_manager_response_network_error_message;
extern NSString * const moc_http_request_operation_manager_response_network_error_code;
extern NSString * const moc_http_request_operation_manager_response_token_error_message;
extern NSString * const moc_http_request_operation_manager_response_token_error_code;
extern NSString * const moc_http_request_operation_manager_response_other_error_message;
extern NSString * const moc_http_request_operation_manager_response_other_error_code;

typedef void(^MOCResponseBlock)(MOCHTTPResponse *response);
typedef void(^Block)();


@interface MOCHTTPRequestOperationManager : NSObject

+ (void)setupRequestOperationManagerBaseURLString:(NSString *)baseURLString;
//必须调一次的初始化函数
+ (void)setupRequestOperationManager:(NSString *)resultKey successCode:(NSString *)successCode dataKey:(NSString *)dataKey messageKey:(NSString *)messageKey;


/*
    对请求参数统一说明
    url除去baseURL后的地址部分
    aclass 需要解析成的对象模型,aclass继承于JSONModel
    parameters传给服务器的参数(除去公用头)
    success 请求成功,并且操作完成调用
    failed  请求失败,或者请求成功操作失败调用
    complete 请求完成后统一调用

 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress)) uploadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)postWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)postWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)postWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;
+ (void)postWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;

+ (void)getWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)getWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)getWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;
+ (void)getWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;

+ (void)putWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)putWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)putWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;
+ (void)putWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;

+ (void)deleteWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)deleteWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed;
+ (void)deleteWithURL:(NSString *)url parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;
+ (void)deleteWithURL:(NSString *)url class:(Class)aclass parameters:(id)parameters success:(MOCResponseBlock)success failed:(MOCResponseBlock)failed complete:(Block)complete;

//需要重载的方法
- (BOOL)validateTokenIsLegal:(id)responseObject;//验证token
- (id)packageParameters:(id)parameters;//封装头部

@end
