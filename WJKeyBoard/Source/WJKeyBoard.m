//
//  WJKeyBoard.m
//  customer
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "WJKeyBoard.h"
#import "WJCommonButton.h"
#import "WJKeyBoardDefine.h"
#import "NSString+Size.h"
#import "WJFrameLayout.h"

#define kHDKeyBoardHeight (kScreenWidth * (240 / 375.f) + kiPhoneXSeriesSafeBottomHeight)

@interface WJKeyBoard ()
@property (nonatomic, assign) WJKeyBoardType type;                                                           ///< 类型
@property (nonatomic, strong) WJCommonButton *enterpriseBtn;                                                 ///< 商业信息
@property (nonatomic, strong) WJKeyBoardTheme *theme;                                                        ///< 主题
@property (nonatomic, strong) NSMutableArray<WJKeyBoardButtonModel *> *numberPadConfigArr;                   ///< 数字键盘配置数组
@property (nonatomic, strong) NSMutableArray<WJKeyBoardButtonModel *> *numberPadCanSwitchToLetterConfigArr;  ///< 可以切换到字母键盘的数字键盘
@property (nonatomic, strong) NSMutableArray<WJKeyBoardButtonModel *> *letterKeyBoardConfigArr;              ///< 字母键盘
@property (nonatomic, strong) NSMutableArray<WJKeyBoardButtonModel *> *asciiKeyBoardConfigArr;               ///< 特殊字符键盘
@property (nonatomic, assign) BOOL isNumberPadWithPoint;                                                     ///< 数字键盘是否带小数点
@property (nonatomic, assign) BOOL isRandom;                                                                 ///<  是否随机排序
@property (nonatomic, assign) BOOL isCapital;                                                                ///< 是否大写，用于切换键盘时正确初始化字幕键盘
@property (nonatomic, strong) UIView *containerView;                                                         ///< 容器，用于切换键盘方便
@property (nonatomic, strong) UILabel *popupLabel;                                                           ///< 预览图
@property (nonatomic, strong) WJKeyBoardButton *lastTouchedButton;                                           ///< 标记上次触摸的按钮，用于性能优化
@end

@implementation WJKeyBoard
+ (nonnull instancetype)keyboardWithType:(WJKeyBoardType)type {
    return [[WJKeyBoard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHDKeyBoardHeight) withType:type theme:WJKeyBoardTheme.new isRandom:NO];
}

+ (nonnull instancetype)keyboardWithType:(WJKeyBoardType)type theme:(WJKeyBoardTheme *)theme {
    theme = theme ?: WJKeyBoardTheme.new;
    return [[WJKeyBoard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHDKeyBoardHeight) withType:type theme:theme isRandom:NO];
}

+ (nonnull instancetype)keyboardWithType:(WJKeyBoardType)type isRandom:(BOOL)isRandom {
    return [[WJKeyBoard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHDKeyBoardHeight) withType:type theme:WJKeyBoardTheme.new isRandom:isRandom];
}

+ (nonnull instancetype)keyboardWithType:(WJKeyBoardType)type theme:(WJKeyBoardTheme *)theme isRandom:(BOOL)isRandom {
    theme = theme ?: WJKeyBoardTheme.new;
    return [[WJKeyBoard alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHDKeyBoardHeight) withType:type theme:theme isRandom:isRandom];
}

