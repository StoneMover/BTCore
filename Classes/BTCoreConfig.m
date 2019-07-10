//
//  BTCoreConfig.m
//  live
//
//  Created by stonemover on 2019/5/9.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTCoreConfig.h"


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
    self.netKeyInfo=@"info";
    self.netKeyCode=@"code";
    self.netKeyData=@"data";
    self.netSuccessCode=1;
    
    self.keyUid=@"uid";
    self.keyOs=@"os";
    self.keyVersion=@"version";
    self.keyOsVersion=@"osVersion";
    self.keyToken=@"token";
    
    self.keyPageList=@"list";
    
    
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
