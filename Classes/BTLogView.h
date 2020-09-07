//
//  BTLogView.h
//  BTCoreExample
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface BTLogView : UIView

+ (instancetype)share;

- (void)show;

- (void)hide;

- (void)add:(NSString*)str;

- (void)addAndSave:(NSString*)str;

- (void)clear;

//0:上,1:中,2:底部
- (void)setLocation:(NSInteger)location;

@end


@interface BTLogTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTitle;

@end


NS_ASSUME_NONNULL_END
