//
//  HDKeyBoardTheme.m
//  HDKeyBoard
//
//  Created by VanJay on 2019/5/18.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "HDKeyBoardTheme.h"
#import "HDKeyBoardDefine.h"
#import "UIImage+Color.h"

@implementation HDKeyBoardButtonModel
+ (instancetype)modelWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type {
    return [[self alloc] initWithIsCapital:isCapital showText:showText value:value type:type];
}

- (instancetype)initWithIsCapital:(BOOL)isCapital showText:(NSString *)showText value:(NSString *)value type:(HDKeyBoardButtonType)type {
    if (self = [super init]) {
        self.isCapital = isCapital;
        self.showText = showText;
        self.value = value;
        self.type = type;
    }
    return self;
}
@end

@interface HDKeyBoardButton ()
@end

@implementation HDKeyBoardButton
#pragma mark - life cycle
+ (instancetype)keyBoardButtonWithModel:(HDKeyBoardButtonModel *)model {
    return [[self alloc] initKeyBoardButtonWithModel:model];
}

- (instancetype)initKeyBoardButtonWithModel:(HDKeyBoardButtonModel *)model {
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
        if (self.model.type == HDKeyBoardButtonTypeLetter) {
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
- (void)setModel:(HDKeyBoardButtonModel *)model {
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
}
@end

@implementation HDKeyBoardTheme

- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        self.backgroundColor = HexColor(0x343b4d);
        self.buttonBgColor = WJColor(93, 102, 127, 0.4);
        self.buttonSelectedBgColor = WJColor(93, 102, 127, 1);
        self.buttonHighlightBgColor = WJColor(93, 102, 127, 1);
        self.digitalButtonFont = [UIFont fontWithName:@"PingFang SC" size:23];
        self.letterButtonFont = [UIFont fontWithName:@"Helvetica Neue" size:22];
        self.buttonTitleColor = UIColor.whiteColor;
        self.buttonTitleHighlightColor = UIColor.whiteColor;
        self.enterpriseLabelFont = [UIFont fontWithName:@"PingFang SC" size:15];
        self.enterpriseShowStyle = HDKeyBoardEnterpriseInfoShowTypeImageLeft;
        self.enterpriseMargin = 10;
        self.enterpriseLabelColor = HexColor(0xadb6c8);
        self.deleteButtonImage = @"keyboard_delete";
        self.shiftButtonImage = @"keyboard_shift";
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