- (id)initWithFrame:(CGRect)frame withType:(WJKeyBoardType)type theme:(WJKeyBoardTheme *)theme isRandom:(BOOL)isRandom {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.theme = theme;
        self.isRandom = isRandom;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 默认数字键盘
        self.type = WJKeyBoardTypeNumberPad;
        self.theme = [[WJKeyBoardTheme alloc] init];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = self.theme.backgroundColor;

    _enterpriseBtn = [WJCommonButton buttonWithType:UIButtonTypeCustom];
    _enterpriseBtn.adjustsImageWhenDisabled = NO;
    _enterpriseBtn.enabled = NO;
    if (WJIsStringNotEmpty(self.theme.enterpriseLogoImage)) {
        [_enterpriseBtn setImage:[UIImage imageNamed:self.theme.enterpriseLogoImage] forState:UIControlStateNormal];
        if (self.theme.enterpriseShowStyle == WJKeyBoardEnterpriseInfoShowTypeImageLeft) {
            _enterpriseBtn.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.theme.enterpriseMargin);
        } else {
            _enterpriseBtn.imageViewEdgeInsets = UIEdgeInsetsMake(0, self.theme.enterpriseMargin, 0, 0);
        }
    }
    _enterpriseBtn.textAlignment = NSTextAlignmentCenter;
    _enterpriseBtn.isTextAlignmentCenterToWhole = YES;
    [_enterpriseBtn setTitle:self.theme.enterpriseText forState:UIControlStateNormal];
    [_enterpriseBtn setTitleColor:self.theme.enterpriseLabelColor forState:UIControlStateNormal];
    _enterpriseBtn.titleLabel.font = self.theme.enterpriseLabelFont;
    [self addSubview:_enterpriseBtn];

    // 计算商业信息 bounds
    CGFloat enterpriseVMargin = 5;
    CGSize textSize = [_enterpriseBtn.titleLabel.text boundingALLRectWithSize:CGSizeMake(MAXFLOAT, 5) font:_enterpriseBtn.titleLabel.font];
    CGSize imageOriginSize = _enterpriseBtn.imageView.image.size;
    // 保持图片和文字一样高
    CGSize imageSize = CGSizeZero;
    if (_enterpriseBtn.imageView.image) {  // 判断防止除数为 0 崩溃
        imageSize = CGSizeMake(textSize.height * imageOriginSize.width / imageOriginSize.height, textSize.height);
    }
    [_enterpriseBtn wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
        make.centerX.wj_equalTo(self.width * 0.5);
        make.size.wj_equalTo(CGSizeMake(imageSize.width + textSize.width + self.theme.enterpriseMargin, textSize.height + 2 * enterpriseVMargin));
        make.top.wj_equalTo(0);
    }];

    _containerView = [[UIView alloc] init];
    _containerView.frame = CGRectMake(0, _enterpriseBtn.bottom, self.width, self.height - _enterpriseBtn.bottom - kiPhoneXSeriesSafeBottomHeight);
    [self addSubview:_containerView];

    switch (self.type) {
        case WJKeyBoardTypeNumberPad: {
            self.isNumberPadWithPoint = NO;
            [self setUpNumberPadKeyBoard];
        } break;

        case WJKeyBoardTypeDecimalPad: {
            self.isNumberPadWithPoint = YES;
            [self setUpNumberPadKeyBoard];
        } break;

        case WJKeyBoardTypeNumberPadCanSwitchToLetter: {
            self.isNumberPadWithPoint = NO;
            [self setUpNumberPadCanSwitchToLetter];
        } break;

        case WJKeyBoardTypeLetterCapable: {
            self.isLetterPadCanSwitchToASCII = NO;
            [self setUpLetterKeyBoard];
        } break;

        case WJKeyBoardTypeLetterCapableCanSwitchToASCII: {
            self.isLetterPadCanSwitchToASCII = YES;
            [self setUpLetterKeyBoard];
        } break;

        case WJKeyBoardTypeASCII: {
            self.isLetterPadCanSwitchToASCII = YES;
            [self setUpASCIIKeyBoard];
        } break;

        default:
            break;
    }
}

/** 初始化数字或带小数点数字键盘 */
- (void)setUpNumberPadKeyBoard {

    short row = 4, col = 3;
    CGFloat buttonVMargin = 8, buttonHMargin = 10, buttonToScreenHMargin = 5, keyboardToBottom = 10;

    CGFloat buttonW = (self.containerView.width - (col - 1) * buttonHMargin - 2 * buttonToScreenHMargin) / (CGFloat)col;
    CGFloat buttonH = (self.containerView.height - (row - 1) * buttonVMargin - keyboardToBottom) / (CGFloat)row;
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (short i = 0; i < self.numberPadConfigArr.count; i++) {
        WJKeyBoardButtonModel *buttonModel = self.numberPadConfigArr[i];
        WJKeyBoardButton *button = [WJKeyBoardButton keyBoardButtonWithModel:buttonModel];
        if (buttonModel.type == WJKeyBoardButtonTypeDigital) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.digitalButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeASCII) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.letterButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeDelete) {
            [button setImage:[UIImage imageNamed:self.theme.deleteButtonImage] forState:UIControlStateNormal];
        }

        SEL selector = [self selectorFromModel:buttonModel];

        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

        [self setButtonModelPropertyWithButton:button];

        [_containerView addSubview:button];
        CGFloat x = buttonToScreenHMargin + i % col * (buttonW + buttonHMargin);
        CGFloat y = i / col * (buttonH + buttonVMargin);

        button.frame = CGRectMake(x, y, buttonW, buttonH);
        [button setRoundedCorners:UIRectCornerAllCorners radius:5.f];
    }
}

