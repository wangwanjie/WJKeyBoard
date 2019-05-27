//
//  WJKeyBoardTheme.h
//  customer
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WJKeyBoardButtonType) {
    WJKeyBoardButtonTypeDigital = 0,  ///< 数字
    WJKeyBoardButtonTypeLetter,       ///< 字母
    WJKeyBoardButtonTypeDone,         ///< 完成
    WJKeyBoardButtonTypeDelete,       ///< 删除
    WJKeyBoardButtonTypeASCII,        ///< 特殊字符
    WJKeyBoardButtonTypeBlank,        ///< 空格
    WJKeyBoardButtonTypeShift,        ///< 切换大小写
    WJKeyBoardButtonTypeToDigital,    ///< 切数字键盘
    WJKeyBoardButtonTypeToLetter,     ///< 切字母键盘
    WJKeyBoardButtonTypeToASCII,      ///< 切特殊符号
    WJKeyBoardButtonTypeNone          ///< 占位，什么也没有，禁用
};

typedef NS_ENUM(NSUInteger, WJKeyBoardEnterpriseInfoShowType) {
    WJKeyBoardEnterpriseInfoShowTypeImageLeft = 0,  ///< 默认，图片在左，文字在右
    WJKeyBoardEnterpriseInfoShowTypeImageRight,     ///< 图片在右
};

NS_ASSUME_NONNULL_BEGIN

@interface WJKeyBoardButtonModel : NSObject

+ (instancetype)modelWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(WJKeyBoardButtonType)type;
- (instancetype)initWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(WJKeyBoardButtonType)type;
@property (nonatomic, assign) BOOL isCapital;             ///< 是否大写
@property (nonatomic, copy) NSString *showText;           ///< 显示的
@property (nonatomic, copy) NSString *value;              ///< 实际值
@property (nonatomic, assign) WJKeyBoardButtonType type;  ///< 按钮类型

@property (nonatomic, strong) UIColor *titleColor;           ///< 文字颜色
@property (nonatomic, strong) UIColor *highlightTitleColor;  ///< 高亮文字颜色
@property (nonatomic, strong) UIColor *bgColor;              ///< 背景颜色
@property (nonatomic, strong) UIColor *highlightBgColor;     ///< 高亮背景颜色
@property (nonatomic, strong) UIColor *selectedBgColor;      ///< 选中背景颜色
@property (nonatomic, assign) BOOL isFunctional;             ///< 是否功能按钮

@end

@interface WJKeyBoardButton : UIButton

@property (nonatomic, strong) WJKeyBoardButtonModel *model;  ///< 模型

+ (instancetype)keyBoardButtonWithModel:(WJKeyBoardButtonModel *)model;
- (instancetype)initKeyBoardButtonWithModel:(WJKeyBoardButtonModel *)model;
- (void)hd_updateTitle;
@end

@interface WJKeyBoardTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;                              ///< 背景色
@property (nonatomic, strong) UIColor *buttonBgColor;                                ///< 按钮背景色
@property (nonatomic, strong) UIColor *buttonSelectedBgColor;                        ///< 按钮选中时背景色
@property (nonatomic, strong) UIColor *buttonHighlightBgColor;                       ///< 按钮高亮背景色
@property (nonatomic, strong) UIColor *funcButtonBgColor;                            ///< 功能按钮背景色
@property (nonatomic, strong) UIColor *funcButtonSelectedBgColor;                    ///< 功能按钮选中时背景色
@property (nonatomic, strong) UIColor *funcButtonHighlightBgColor;                   ///< 功能按钮高亮背景色
@property (nonatomic, strong) UIFont *digitalButtonFont;                             ///< 数字键盘字体
@property (nonatomic, strong) UIFont *letterButtonFont;                              ///< 字母键盘字体
@property (nonatomic, strong) UIColor *buttonTitleColor;                             ///< 按钮文字颜色
@property (nonatomic, strong) UIColor *buttonTitleHighlightColor;                    ///< 按钮文字高亮颜色
@property (nonatomic, assign) WJKeyBoardEnterpriseInfoShowType enterpriseShowStyle;  ///< 商业信息图片文字类型，默认图片居左
@property (nonatomic, strong) UIFont *enterpriseLabelFont;                           ///< 商业信息文字字体
@property (nonatomic, assign) CGFloat enterpriseMargin;                              ///< 商业信息图片和文字间距，默认 10
@property (nonatomic, strong) UIColor *enterpriseLabelColor;                         ///< 商业信息文字颜色
@property (nonatomic, copy) NSString *enterpriseLogoImage;                           ///< 商业信息 logo
@property (nonatomic, copy) NSString *enterpriseText;                                ///< 商业信息文字
@property (nonatomic, copy) NSString *deleteButtonImage;                             ///< 删除按钮图片
@property (nonatomic, copy) NSString *shiftButtonImage;                              ///< shift按钮图片
@property (nonatomic, copy) NSString *shiftButtonSelectedImage;                      ///< shift按钮选中图片
@property (nonatomic, copy) NSString *doneButtonName;                                ///< 完成按钮标题
@property (nonatomic, strong) UIColor *doneButtonTitleColor;                         ///< 完成按钮标题颜色
@property (nonatomic, strong) UIColor *doneButtonHighlightTitleColor;                ///< 完成按钮标题高亮颜色
@property (nonatomic, strong) UIColor *doneButtonBgColor;                            ///< 完成按钮背景颜色
@property (nonatomic, strong) UIColor *doneButtonHighlightBgColor;                   ///< 完成按钮高亮背景颜色

@end

NS_ASSUME_NONNULL_END
