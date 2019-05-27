//
//  WJKeyBoardTheme.m
//  customer
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "WJKeyBoardTheme.h"
#import "WJKeyBoardDefine.h"
#import "UIImage+Color.h"
#import "WJFrameLayout.h"

@implementation WJKeyBoardButtonModel
+ (instancetype)modelWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(WJKeyBoardButtonType)type {
    return [[self alloc] initWithIsCapital:isCapital showText:showText value:value type:type];
}

- (instancetype)initWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(WJKeyBoardButtonType)type {
    if (self = [super init]) {
        self.isCapital = isCapital;
        self.showText = showText;
        self.value = value;
        self.type = type;
    }
    return self;
}
@end

@interface WJKeyBoardButton ()
@property (nonatomic, strong) UIView *redPointView;  ///< 红点
@end

@implementation WJKeyBoardButton
#pragma mark - life cycle
+ (instancetype)keyBoardButtonWithModel:(WJKeyBoardButtonModel *)model {
    return [[self alloc] initKeyBoardButtonWithModel:model];
}

- (instancetype)initKeyBoardButtonWithModel:(WJKeyBoardButtonModel *)model {
    if (self = [super init]) {
        self.model = model;

        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self hd_updateTitle];
}

#pragma mark - public methods
- (void)hd_updateTitle {
    if (self.model) {
        if (self.model.type == WJKeyBoardButtonTypeLetter) {
            if (self.model.isCapital) {
                [self setTitle:[self.model.showText uppercaseString] forState:UIControlStateNormal];
                self.model.value = [self.model.value uppercaseString];
                self.model.showText = [self.model.value uppercaseString];
            } else {
                [self setTitle:[self.model.showText lowercaseString] forState:UIControlStateNormal];
                self.model.value = [self.model.value lowercaseString];
                self.model.showText = [self.model.value lowercaseString];
            }
        } else {
            [self setTitle:self.model.showText forState:UIControlStateNormal];
        }
    }
}

#pragma mark - getters and setters
- (void)setModel:(WJKeyBoardButtonModel *)model {
    _model = model;

    [self hd_updateTitle];
}

#pragma mark - getters and setters
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (highlighted) {
        [self setTitleColor:self.model.highlightTitleColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:self.model.highlightBgColor] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:self.model.titleColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:self.model.bgColor] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self setBackgroundImage:[UIImage imageWithColor:self.model.selectedBgColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageWithColor:self.model.bgColor] forState:UIControlStateNormal];
    }
    if (self.model.type == WJKeyBoardButtonTypeShift) {
        selected ? [self addRedPoint] : [self removeRedPoint];
    }
}

- (void)addRedPoint {
    _redPointView = [[UIView alloc] init];
    _redPointView.backgroundColor = HexColor(0xf83460);
    _redPointView.frame = CGRectMake(5, 5, kRealWidth(6), kRealWidth(6));
    [self addSubview:_redPointView];
    [_redPointView setRoundedCorners:UIRectCornerAllCorners radius:_redPointView.bounds.size.height * 0.5];
}

- (void)removeRedPoint {
    if (self.redPointView) {
        [self.redPointView removeFromSuperview];
        self.redPointView = nil;
    }
}

@end

@implementation WJKeyBoardTheme

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        self.backgroundColor = HexColor(0x343b4d);
        self.buttonBgColor = WJColor(93, 102, 127, 0.4);
        self.buttonSelectedBgColor = WJColor(93, 102, 127, 1);
        self.buttonHighlightBgColor = WJColor(93, 102, 127, 1);
        self.funcButtonBgColor = WJColor(93, 102, 127, 1);
        self.funcButtonHighlightBgColor = WJColor(93, 102, 127, 0.4);
        self.funcButtonSelectedBgColor = WJColor(93, 102, 127, 0.4);
        self.digitalButtonFont = [UIFont fontWithName:@"PingFang SC" size:23];
        self.letterButtonFont = [UIFont fontWithName:@"Helvetica Neue" size:22];
        self.buttonTitleColor = UIColor.whiteColor;
        self.buttonTitleHighlightColor = UIColor.whiteColor;
        self.enterpriseLabelFont = [UIFont fontWithName:@"PingFang SC" size:15];
        self.enterpriseShowStyle = WJKeyBoardEnterpriseInfoShowTypeImageLeft;
        self.enterpriseMargin = 10;
        self.enterpriseLabelColor = HexColor(0xadb6c8);
        self.deleteButtonImage = @"keyboard_delete";
        self.shiftButtonImage = @"keyboard_shift";
        self.shiftButtonSelectedImage = @"keyboard_shift_selected";
        self.enterpriseText = @"- 安全键盘 -";
        self.doneButtonName = @"Done";
        self.doneButtonTitleColor = UIColor.whiteColor;
        self.doneButtonHighlightTitleColor = UIColor.whiteColor;
        self.doneButtonBgColor = WJColor(248, 52, 96, 1);
        self.doneButtonHighlightBgColor = WJColor(248, 52, 96, 0.5);
    }
    return self;
}
@end