/** 初始化可以切换到字母键盘的数字键盘 */
- (void)setUpNumberPadCanSwitchToLetter {

    short row = 4, col = 3;
    CGFloat buttonVMargin = 8, buttonHMargin = 10, buttonToScreenHMargin = 5, keyboardToBottom = 10, deleteButtonToLeft = 9;

    CGFloat deleteButtonH = (self.containerView.height - buttonVMargin - keyboardToBottom) * 0.5;
    CGFloat deleteButtonW = deleteButtonH * (70 / 96.f);

    CGFloat buttonW = (self.containerView.width - deleteButtonToLeft - deleteButtonW - (col - 1) * buttonHMargin - 2 * buttonToScreenHMargin) / (CGFloat)col;
    CGFloat buttonH = (self.containerView.height - (row - 1) * buttonVMargin - keyboardToBottom) / (CGFloat)row;
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (short i = 0; i < self.numberPadCanSwitchToLetterConfigArr.count; i++) {
        WJKeyBoardButtonModel *buttonModel = self.numberPadCanSwitchToLetterConfigArr[i];
        WJKeyBoardButton *button = [WJKeyBoardButton keyBoardButtonWithModel:buttonModel];
        if (buttonModel.type == WJKeyBoardButtonTypeDigital) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.digitalButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeASCII) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.letterButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeDelete) {
            [button setImage:[UIImage imageNamed:self.theme.deleteButtonImage] forState:UIControlStateNormal];
        }

        SEL selector = [self selectorFromModel:buttonModel];

        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

        [self setButtonModelPropertyWithButton:button];

        [_containerView addSubview:button];

        if (i < self.numberPadCanSwitchToLetterConfigArr.count - 2) {
            CGFloat x = buttonToScreenHMargin + i % col * (buttonW + buttonHMargin);
            CGFloat y = i / col * (buttonH + buttonVMargin);

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i == self.numberPadCanSwitchToLetterConfigArr.count - 2) {
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(deleteButtonW, deleteButtonH));
                make.top.wj_equalTo(0);
                make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
            }];
        } else if (i == self.numberPadCanSwitchToLetterConfigArr.count - 1) {
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(deleteButtonW, deleteButtonH));
                make.top.wj_equalTo(deleteButtonH + buttonVMargin);
                make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
            }];
        }
        [button setRoundedCorners:UIRectCornerAllCorners radius:5.f];
    }
}

