//
//  HDKeyBoard.h
//  HDKeyBoard
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "HDKeyBoardTheme.h"
#import <UIKit/UIKit.h>

typedef enum {
    HDKeyBoardTypeNumberPad = 1 << 0,                      ///< 纯数字键盘
    HDKeyBoardTypeDecimalPad = 1 << 1,                     ///< 小数键盘
    HDKeyBoardTypeNumberPadCanSwitchToLetter = 1 << 2,     ///< 可以切换到字母键盘的数字键盘
    HDKeyBoardTypeASCII = 1 << 3,                          ///< 特殊字符键盘
    HDKeyBoardTypeLetterCapable = 1 << 4,                  ///< 字母键盘
    HDKeyBoardTypeLetterCapableCanSwitchToASCII = 1 << 5,  ///< 可以切换到特殊字符键盘的字母键盘
} HDKeyBoardType;

/**
 自定义键盘
 */
@interface HDKeyBoard : UIView

/**
 创建键盘
 
 @param type 键盘类型
 */
+ (nonnull instancetype)keyboardWithType:(HDKeyBoardType)type;

/**
 创建键盘
 
 @param type 键盘类型
 @param theme 键盘主题，为 nil 将使用默认主题
 */
+ (nonnull instancetype)keyboardWithType:(HDKeyBoardType)type theme:(HDKeyBoardTheme *__nullable)theme;

/**
 创建键盘
 
 @param type 键盘类型
 @param isRandom 是否随机排序，只支持数字键盘
 */
+ (nonnull instancetype)keyboardWithType:(HDKeyBoardType)type isRandom:(BOOL)isRandom;

/**
 创建键盘

 @param type 键盘类型
 @param theme 键盘主题，为 nil 将使用默认主题
 @param isRandom 是否随机排序，只支持数字键盘
 */
+ (nonnull instancetype)keyboardWithType:(HDKeyBoardType)type theme:(HDKeyBoardTheme *__nullable)theme isRandom:(BOOL)isRandom;

/** 输入源 */
@property (nonatomic, nullable, strong) UIView *inputSource;

/** 字母键盘是否可以切换到符号键盘，如需要符号键盘并且第一界面就是字母键盘，请设置键盘类型为 HDKeyBoardTypeLetterCapableCanSwitchToASCII */
@property (nonatomic, assign) BOOL isLetterPadCanSwitchToASCII;

/** 是否关闭字母或特殊键盘输入时的预览效果 */
@property (nonatomic, assign) BOOL disablePreviewViewEffect;
@end
