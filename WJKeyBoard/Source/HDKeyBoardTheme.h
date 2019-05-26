//
//  HDKeyBoardTheme.h
//  customer
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HDKeyBoardButtonType) {
    HDKeyBoardButtonTypeDigital = 0,  ///< 数字
    HDKeyBoardButtonTypeLetter,       ///< 字母
    HDKeyBoardButtonTypeDone,         ///< 完成
    HDKeyBoardButtonTypeDelete,       ///< 删除
    HDKeyBoardButtonTypeASCII,        ///< 特殊字符
    HDKeyBoardButtonTypeBlank,        ///< 空格
    HDKeyBoardButtonTypeShift,        ///< 切换大小写
    HDKeyBoardButtonTypeToDigital,    ///< 切数字键盘
    HDKeyBoardButtonTypeToLetter,     ///< 切字母键盘
    HDKeyBoardButtonTypeToASCII,      ///< 切特殊符号
    HDKeyBoardButtonTypeNone          ///< 占位，什么也没有，禁用
};

typedef NS_ENUM(NSUInteger, HDKeyBoardEnterpriseInfoShowType) {
    HDKeyBoardEnterpriseInfoShowTypeImageLeft = 0,  ///< 默认，图片在左，文字在右
    HDKeyBoardEnterpriseInfoShowTypeImageRight,     ///< 图片在右
};

NS_ASSUME_NONNULL_BEGIN

@interface HDKeyBoardButtonModel : NSObject

+ (instancetype)modelWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type;
- (instancetype)initWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type;
@property (nonatomic, assign) BOOL isCapital;             ///< 是否大写
@property (nonatomic, copy) NSString *showText;           ///< 显示的
@property (nonatomic, copy) NSString *value;              ///< 实际值
@property (nonatomic, assign) HDKeyBoardButtonType type;  ///< 按钮类型

@property (nonatomic, strong) UIColor *titleColor;           ///< 文字颜色
@property (nonatomic, strong) UIColor *highlightTitleColor;  ///< 高亮文字颜色
@property (nonatomic, strong) UIColor *bgColor;              ///< 背景颜色
@property (nonatomic, strong) UIColor *highlightBgColor;     ///< 高亮背景颜色
@property (nonatomic, strong) UIColor *selectedBgColor;      ///< 选中背景颜色
@property (nonatomic, assign) BOOL isFunctional;             ///< 是否功能按钮

@end

@interface HDKeyBoardButton : UIButton

@property (nonatomic, strong) HDKeyBoardButtonModel *model;  ///< 模型

+ (instancetype)keyBoardButtonWithModel:(HDKeyBoardButtonModel *)model;
- (instancetype)initKeyBoardButtonWithModel:(HDKeyBoardButtonModel *)model;
- (void)hd_updateTitle;
@end

@interface HDKeyBoardTheme : NSObject

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
@property (nonatomic, assign) HDKeyBoardEnterpriseInfoShowType enterpriseShowStyle;  ///< 商业信息图片文字类型，默认图片居左
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
