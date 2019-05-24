//
//  UIImage+Color.m
//  HDKeyBoard
//
//  Created by VanJay on 2017/7/21.
//  Copyright © 2017年 VanJay. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);  // 宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size);            // 在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);  // 在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);                          // 用这个颜色填充这个上下文

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();  // 从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color height:(CGFloat)height {
    CGRect r = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

@end
