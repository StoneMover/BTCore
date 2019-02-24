//
//  BTViewController.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BTLoading.h"
#import "BTToast.h"
#import "BTProgress.h"
#import "UIViewController+BTNavSet.h"


NS_ASSUME_NONNULL_BEGIN

@interface BTViewController : UIViewController

- (void)getData;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
