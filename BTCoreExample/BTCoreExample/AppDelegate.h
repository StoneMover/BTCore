//
//  AppDelegate.h
//  BTCoreExample
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSMutableArray *  array;

@property (nonatomic, copy) NSMutableString  * str;

@property (assign , nonatomic) BOOL isForceLandscape;

@property (assign , nonatomic) BOOL isForcePortrait;




@end

