//
//  BTNet.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTHttp.h"

#define ROOT_URL @"http://120.78.83.132:3308"
#define RESULT_IMG_URL(url) [BTNet getImgResultUrl:url]

typedef void(^BTNetSuccessBlcok)(id obj);
typedef void(^BTNetFailBlock)(NSError * error);



@interface BTNet : NSObject

//获取基本url,传入rootUrl,模块名称,方法名称
+(NSString*)getUrl:(NSString*)rootUrl
        moduleName:(NSString*)moduleName
      functionName:(NSString*)functionName;

//获取基本拼接url,传入模块名称,方法名称,rootUrl默认为ROOT_URL
+(NSString*)getUrl:(NSString*)moduleName
      functionName:(NSString*)functionName;

//传入方法名,rootUrl默认为ROOT_URL
+(NSString*)getUrl:(NSString*)functionName;


//获取默认的字典
+(NSMutableDictionary*)defaultDict;
+(NSMutableDictionary*)defaultDict:(NSDictionary*)dict;

+(BOOL)isSuccess:(NSDictionary*)dict;
+(NSString*)errorInfo:(NSDictionary*)dict;
+(NSURL*)getImgResultUrl:(NSString*)url;

@end


