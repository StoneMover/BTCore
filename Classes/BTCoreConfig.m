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
#import "BTHttp.h"
#import <BTHelp/NSString+BTString.h>
#import <BTWidgetView/UIFont+BTFont.h>
#import <BTHelp/UIColor+BTColor.h>

static BTCoreConfig * config=nil;

@implementation BTCoreConfig

+ (nonnull instancetype)share{
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
    
    self.netErrorInfoFillterBlock = ^NSString * _Nonnull(NSError * _Nonnull error) {
        
        if ([error.userInfo.allKeys containsObject:AFNetworkingOperationFailingURLResponseDataErrorKey]) {
            NSData * data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary * dict = [result bt_toDict];
            return BTCoreConfig.share.netInfoBlock(dict);
        }
        
        if (error == nil) {
            return @"未知错误";
        }
        NSString * info=nil;
        if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
            info=[error.userInfo objectForKey:@"NSLocalizedDescription"];
        }else {
            info=error.domain;
        }
        return info;
    };
    
    self.navItemPaddingBlock = ^BOOL(NSLayoutConstraint *constraint) {
        //375宽度屏幕左边距是8，右边距是-16
        if (fabs(constraint.constant)==8) {
            return YES;
        }
        
        if (fabs(constraint.constant)==16) {
            return YES;
        }
        
        
        //414宽度屏幕锁边距是12，右边距是-20
        if (fabs(constraint.constant)==12) {
            return YES;
        }
        
        if (fabs(constraint.constant) == 20) {
            return YES;
        }
        
        return NO;
    };
    
    self.mainColor = UIColor.redColor;
    
    self.pageLoadSizePage = 20;
    self.pageLoadStartPage = 1;
    
    
    self.defaultNavTitleFont = [UIFont BTAutoFontWithSize:18 weight:UIFontWeightBold];
    self.defaultNavTitleColor = UIColor.bt_51Color;
    self.defaultNavLeftBarItemFont = [UIFont BTAutoFontWithSize:15 weight:UIFontWeightBold];
    self.defaultNavLeftBarItemColor = UIColor.bt_51Color;
    self.defaultNavRightBarItemFont = [UIFont BTAutoFontWithSize:15 weight:UIFontWeightBold];
    self.defaultNavRightBarItemColor = UIColor.bt_51Color;
    
    self.navItemPadding = 5;
    
    return self;
}

@end
