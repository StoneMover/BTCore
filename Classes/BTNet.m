//
//  BTNet.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTNet.h"
#import <BTHelp/BTUserMananger.h>

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
    return [self getUrl:ROOT_URL moduleName:moduleName functionName:functionName];
}

//只有module名称,没有方法名称
+(NSString*)getUrl:(NSString*)moduleName{
    return [self getUrl:moduleName functionName:nil];
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
    NSString * os=@"iOS";
    NSString * osVersion=[UIDevice currentDevice].systemVersion;
    [dictResult setValue:version forKey:@"version"];
    [dictResult setValue:os forKey:@"os"];
    [dictResult setValue:osVersion forKey:@"os_version"];
    if (UserMan.isLogin) {
        [dictResult setValue:UserManModel.userId forKey:@"userId"];
    }
    return dictResult;
}

+(BOOL)isSuccess:(NSDictionary*)dict{
    NSString * code =[NSString stringWithFormat:@"%@",[dict objectForKey:@"succeed"]];
    if (code.integerValue==1) {
        return YES;
    }
    return NO;
}

+(NSString*)errorInfo:(NSDictionary*)dict{
    return [dict objectForKey:@"description"];
}

+(NSURL*)getImgResultUrl:(NSString*)url{
   return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ROOT_URL,url]];
}

@end
