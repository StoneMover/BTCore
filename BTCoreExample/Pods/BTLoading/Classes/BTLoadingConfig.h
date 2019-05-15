//
//  BTLoadingHelp.h
//  moneyMaker
//
//  Created by Motion Code on 2019/2/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BTLoadingHelpDelegate <NSObject>

- (void)keyBoradHeightChange;

@end

@interface BTLoadingConfig : NSObject

+ (BTLoadingConfig*)share;

@property (nonatomic, assign) CGFloat keyboardHeight;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

@property (nonatomic, weak) id<BTLoadingHelpDelegate> delegate;

@property (nonatomic, strong) NSString * loadingStr;

@property (nonatomic, strong) NSString * emptyStr;

@property (nonatomic, strong) NSString * errorInfo;

@property (nonatomic, strong) NSString * loadingGif;

@property (nonatomic, strong) NSString * emptyImg;

@property (nonatomic, strong) NSString * errorImg;

- (UIImage*)imageBundleName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
