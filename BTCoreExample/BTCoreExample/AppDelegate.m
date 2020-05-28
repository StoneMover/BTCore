//
//  AppDelegate.m
//  BTCoreExample
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "AppDelegate.h"
#import "BTViewController.h"
#import "BTHttp.h"
#import <BTHelp/BTModel.h>
#import "BTCoreConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    BTNavigationController * nav =[BTNavigationController alloc]
    
    BTCoreConfig.share.isLogHttpParameters = YES;
    BTHttp * request=[BTHttp share];
    NSString * url =@"http://192.168.2.136:9803/user/isExpire";
    [request POST:url parameters:@{@"sessionId":@"050ec85b-31cc-4956-b8eb-45cf01214ded",@"username":@"15623728016"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
