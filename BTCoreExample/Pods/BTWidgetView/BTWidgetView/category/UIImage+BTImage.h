//
//  UIImage+BTImage.h
//  moneyMaker
//
//  Created by Motion Code on 2019/1/29.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BTImage)

+ (UIImage*)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color equalSize:(CGFloat)size;

//加载图片不受系统颜色的影响显示
+ (UIImage*)imageOriWithName:(NSString*)imgName;

//压缩大小到指定的大小
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

//将图片缩放到指定的大小，多出的部分将以中心为基准进行裁剪
- (UIImage *)scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
