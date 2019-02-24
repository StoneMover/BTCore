//
//  BTLoadingHelp.h
//  moneyMaker
//
//  Created by Motion Code on 2019/2/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BTLoadingHelpDelegate <NSObject>

- (void)keyBoradHeightChange;

@end

@interface BTLoadingHelp : NSObject

+ (BTLoadingHelp*)share;

@property (nonatomic, assign) CGFloat keyboardHeight;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

@property (nonatomic, weak) id<BTLoadingHelpDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
