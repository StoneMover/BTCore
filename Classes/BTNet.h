//
//  BTNet.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHttp.h"


typedef void(^BTNetSuccessBlcok)(id obj);

typedef void(^BTNetFailBlock)(NSError * error,NSString * errorInfo);

typedef void(^BTNetFailFullBlock)(NSError * error,int code,NSString * errorInfo);


@interface BTNet : NSObject

//获取基本url,传入rootUrl,模块名称,方法名称
+ (NSString*)getUrl:(NSString*)rootUrl
         moduleName:(NSString*)moduleName
       functionName:(NSString*)functionName;

//获取基本拼接url,传入模块名称,方法名称,rootUrl默认为ROOT_URL
+ (NSString*)getUrl:(NSString*)moduleName
       functionName:(NSString*)functionName;

//传入方法名,rootUrl默认为ROOT_URL
+ (NSString*)getUrlModule:(NSString*)moduleName;

//在重写了moduleName方法的情况下，直接传入方法名称即可
+ (NSString*)getUrlFunction:(NSString*)functionName;

//默认的模块名称，为空，需要自己重写，然后调用getUrlFunction方法
+ (NSString*)moduleName;


//获取默认的数据请求字典
+ (NSMutableDictionary*)defaultDict;
+ (NSMutableDictionary*)defaultDict:(NSDictionary*)dict;

//判断网络是否请求成功
+ (BOOL)isSuccess:(NSDictionary*)dict;

//获取错误状态码
+ (NSInteger)errorCode:(NSDictionary*)dict;

//获取请求json中的错误信息
+ (NSString*)errorInfo:(NSDictionary*)dict;

//获取数据列表请求中的json列表数组字典
+ (NSArray*)defaultDictArray:(NSDictionary*)dict;

//获取请求中的需要使用的数据
+ (NSDictionary*)defaultDictData:(NSDictionary*)dict;

//获取图片拼接地址的完整url，传入拼接的url，如果不需要拼接则[BTCoreConfig share].imgRootUrl不设置即可
+ (NSURL*)getImgResultUrl:(NSString*)url;



@end


