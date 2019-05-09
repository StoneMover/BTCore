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
- (UIAlertController*_Nonnull)createAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nonnull)msg
                                    action:(NSArray*_Nonnull)action
                            style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*_Nonnull)action:(NSString*_Nonnull)str
                   style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (void)showAlert:(NSString*_Nonnull)title
                              msg:(NSString*_Nonnull)msg
                             btns:(NSArray*_Nonnull)btns
            block:(BTDialogBlock _Nonnull )block;


//显示确定取消类型
- (void)showAlertDefault:(NSString*_Nonnull)title
                     msg:(NSString*_Nonnull)msg
                   block:(BTDialogBlock _Nonnull)block;

//显示底部弹框,最后一个为取消类型
- (void)showActionSheet:(NSString*_Nonnull)title
                   btns:(NSArray*_Nonnull)btns
                  block:(BTDialogBlock _Nonnull)block;

//显示编辑框类型
- (void)showAlertEdit:(NSString*_Nullable)title
         defaultValue:(NSString*_Nullable)value
          placeHolder:(NSString*_Nullable)placeHolder
                block:(void(^_Nullable)(NSString * _Nullable result))block;


@end








