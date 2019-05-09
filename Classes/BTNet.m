//
//  BTNet.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTNet.h"
#import <BTHelp/BTUserMananger.h>
#import "BTCoreConfig.h"

@implementation BTNet

//传入rootUrl,module名称,方法名称
+(NSString*)getUrl:(NSString*)rootUrl moduleName:(NSString*)moduleName functionName:(NSString*)functionName{
    if (functionName) {
        return [NSString stringWithFormat:@"%@/%@/%@",rootUrl,moduleName,functionName];
    }else{
        return [NSString stringWithFormat:@"%@/%@",rootUrl,moduleName];
    }
}

//传入module名称和方法名称
+(NSString*)getUrl:(NSString*)moduleName functionName:(NSString*)functionName{
    return [self getUrl:[BTCoreConfig share].rootUrl moduleName:moduleName functionName:functionName];
}

//只有module名称,没有方法名称
+(NSString*)getUrlModule:(NSString*)moduleName{
    return [self getUrl:moduleName functionName:nil];
}

+ (NSString*)getUrlFunction:(NSString*)functionName{
    return [self getUrl:[self moduleName] functionName:functionName];
}

+ (NSString*)moduleName{
    return @"";
}

//获取默认的字典
+(NSMutableDictionary*)defaultDict{
    return [self defaultDict:nil];
}

+(NSMutableDictionary*)defaultDict:(NSDictionary*)dict{
    NSMutableDictionary * dictResult=nil;
    if (dict) {
        dictResult=[[NSMutableDictionary alloc] initWithDictionary:dict];
    }else{
        dictResult=[[NSMutableDictionary alloc] init];
    }
    NSString * version=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString * os=[BTCoreConfig share].keyOs;
    NSString * osVersion=[UIDevice currentDevice].systemVersion;
    [dictResult setValue:version forKey:[BTCoreConfig share].keyVersion];
    [dictResult setValue:os forKey:[BTCoreConfig share].keyOs];
    [dictResult setValue:osVersion forKey:[BTCoreConfig share].keyOsVersion];
    if (UserMan.isLogin) {
        if (UserManModel.userId) {
            [dictResult setValue:UserManModel.userId forKey:[BTCoreConfig share].keyUid];
        }
        
        if (UserManModel.userToken) {
            [dictResult setValue:UserManModel.userToken forKey:[BTCoreConfig share].keyToken];
        }
        
    }
    return dictResult;
}

+(BOOL)isSuccess:(NSDictionary*)dict{
    NSString * code =[NSString stringWithFormat:@"%@",[dict objectForKey:[BTCoreConfig share].netKeyCode]];
    if (code.integerValue==1) {
        return YES;
    }
    return NO;
}

+(NSString*)errorInfo:(NSDictionary*)dict{
    return [dict objectForKey:[BTCoreConfig share].netKeyInfo];
}

+(NSURL*)getImgResultUrl:(NSString*)url{
   return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BTCoreConfig share].imgRootUrl,url]];
}

@end
