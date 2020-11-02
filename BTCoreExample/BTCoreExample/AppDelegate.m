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
#import "ViewController.h"
#import <BTHelp/BTUtils.h>
#import "FullTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    BTCoreConfig.share.defaultVCBgColor = [UIColor bt_RGBSame:235];
    ViewController * vc = [ViewController new];
    BTNavigationController * nav =[[BTNavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
  if (self.isForceLandscape) {
      return UIInterfaceOrientationMaskLandscape;
  }else if (self.isForcePortrait){
      return UIInterfaceOrientationMaskPortrait;
  }
  return UIInterfaceOrientationMaskPortrait;
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