/** 初始化字母键盘 */
- (void)setUpLetterKeyBoard {

    short row = 4, firstRowCol = 10, secondRowCol = 9, thirdRowLetterCol = 7;
    CGFloat buttonVMargin = 12, buttonHMargin = 6, buttonToScreenHMargin = 5, keyboardToBottom = 5;

    CGFloat buttonW = (self.containerView.width - (firstRowCol - 1) * buttonHMargin - 2 * buttonToScreenHMargin) / (CGFloat)firstRowCol;
    CGFloat buttonH = (self.containerView.height - (row - 1) * buttonVMargin - keyboardToBottom) / (CGFloat)row;

    CGFloat secondRowButtonToScreenHMargin = (self.containerView.width - secondRowCol * buttonW - (secondRowCol - 1) * buttonHMargin) * 0.5;
    CGFloat thirdRowButtonBiggerMargin = (self.containerView.width - 2 * buttonToScreenHMargin - 2 * buttonH - thirdRowLetterCol * buttonW - (thirdRowLetterCol - 1) * buttonHMargin) * 0.5;

    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (short i = 0; i < self.letterKeyBoardConfigArr.count; i++) {
        WJKeyBoardButtonModel *buttonModel = self.letterKeyBoardConfigArr[i];
        WJKeyBoardButton *button = [WJKeyBoardButton keyBoardButtonWithModel:buttonModel];
        if (buttonModel.type == WJKeyBoardButtonTypeLetter) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.letterButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeShift) {
            [button setImage:[UIImage imageNamed:self.theme.shiftButtonImage] forState:UIControlStateNormal];
        } else if (buttonModel.type == WJKeyBoardButtonTypeDelete) {
            [button setImage:[UIImage imageNamed:self.theme.deleteButtonImage] forState:UIControlStateNormal];
        }

        SEL selector = [self selectorFromModel:buttonModel];

        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

        [self setButtonModelPropertyWithButton:button];

        [_containerView addSubview:button];

        if (i >= 0 && i <= 9) {
            // 第一排
            CGFloat x = buttonToScreenHMargin + i * (buttonW + buttonHMargin);
            CGFloat y = 0;

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i > 9 && i <= 18) {
            // 第二排
            CGFloat x = secondRowButtonToScreenHMargin + (i - 10) * (buttonW + buttonHMargin);
            CGFloat y = buttonH + buttonVMargin;

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i == 19) {
            // 大小写
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 2);
                make.left.wj_equalTo(buttonToScreenHMargin);
            }];
        } else if (i > 19 && i <= 26) {
            // 第三排
            CGFloat x = buttonToScreenHMargin + thirdRowButtonBiggerMargin + buttonH + (i - 20) * (buttonW + buttonHMargin);
            CGFloat y = (buttonH + buttonVMargin) * 2;

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i == 27) {
            // 删除
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 2);
                make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
            }];
        } else if (i == 28) {
            // 123
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                make.left.wj_equalTo(buttonToScreenHMargin);
            }];
        } else if (i == 29) {
            // 空格
            CGFloat doneButtonW = buttonW + buttonH + thirdRowButtonBiggerMargin;
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.left.wj_equalTo(buttonHMargin + buttonH + thirdRowButtonBiggerMargin);
                if (self.isLetterPadCanSwitchToASCII) {
                    make.right.wj_equalTo(self.containerView.width - (doneButtonW + buttonToScreenHMargin + 2 * buttonHMargin + buttonH));
                } else {
                    make.right.wj_equalTo(self.containerView.width - (doneButtonW + buttonToScreenHMargin + buttonHMargin));
                }
                make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                make.height.wj_equalTo(buttonH);
            }];
        } else {
            CGFloat doneButtonW = buttonW + buttonH + thirdRowButtonBiggerMargin;
            if (self.isLetterPadCanSwitchToASCII) {
                // 切特殊符号
                if (i == self.letterKeyBoardConfigArr.count - 2) {
                    [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                        make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                        make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                        make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin - doneButtonW - buttonHMargin);
                    }];
                }
            }

            // 完成
            if (i == self.letterKeyBoardConfigArr.count - 1) {
                [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                    make.size.wj_equalTo(CGSizeMake(doneButtonW, buttonH));
                    make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                    make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
                }];
            }
        }
        [button setRoundedCorners:UIRectCornerAllCorners radius:5.f];
    }
}

/** 初始化特殊字符键盘 */
- (void)setUpASCIIKeyBoard {
    short row = 4, firstRowCol = 10, thirdRowLetterCol = 8, fourthRowLetterCol = 7;
    CGFloat buttonVMargin = 12, buttonHMargin = 6, buttonToScreenHMargin = 5, keyboardToBottom = 5;

    CGFloat buttonW = (self.containerView.width - (firstRowCol - 1) * buttonHMargin - 2 * buttonToScreenHMargin) / (CGFloat)firstRowCol;
    CGFloat buttonH = (self.containerView.height - (row - 1) * buttonVMargin - keyboardToBottom) / (CGFloat)row;

    CGFloat thirdRowButtonToScreenHMargin = (self.containerView.width - buttonToScreenHMargin - buttonH - thirdRowLetterCol * buttonW - (thirdRowLetterCol - 1) * buttonHMargin) * 0.5;
    CGFloat fourthRowButtonBiggerMargin = (self.containerView.width - 2 * buttonToScreenHMargin - 2 * buttonH - fourthRowLetterCol * buttonW - (fourthRowLetterCol - 1) * buttonHMargin) * 0.5;

    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (short i = 0; i < self.asciiKeyBoardConfigArr.count; i++) {
        WJKeyBoardButtonModel *buttonModel = self.asciiKeyBoardConfigArr[i];
        WJKeyBoardButton *button = [WJKeyBoardButton keyBoardButtonWithModel:buttonModel];
        if (buttonModel.type == WJKeyBoardButtonTypeToASCII) {
            [button setTitle:buttonModel.showText forState:UIControlStateNormal];
            button.titleLabel.font = self.theme.letterButtonFont;
        } else if (buttonModel.type == WJKeyBoardButtonTypeDelete) {
            [button setImage:[UIImage imageNamed:self.theme.deleteButtonImage] forState:UIControlStateNormal];
        }

        SEL selector = [self selectorFromModel:buttonModel];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

        [self setButtonModelPropertyWithButton:button];

        [_containerView addSubview:button];

        if (i >= 0 && i <= 19) {
            // 第一、二排
            CGFloat x = buttonToScreenHMargin + i % firstRowCol * (buttonW + buttonHMargin);
            CGFloat y = i / firstRowCol * (buttonH + buttonVMargin);

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i > 19 && i <= 27) {
            // 第三排
            CGFloat x = thirdRowButtonToScreenHMargin + (i - 20) * (buttonW + buttonHMargin);
            CGFloat y = (buttonH + buttonVMargin) * 2;

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i == 28) {
            // 删除
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 2);
                make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
            }];
        } else if (i == 29) {
            // 123
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                make.left.wj_equalTo(buttonToScreenHMargin);
            }];
        } else if (i > 29 && i <= 36) {
            // 第四排
            CGFloat minus = thirdRowButtonToScreenHMargin - fourthRowButtonBiggerMargin;
            CGFloat x = fourthRowButtonBiggerMargin + buttonH + buttonToScreenHMargin + (i - 30) * (buttonW + buttonHMargin) - minus;
            CGFloat y = (buttonH + buttonVMargin) * 3;

            button.frame = CGRectMake(x, y, buttonW, buttonH);
        } else if (i == self.asciiKeyBoardConfigArr.count - 1) {
            // abc
            [button wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
                make.size.wj_equalTo(CGSizeMake(buttonH, buttonH));
                make.top.wj_equalTo((buttonH + buttonVMargin) * 3);
                make.right.wj_equalTo(self.containerView.width - buttonToScreenHMargin);
            }];
        }
        [button setRoundedCorners:UIRectCornerAllCorners radius:5.f];
    }
}

