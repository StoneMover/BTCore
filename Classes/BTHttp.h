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

@property (nonatomic, strong, readonly) AFHTTPSessionManager * mananger;

//是否携带cookie信息
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

//设置超时时间
@property (nonatomic, assign) NSInteger timeInterval;

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

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

//删除头部信息
- (void)delHttpHead:(NSString*)key;

//设置接收数据类型
- (void)setResponseAcceptableContentType:(NSSet<NSString*>*)acceptableContentTypes;

@end



typedef void(^BTNetSuccessBlcok)(id obj);

typedef void(^BTNetFailBlock)(NSError * _Nullable error,NSString * _Nullable errorInfo);

typedef void(^BTNetFailFullBlock)(NSError * _Nullable error,NSInteger code,NSString * _Nullable errorInfo);


@interface BTNet : NSObject

//获取基本url,传入rootUrl,模块名称,方法名称
+ (NSString*)getUrl:(NSString*)rootUrl
         moduleName:(NSString*)moduleName
       functionName:(NSString*_Nullable)functionName;

//获取基本拼接url,传入模块名称,方法名称,rootUrl默认为ROOT_URL
+ (NSString*)getUrl:(NSString*)moduleName
       functionName:(NSString*_Nullable)functionName;

//传入方法名,rootUrl默认为ROOT_URL
+ (NSString*)getUrlModule:(NSString*)moduleName;

//在重写了moduleName方法的情况下，直接传入方法名称即可
+ (NSString*)getUrlFunction:(NSString*)functionName;

//默认的模块名称，为空，需要自己重写，然后调用getUrlFunction方法
+ (NSString*)moduleName;


//获取默认的数据请求字典
+ (NSMutableDictionary*)defaultDict;
+ (NSMutableDictionary*)defaultDict:(NSDictionary*_Nullable)dict;

//判断网络是否请求成功
+ (BOOL)isSuccess:(NSDictionary * _Nullable)dict;

//获取错误状态码
+ (NSInteger)errorCode:(NSDictionary * _Nullable)dict;

//获取请求json中的错误信息
+ (NSString*)errorInfo:(NSDictionary * _Nullable)dict;

//获取数据列表请求中的json列表数组字典
+ (NSArray*)defaultDictArray:(NSDictionary * _Nullable)dict;

//获取请求中的需要使用的数据
+ (NSDictionary*)defaultDictData:(NSDictionary * _Nullable)dict;

//获取图片拼接地址的完整url，传入拼接的url，如果不需要拼接则[BTCoreConfig share].imgRootUrl不设置即可
+ (NSURL*)getImgResultUrl:(NSString*_Nullable)url;



@end


NS_ASSUME_NONNULL_END
