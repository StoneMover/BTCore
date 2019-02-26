//
//  BTHttpRequest.m
//  framework
//
//  Created by whbt_mac on 2016/10/18.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTHttp.h"

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
    self.HTTPShouldHandleCookies=YES;
    return self;
}

- (AFHTTPSessionManager*)mananger{
    if (!_mananger) {
        _mananger=[AFHTTPSessionManager manager];
        [self setHttpHead:_mananger];
    }
    
    return _mananger;
}

-(void)addHttpHead:(NSString*)key value:(NSString*)value{
    if (!self.dictHead) {
        self.dictHead=[[NSMutableDictionary alloc]init];
    }
    [self.dictHead setValue:value forKey:key];
}





#pragma mark GET请求
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    return [self.mananger GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
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
    NSLog(@"url:%@",URLString);
    NSLog(@"parameters:%@",parameters);
    return [self.mananger POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
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
    return [self.mananger POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (void)setHttpHead:(AFHTTPSessionManager*)mananger{
    if (self.dictHead) {
        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        
        NSArray * keys=self.dictHead.allKeys;
        for (NSString *key in keys) {
            NSString * value=[self.dictHead objectForKey:key];
            [requestSerializer setValue:value forHTTPHeaderField:key];
        }
        mananger.requestSerializer=requestSerializer;
    }
    
    mananger.requestSerializer.HTTPShouldHandleCookies=self.HTTPShouldHandleCookies;
    mananger.requestSerializer.timeoutInterval=10;
    mananger.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
}



@end