#pragma mark - event response
/** 普通输入 */
- (void)inputAction:(WJKeyBoardButton *)btn {
    NSString *value = btn.model.value;
    NSLog(@"安全键盘输入：%@", value);
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:UITextField.class]) {
            UITextField *tmp = (UITextField *)self.inputSource;

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 0);
                BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:value];
                if (ret) {
                    [tmp insertText:value];
                }
            } else {
                [tmp insertText:value];
            }

        } else if ([self.inputSource isKindOfClass:UITextView.class]) {
            UITextView *tmp = (UITextView *)self.inputSource;

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 0);
                BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:value];
                if (ret) {
                    [tmp insertText:value];
                }
            } else {
                [tmp insertText:value];
            }

        } else if ([self.inputSource isKindOfClass:UISearchBar.class]) {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            [info appendString:value];

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 0);
                BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:value];
                if (ret) {
                    [tmp setText:[info copy]];
                }
            } else {
                [tmp setText:[info copy]];
            }
        } else {
            if (self.inputSource && [self.inputSource respondsToSelector:@selector(insertText:)]) {
                [self.inputSource performSelector:@selector(insertText:) withObject:value];
            }
        }
    }
}

/** 点击了删除 */
- (void)deleteAction:(WJKeyBoardButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            NSString *tmpInfo = tmp.text;
            if (tmpInfo.length > 0) {
                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                    NSRange range = NSMakeRange(tmpInfo.length - 1, 1);
                    BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:@""];
                    if (ret) {
                        [tmp deleteBackward];
                    }
                } else {
                    [tmp deleteBackward];
                }
            }
        } else if ([self.inputSource isKindOfClass:[UITextView class]]) {
            UITextView *tmp = (UITextView *)self.inputSource;
            [tmp deleteBackward];
        } else if ([self.inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            if (info.length > 0) {
                NSString *s = [info substringToIndex:info.length - 1];
                [tmp setText:s];
            }
        } else {
            if (self.inputSource && [self.inputSource respondsToSelector:@selector(deleteBackward)]) {
                [self.inputSource performSelector:@selector(deleteBackward)];
            }
        }
    }
}

/** 点击了完成 */
- (void)doneAction:(WJKeyBoardButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textFieldShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }

        } else if ([self.inputSource isKindOfClass:[UITextView class]]) {
            UITextView *tmp = (UITextView *)self.inputSource;

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textViewShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }

        } else if ([self.inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;

            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate searchBarShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }
        } else {
            if (self.inputSource && [self.inputSource respondsToSelector:@selector(resignFirstResponder)]) {
                [self.inputSource performSelector:@selector(resignFirstResponder)];
            }
        }
    }
}

