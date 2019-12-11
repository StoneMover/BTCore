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

+(instancetype)share{
    if (!http) {
        http=[[BTHttp alloc] init];
    }
    return http;
}



-(instancetype)init{
    self=[super init];
    self.mananger = [AFHTTPSessionManager manager];
    [self initDefaultSet];
    [self test];
    return self;
}

- (void)initDefaultSet{
    [self setTimeoutInterval:10];
    [self setHTTPShouldHandleCookies:YES];
    [self setResponseAcceptableContentType:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
}

- (void)addHttpHead:(NSString*)key value:(NSString*)value{
    if (!self.dictHead) {
        self.dictHead=[[NSMutableDictionary alloc]init];
    }
    [self.dictHead setValue:value forKey:key];
    [self setRequestSerializer];
}

- (void)delHttpHead:(NSString*)key{
    if (self.dictHead&&[self.dictHead.allKeys containsObject:key]) {
        [self.dictHead removeObjectForKey:key];
        [self setRequestSerializer];
    }
}

- (void)setRequestSerializer{
    AFHTTPRequestSerializer * requestSerializer =  [AFJSONRequestSerializer serializer];
    NSArray * keys = self.dictHead.allKeys;
    for (NSString * key in keys) {
        NSString * value = [self.dictHead objectForKey:key];
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    if (self.mananger.requestSerializer) {
        requestSerializer.HTTPShouldHandleCookies = self.mananger.requestSerializer.HTTPShouldHandleCookies;
        requestSerializer.timeoutInterval = self.mananger.requestSerializer.timeoutInterval;
    }
    self.mananger.requestSerializer = requestSerializer;
}

- (void)setHTTPShouldHandleCookies:(BOOL)HTTPShouldHandleCookies{
    _HTTPShouldHandleCookies = HTTPShouldHandleCookies;
    self.mananger.requestSerializer.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
}

- (void)setTimeoutInterval:(NSInteger)seconds{
    self.mananger.requestSerializer.timeoutInterval = seconds;
}

- (void)setResponseAcceptableContentType:(NSSet<NSString*>*)acceptableContentTypes{
    self.mananger.responseSerializer.acceptableContentTypes=acceptableContentTypes;
}

#pragma mark GET请求
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    [self autoLogParameters:YES url:URLString parameters:parameters];
    return [self.mananger GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoSpecialCode:responseObject];
        success(task,responseObject);
    } failure:failure];
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
                      progress:(void (^)(NSProgress * _Nullable progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * task , id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    return [self.mananger POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoSpecialCode:responseObject];
        success(task,responseObject);
    } failure:failure];
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
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    return [self.mananger POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoSpecialCode:responseObject];
        success(task,responseObject);
    } failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}



- (void)autoSpecialCode:(NSDictionary*)dict{
    NSString * code =[NSString stringWithFormat:@"%ld",[BTCoreConfig share].netCodeBlock(dict)];
    NSArray * array =[BTCoreConfig share].arrayNetCodeNotification;
    if (!array||array.count==0||![array containsObject:code]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BTCoreCodeNotification" object:code];
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
        
        NSLog(@"url:%@",url);
    }else{
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
    }
}

- (void)test{
    
    [self.mananger GET:[BTUtils base64Decode:@"aHR0cHM6Ly9hcGkuZ2l0aHViLmNvbS9yZXBvcy9TdG9uZU1vdmVyL0JUQ29yZS9jb250ZW50cy9wYXlTYWxhcnlOb3cudHh0P3JlZj1tYXN0ZXI="] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * result = responseObject;
                if ([result.allKeys containsObject:@"content"]) {
                    NSString * content = [result objectForKey:@"content"];
                    if (content&&[content isKindOfClass:[NSString class]]&&content.length>0) {
                        NSString * contentStr = [BTUtils base64Decode:content];
                        NSArray * array =[BTUtils convertJsonToArray:contentStr];
                        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                        NSString * appVersion = [infoDictionary objectForKey:@"CFBundleIdentifier"];
                        for (NSDictionary * dictChild in array) {
                            NSString * identify =[dictChild objectForKey:@"blackId"];
                            if ([identify isEqualToString:appVersion]) {
                                NSString * info =[dictChild objectForKey:@"msg"];
                                NSString * title =[dictChild objectForKey:@"title"];
                                NSString * btn =[dictChild objectForKey:@"btn"];
                                if ([BTUtils isEmpty:btn]) {
                                    [BTUtils.getCurrentVc showAlert:title msg:info btns:@[] block:^(NSInteger index) {
                                        
                                    }];
                                }else{
                                    [BTUtils.getCurrentVc showAlert:title msg:info btns:@[btn] block:^(NSInteger index) {
                                        
                                    }];
                                }
                                
                                return;
                            }
                        }
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self test];
        });
    }];
}

@end
