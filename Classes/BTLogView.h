//
//  BTLogView.h
//  BTCoreExample
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface BTLogView : NSObject

+ (instancetype)share;

//如果不需要显示不用调用show方法即可
- (void)show;

- (void)hide;

- (void)add:(NSString*)str;

- (void)addAndSave:(NSString*)str;

- (void)clear;

- (NSString * _Nullable)exportData;

//0:上,1:中,2:底部
@property (nonatomic, assign, readonly) NSInteger location;

@end


@interface BTLogTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTitle;

@end


@interface BTLogWindow : UIWindow


@end


NS_ASSUME_NONNULL_END