/** 点击了切换大小写 */
- (void)clickedShiftBtn:(WJKeyBoardButton *)button {
    button.selected = !button.isSelected;
    self.isCapital = button.isSelected;
    if (button.isSelected) {
        [button setImage:[UIImage imageNamed:self.theme.shiftButtonSelectedImage] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:self.theme.shiftButtonImage] forState:UIControlStateNormal];
    }

    for (WJKeyBoardButton *btn in self.containerView.subviews) {
        if (btn.model.type == WJKeyBoardButtonTypeLetter) {
            btn.model.isCapital = button.isSelected;
            [btn hd_updateTitle];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint point = [self convertPoint:touchPoint toView:self.containerView];
    for (WJKeyBoardButton *button in self.containerView.subviews) {
        // 预览只对字母和特殊字符生效
        if (button.model.type == WJKeyBoardButtonTypeLetter || button.model.type == WJKeyBoardButtonTypeASCII) {
            if (CGRectContainsPoint(button.frame, point)) {
                [self addOrUpdatePopupViewForButton:button];
            }
        }
        if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
            button.highlighted = NO;
        }
        if (CGRectContainsPoint(button.frame, point)) {
            if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
                button.highlighted = YES;
            }
            self.lastTouchedButton = button;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint point = [self convertPoint:touchPoint toView:self.containerView];

    // 在同一个按钮上移动就不要继续执行
    if (CGRectContainsPoint(self.lastTouchedButton.frame, point)) return;

    BOOL isTouchedInKeyBoardButton = NO;

    for (WJKeyBoardButton *button in self.containerView.subviews) {
        // 预览只对字母和特殊字符生效
        if (button.model.type == WJKeyBoardButtonTypeLetter || button.model.type == WJKeyBoardButtonTypeASCII) {
            if (CGRectContainsPoint(button.frame, point)) {
                [self addOrUpdatePopupViewForButton:button];
            }
        }

        if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
            button.highlighted = NO;
        }
        if (CGRectContainsPoint(button.frame, point)) {
            if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
                button.highlighted = YES;
            }
            isTouchedInKeyBoardButton = YES;
            self.lastTouchedButton = button;
        }
    }
    if (!isTouchedInKeyBoardButton) {
        self.lastTouchedButton = nil;
        [self removePopupView];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint point = [self convertPoint:touchPoint toView:self.containerView];
    for (WJKeyBoardButton *button in self.containerView.subviews) {
        if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
            button.highlighted = NO;
        }

        [self removePopupView];

        if (CGRectContainsPoint(button.frame, point)) {
            if (button.model.type != WJKeyBoardButtonTypeNone) {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (WJKeyBoardButton *button in self.containerView.subviews) {

        if (button.model.type != WJKeyBoardButtonTypeShift && button.model.type != WJKeyBoardButtonTypeNone) {
            button.highlighted = NO;
        }
        [self removePopupView];
    }
}

#pragma mark - private methods
- (NSArray<NSNumber *> *)oneToNine {
    return @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
}

- (SEL)selectorFromModel:(WJKeyBoardButtonModel *)buttonModel {
    SEL selector = @selector(inputAction:);
    if (buttonModel.type == WJKeyBoardButtonTypeDelete) {
        selector = @selector(deleteAction:);
    } else if (buttonModel.type == WJKeyBoardButtonTypeToDigital) {
        selector = @selector(setUpNumberPadCanSwitchToLetter);
    } else if (buttonModel.type == WJKeyBoardButtonTypeToLetter) {
        selector = @selector(setUpLetterKeyBoard);
    } else if (buttonModel.type == WJKeyBoardButtonTypeShift) {
        selector = @selector(clickedShiftBtn:);
    } else if (buttonModel.type == WJKeyBoardButtonTypeDone) {
        selector = @selector(doneAction:);
    } else if (buttonModel.type == WJKeyBoardButtonTypeToASCII) {
        selector = @selector(setUpASCIIKeyBoard);
    }
    return selector;
}

/** 这样设计是为了能在界面上滑动和离开时响应事件 */
- (void)setButtonModelPropertyWithButton:(WJKeyBoardButton *)button {

    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.7;
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.enabled = NO;

    // 只有完成按钮样式不一样
    if (button.model.type == WJKeyBoardButtonTypeDone) {
        button.model.titleColor = self.theme.doneButtonTitleColor;
        button.model.highlightTitleColor = self.theme.doneButtonHighlightTitleColor;
        button.model.bgColor = self.theme.doneButtonBgColor;
        button.model.highlightBgColor = self.theme.doneButtonHighlightBgColor;
        button.model.selectedBgColor = self.theme.doneButtonHighlightBgColor;
    } else if (button.model.isFunctional) {
        button.model.titleColor = self.theme.buttonTitleColor;
        button.model.highlightTitleColor = self.theme.buttonTitleHighlightColor;
        button.model.bgColor = self.theme.funcButtonBgColor;
        button.model.highlightBgColor = self.theme.funcButtonHighlightBgColor;
        button.model.selectedBgColor = self.theme.funcButtonSelectedBgColor;
        
        if (button.model.type == WJKeyBoardButtonTypeShift) {
            button.selected = self.isCapital;
        }
    } else {
        button.model.titleColor = self.theme.buttonTitleColor;
        button.model.highlightTitleColor = self.theme.buttonTitleHighlightColor;
        button.model.bgColor = self.theme.buttonBgColor;
        button.model.highlightBgColor = self.theme.buttonHighlightBgColor;
        button.model.selectedBgColor = self.theme.buttonSelectedBgColor;
    }
    // 默认不高亮，触发 set 方法
    button.highlighted = NO;
}

/** 添加或更新预览 View */
- (void)addOrUpdatePopupViewForButton:(WJKeyBoardButton *)button {

    if (self.disablePreviewViewEffect) return;

    if (!self.popupLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = button.titleLabel.font;
        label.textColor = button.titleLabel.textColor;
        label.backgroundColor = self.theme.buttonHighlightBgColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self bringSubviewToFront:label];
        self.popupLabel = label;
    }
    self.popupLabel.text = button.model.showText;
    CGRect buttonFrame = [self.containerView convertRect:button.frame toView:self];

    CGFloat HMargin = 2;
    [self.popupLabel wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
        CGFloat width = button.width + 2 * HMargin;
        make.width.wj_equalTo(width);
        make.height.wj_equalTo(button.height * width / button.width);
        make.bottom.wj_equalTo(buttonFrame.origin.y);
        make.left.wj_equalTo(buttonFrame.origin.x - HMargin);
    }];
    [self.popupLabel setRoundedCorners:UIRectCornerAllCorners radius:5];
}

