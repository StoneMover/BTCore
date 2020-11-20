//
//  TestNet.h
//  BTCoreExample
//
//  Created by apple on 2020/11/20.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "BTHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestNet : BTNet

+ (void)test:(BTNetSuccessBlcok)success fail:(BTNetFailBlock)fail;

@end

NS_ASSUME_NONNULL_END
