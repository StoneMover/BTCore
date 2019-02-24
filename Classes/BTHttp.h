//
//  BTHttpRequest.h
//  framework
//
//  Created by whbt_mac on 2016/10/18.
//  Copyright © 2016年 StoneMover. All rights reserved.
//  对于AFNetworking的再次封装,避免以后网络请求库的替换操作
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
@interface BTHttp : NSObject

@property(nonatomic,strong) NSSet <NSString *> *acceptableContentTypes;

+(instancetype)share;


#pragma mark GET请求
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


#pragma mark POST请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable void (^)(NSProgress * _Nullable progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;



- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                       failure:(void (^)(NSURLSessionDataTask * task, NSError * _Nonnull error))failure;


#pragma mark 数据上传
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//添加头信息
-(void)addHttpHead:(NSString*)key value:(NSString*)value;

//是否携带cookie信息
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

@end

NS_ASSUME_NONNULL_END
