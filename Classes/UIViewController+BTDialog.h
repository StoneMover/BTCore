//
//  UIViewController+BTDialog.h
//  moneyMaker
//
//  Created by Motion Code on 2019/2/1.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BTDialogBlock)(NSInteger index);


@interface UIViewController (BTDialog)

//创建一个alertController
- (UIAlertController*_Nonnull)createAlert:(NSString*_Nullable)title
                                      msg:(NSString*_Nullable)msg
                                   action:(NSArray*_Nullable)action
                                    style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*_Nonnull)action:(NSString*_Nullable)str
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (void)showAlert:(NSString*_Nonnull)title
              msg:(NSString*_Nullable)msg
             btns:(NSArray*_Nullable)btns
            block:(BTDialogBlock _Nullable )block;


//显示确定取消类型
- (void)showAlertDefault:(NSString*_Nullable)title
                     msg:(NSString*_Nullable)msg
                   block:(BTDialogBlock _Nullable)block;

//显示底部弹框,最后一个为取消类型
- (void)showActionSheet:(NSString*_Nullable)title
                    msg:(NSString*_Nullable)msg
                   btns:(NSArray*_Nullable)btns
                  block:(BTDialogBlock _Nullable )block;

//显示编辑框类型
- (void)showAlertEdit:(NSString*_Nullable)title
         defaultValue:(NSString*_Nullable)value
          placeHolder:(NSString*_Nullable)placeHolder
                block:(void(^_Nullable)(NSString * _Nullable result))block;


@end








