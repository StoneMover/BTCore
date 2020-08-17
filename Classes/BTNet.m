//
//  BTNet.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTNet.h"
#import "BTUserMananger.h"
#import "BTCoreConfig.h"
#import <BTHelp/BTUtils.h>

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

+ (BOOL)isSuccess:(NSDictionary*_Nullable)dict{
    return [BTCoreConfig share].netSuccessBlock(dict);
}

+ (NSInteger)errorCode:(NSDictionary*_Nullable)dict{
    return [BTCoreConfig share].netCodeBlock(dict);
}

+ (NSString*)errorInfo:(NSDictionary*_Nullable)dict{
    return [BTCoreConfig share].netInfoBlock(dict);
}

+ (NSArray*)defaultDictArray:(NSDictionary*_Nullable)dict{
    return [BTCoreConfig share].netDataArrayBlock(dict);
}

+ (NSDictionary*)defaultDictData:(NSDictionary*_Nullable)dict{
    return [BTCoreConfig share].netDataBlock(dict);
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



@end
