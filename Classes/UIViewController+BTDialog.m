//
//  UIViewController+BTDialog.m
//  moneyMaker
//
//  Created by Motion Code on 2019/2/1.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "UIViewController+BTDialog.h"
#import "Const.h"

@implementation UIViewController (BTDialog)

- (UIAlertController*)createAlert:(NSString*)title
                              msg:(NSString*)msg
                           action:(NSArray*)action
                            style:(UIAlertControllerStyle)style{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    for (UIAlertAction * a in action) {
        [alertController addAction:a];
    }
    return alertController;
}

- (UIAlertAction*)action:(NSString*)str
                   style:(UIAlertActionStyle)style
                 handler:(void (^ __nullable)(UIAlertAction *action))handler{
    return [UIAlertAction actionWithTitle:str
                                    style:style
                                  handler:handler];
}


- (void)showAlert:(NSString*)title
                              msg:(NSString*)msg
                             btns:(NSArray*)btns
                            block:(BTDialogBlock)block{
    NSMutableArray * actions=[NSMutableArray new];
    for (int i=0; i<btns.count; i++) {
        NSString * str=btns[i];
        UIAlertAction * action =nil;
        if (btns.count==2) {
            if (i==0) {
                action=[self action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
        }else{
            if (i==btns.count-1) {
                action=[self action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
            
        }
        [actions addObject:action];
    }
    UIAlertController * controller=[self createAlert:title msg:msg action:actions style:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)showAlertDefault:(NSString*)title
                     msg:(NSString*)msg
                   block:(BTDialogBlock)block{
    UIAlertAction * actionCancel=[self action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(0);
    }];
    UIAlertAction * actionOk=[self action:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        block(1);
    }];
    UIAlertController * alertController=[self createAlert:title msg:msg action:@[actionCancel,actionOk] style:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showActionSheet:(NSString*)title
                   btns:(NSArray*)btns
                  block:(BTDialogBlock)block{
    NSMutableArray * dataArray=[NSMutableArray new];
    for (NSString * btn in btns) {
        UIAlertAction * action=[self action:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            block([dataArray indexOfObject:action]);
        }];
        [dataArray addObject:action];
    }
    
    UIAlertAction * action=[self action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(dataArray.count-1);
    }];
    [dataArray addObject:action];
    UIAlertController * alertController=[self createAlert:title msg:@"" action:dataArray style:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showAlertEdit:(NSString*)title
         defaultValue:(NSString*)value
          placeHolder:(NSString*)placeHolder
                block:(void(^)(NSString * result))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =placeHolder;
        textField.returnKeyType=UIReturnKeyDone;
        textField.text=value;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    [cancelAction setValue:MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //获得文本框
        UITextField * field = alertController.textFields.firstObject;
        NSString * text=field.text;
        block(text);
    }];
    [okAction setValue:MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end







