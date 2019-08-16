//
//  BTLoadingSubView.h
//  BTLoadingTest
//
//  Created by zanyu on 2019/8/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTLoadingSubView : UIView

@property (nonatomic, strong) UIImageView * imgView;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UIButton * btn;

@property (nonatomic, copy) void(^clickBlock)(void);

- (void)initSubView;

- (void)show:(NSString*)title img:(UIImage*)img;


@end
