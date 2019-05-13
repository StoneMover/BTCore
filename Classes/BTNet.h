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



@interface BTNet : NSObject

//获取基本url,传入rootUrl,模块名称,方法名称
+(NSString*)getUrl:(NSString*)rootUrl
        moduleName:(NSString*)moduleName
      functionName:(NSString*)functionName;

//获取基本拼接url,传入模块名称,方法名称,rootUrl默认为ROOT_URL
+(NSString*)getUrl:(NSString*)moduleName
      functionName:(NSString*)functionName;

//传入方法名,rootUrl默认为ROOT_URL
+(NSString*)getUrlModule:(NSString*)moduleName;

//在重写了moduleName方法的情况下，直接传入方法名称即可
+ (NSString*)getUrlFunction:(NSString*)functionName;

//默认的模块名称，为空，需要自己重写，然后调用getUrlFunction方法
+ (NSString*)moduleName;


//获取默认的字典
+(NSMutableDictionary*)defaultDict;
+(NSMutableDictionary*)defaultDict:(NSDictionary*)dict;

+(BOOL)isSuccess:(NSDictionary*)dict;
+(NSString*)errorInfo:(NSDictionary*)dict;
+(NSURL*)getImgResultUrl:(NSString*)url;

@end


