//
//  AccountMananger.h
//  Base
//
//  Created by whbt_mac on 15/9/17.
//  Copyright (c) 2015年 StoneMover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BTHelp/BTModel.h>


@class BTUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTUserMananger : NSObject

+(BTUserMananger*)share;

//是否是第一次打开应用程序
@property(nonatomic,assign) BOOL isFirstOpenApp;

//是否允许没有网络的情况下下载播放视频
@property(nonatomic,assign) BOOL isAllowNoWifiDownload;

//账号缓存,清除用户新的时候并不会清除
@property (nonatomic, strong, nullable) NSString * accountCache;

//是否自动登录
@property (nonatomic, assign) BOOL isAutoLogin;

//是否记住密码
@property (nonatomic, assign) BOOL isRemerberPwd;

//用户个人信息的model
@property (nonatomic, strong) BTUserModel * model;

//是否需要更新个人资料信息
@property (nonatomic, assign) BOOL isNeedUpdateInfoView;

//登出,清理用户信息
-(void)clearUserData;

//更改model的相关的值后,调用此方法保存信息
- (void)updateUserInfo;

//是否登录
- (BOOL)isLogin;

//初始化的时候设置一次就可以了
@property (nonatomic, strong,nullable) NSString * loginVcName;

//是否登录，未登录跳转到登录界面
- (BOOL)isLoginPush:(UIViewController*)rootVc;

//获取存储对象
- (NSUserDefaults*)defaults;


#pragma mark 各项目自行添加

@end

NS_ASSUME_NONNULL_END

@interface BTUserModel : BTModel

@property(nonatomic,strong,nullable) NSString * userName;//用户名

@property(nonatomic,strong,nullable) NSString * userToken;//用户token

@property(nonatomic,strong,nullable) NSString * userId;//用户id


@end




