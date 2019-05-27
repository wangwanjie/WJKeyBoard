//
//  UIImage+Color.h
//  WJKeyBoard
//
//  Created by VanJay on 2017/7/21.
//  Copyright © 2017年 VanJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/** 根据颜色产生图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color height:(CGFloat)height;

@end