/** 移除预览层 */
- (void)removePopupView {
    if (self.disablePreviewViewEffect) return;

    if (self.popupLabel) {
        [self.popupLabel removeFromSuperview];
        self.popupLabel = nil;
    }
}

/** 数组乱序 */
static NSMutableArray *resortedArrayWithRandomSort(NSMutableArray *array) {

    for (uint32_t i = (uint32_t)array.count - 1; i > 0; i--) {
        [array exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i + 1)];
    }
    return array;
}

#pragma mark - lazy load
/** @lazy 数字键盘配置 */
- (NSMutableArray<WJKeyBoardButtonModel *> *)numberPadConfigArr {
    if (!_numberPadConfigArr) {
        _numberPadConfigArr = [[NSMutableArray alloc] init];

        WJKeyBoardButtonModel *buttonModel;
        for (NSNumber *number in [self oneToNine]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:number.stringValue value:number.stringValue type:WJKeyBoardButtonTypeDigital];
            [_numberPadConfigArr addObject:buttonModel];
        }

        if (self.isNumberPadWithPoint) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"." value:@"." type:WJKeyBoardButtonTypeDigital];
        } else {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeNone];
        }
        [_numberPadConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"0" value:@"0" type:WJKeyBoardButtonTypeDigital];
        [_numberPadConfigArr addObject:buttonModel];

        if (self.isRandom) {
            _numberPadConfigArr = resortedArrayWithRandomSort(_numberPadConfigArr);
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeDelete];
        buttonModel.isFunctional = YES;
        [_numberPadConfigArr addObject:buttonModel];
    }
    return _numberPadConfigArr;
}

