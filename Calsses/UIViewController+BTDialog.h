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
- (UIAlertController*)createAlert:(NSString*)title
                              msg:(NSString*)msg
                           action:(NSArray*)action
                            style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*)action:(NSString*)str
                   style:(UIAlertActionStyle)style
                 handler:(void (^ __nullable)(UIAlertAction *action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (void)showAlert:(NSString*)title
                              msg:(NSString*)msg
                             btns:(NSArray*)btns
                            block:(BTDialogBlock)block;


//显示确定取消类型
- (void)showAlertDefault:(NSString*)title
                     msg:(NSString*)msg
                   block:(BTDialogBlock)block;

//显示底部弹框,最后一个为取消类型
- (void)showActionSheet:(NSString*)title
                   btns:(NSArray*)btns
                  block:(BTDialogBlock)block;

//显示编辑框类型
- (void)showAlertEdit:(NSString*)title
         defaultValue:(NSString*)value
          placeHolder:(NSString*)placeHolder
                block:(void(^)(NSString * result))block;


@end








