//
//  BTCoreConfig.m
//  live
//
//  Created by stonemover on 2019/5/9.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTCoreConfig.h"
#import "BTUserMananger.h"
#import <BTHelp/BTUtils.h>
#import "BTNet.h"

static BTCoreConfig * config=nil;

@implementation BTCoreConfig

+ (instancetype)share{
    if (!config) {
        config=[BTCoreConfig new];
    }
    return config;
}


- (instancetype)init{
    self=[super init];
    
    self.netInfoBlock = ^NSString *(NSDictionary *dict) {
        return [dict objectForKey:@"info"];
    };
    
    self.netCodeBlock = ^NSInteger(NSDictionary *dict) {
        return [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]].integerValue;
    };
    
    self.netDataBlock = ^NSDictionary *(NSDictionary *dict) {
        return [dict objectForKey:@"data"];
    };
    
    self.netDataArrayBlock = ^NSArray *(NSDictionary *dict) {
        return [dict objectForKey:@"list"];
    };
    
    self.netSuccessBlock = ^BOOL(NSDictionary *dict) {
        return self.netCodeBlock(dict)==0;
    };
    
    self.netDefaultDictBlock = ^NSDictionary *{
        NSMutableDictionary * dict = [NSMutableDictionary new];
        NSString * version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        NSString * os = @"ios";
        NSString * osVersion = [UIDevice currentDevice].systemVersion;
        [dict setValue:version forKey:@"appVersion"];
        [dict setValue:os forKey:@"os"];
        [dict setValue:osVersion forKey:@"osVersion"];
        if ([BTUserMananger share].isLogin) {
            if (![BTUtils isEmpty:[BTUserMananger share].model.userId]) {
                [dict setValue:[BTUserMananger share].model.userId forKey:@"uid"];
            }
            
            if (![BTUtils isEmpty:[BTUserMananger share].model.userToken]) {
                [dict setValue:[BTUserMananger share].model.userToken forKey:@"token"];
            }
            
        }
        return dict;
    };
    
    self.netFillterBlock = ^BOOL(NSObject *obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary * dict = (NSDictionary*)obj;
//            NSInteger code = [BTNet errorCode:dict];
//            switch (code) {
//                case 100:
//                    //处理一些什么吧
//                    break;
//
//                default:
//                    break;
//            }
//        }else if([obj isKindOfClass:[NSError class]]){
//            //解析错误信息处理
//        }
        
        return YES;
    };
    
    self.navItemPaddingBlock = ^BOOL(NSLayoutConstraint *constraint) {
        if (fabs(constraint.constant)==12||fabs(constraint.constant)==8||fabs(constraint.constant)==16) {
            return YES;
        }
        return NO;
    };
    
    self.mainColor=[UIColor redColor];
    
    self.pageLoadSizePage=20;
    self.pageLoadStartPage=1;
    
    
    self.defaultNavTitleFont=[UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    self.defaultNavTitleColor=UIColor.blackColor;
    self.defaultNavLeftBarItemFont=[UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.defaultNavLeftBarItemColor=UIColor.blackColor;
    self.defaultNavRightBarItemFont=[UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.defaultNavRightBarItemColor=UIColor.blackColor;
    
    return self;
}

@end