/** @lazy 可以切换到字母键盘的数字键盘 */
- (NSMutableArray<WJKeyBoardButtonModel *> *)numberPadCanSwitchToLetterConfigArr {
    if (!_numberPadCanSwitchToLetterConfigArr) {
        _numberPadCanSwitchToLetterConfigArr = [[NSMutableArray alloc] init];
        WJKeyBoardButtonModel *buttonModel;
        for (NSNumber *number in [self oneToNine]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:number.stringValue value:number.stringValue type:WJKeyBoardButtonTypeDigital];
            [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"abc" value:@"" type:WJKeyBoardButtonTypeToLetter];
        buttonModel.isFunctional = YES;
        [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"0" value:@"0" type:WJKeyBoardButtonTypeDigital];
        [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];

        if (self.isNumberPadWithPoint) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"." value:@"." type:WJKeyBoardButtonTypeASCII];
        } else {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeNone];
        }
        [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];

        if (self.isRandom) {
            _numberPadCanSwitchToLetterConfigArr = resortedArrayWithRandomSort(_numberPadCanSwitchToLetterConfigArr);
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeDelete];
        buttonModel.isFunctional = YES;
        [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:self.theme.doneButtonName value:@"" type:WJKeyBoardButtonTypeDone];
        [_numberPadCanSwitchToLetterConfigArr addObject:buttonModel];
    }
    return _numberPadCanSwitchToLetterConfigArr;
}

/** 字母键盘 */
- (NSMutableArray<WJKeyBoardButtonModel *> *)letterKeyBoardConfigArr {
    if (!_letterKeyBoardConfigArr) {
        _letterKeyBoardConfigArr = [[NSMutableArray alloc] init];
        WJKeyBoardButtonModel *buttonModel;
        for (NSString *string in @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:string value:string type:WJKeyBoardButtonTypeLetter];
            [_letterKeyBoardConfigArr addObject:buttonModel];
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeShift];
        buttonModel.isFunctional = YES;
        [_letterKeyBoardConfigArr addObject:buttonModel];

        for (NSString *string in @[@"z", @"x", @"c", @"v", @"b", @"n", @"m"]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:string value:string type:WJKeyBoardButtonTypeLetter];
            [_letterKeyBoardConfigArr addObject:buttonModel];
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeDelete];
        buttonModel.isFunctional = YES;
        [_letterKeyBoardConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"123" value:@"" type:WJKeyBoardButtonTypeToDigital];
        buttonModel.isFunctional = YES;
        [_letterKeyBoardConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@" " type:WJKeyBoardButtonTypeBlank];
        [_letterKeyBoardConfigArr addObject:buttonModel];

        if (self.isLetterPadCanSwitchToASCII) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"#+" value:@"" type:WJKeyBoardButtonTypeToASCII];
            buttonModel.isFunctional = YES;
            [_letterKeyBoardConfigArr addObject:buttonModel];
        }

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:self.theme.doneButtonName value:@"" type:WJKeyBoardButtonTypeDone];
        [_letterKeyBoardConfigArr addObject:buttonModel];
    }
    return _letterKeyBoardConfigArr;
}

/** @lazy 特殊字符键盘 */
- (NSMutableArray<WJKeyBoardButtonModel *> *)asciiKeyBoardConfigArr {
    if (!_asciiKeyBoardConfigArr) {
        _asciiKeyBoardConfigArr = [[NSMutableArray alloc] init];
        WJKeyBoardButtonModel *buttonModel;
        for (NSString *string in @[@"!", @"@", @"#", @"$", @"%", @"^", @"&", @"*", @"(", @")", @"'", @"\"", @"=", @"_", @":", @";", @"?", @"~", @"|", @"·", @"+", @"-", @"\\", @"/", @"[", @"]", @"{", @"}"]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:string value:string type:WJKeyBoardButtonTypeLetter];
            [_asciiKeyBoardConfigArr addObject:buttonModel];
        }
        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"" value:@"" type:WJKeyBoardButtonTypeDelete];
        buttonModel.isFunctional = YES;
        [_asciiKeyBoardConfigArr addObject:buttonModel];

        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"123" value:@"" type:WJKeyBoardButtonTypeToDigital];
        buttonModel.isFunctional = YES;
        [_asciiKeyBoardConfigArr addObject:buttonModel];

        for (NSString *string in @[@",", @".", @"<", @">", @"€", @"£", @"¥"]) {
            buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:string value:string type:WJKeyBoardButtonTypeLetter];
            [_asciiKeyBoardConfigArr addObject:buttonModel];
        }
        buttonModel = [WJKeyBoardButtonModel modelWithIsCapital:NO showText:@"AB" value:@"" type:WJKeyBoardButtonTypeToLetter];
        buttonModel.isFunctional = YES;
        [_asciiKeyBoardConfigArr addObject:buttonModel];
    }
    return _asciiKeyBoardConfigArr;
}
@end
