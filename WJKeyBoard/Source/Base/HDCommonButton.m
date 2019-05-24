//
//  HDCommonButton.m
//  HDKeyBoard
//
//  Created by VanJay on 2019/4/18.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "HDCommonButton.h"
#import "WJFrameLayout.h"

@interface HDCommonButton ()
@property (nonatomic, strong) UIView *iconViewContainer;  ///< 图片 view 容器
@end

@implementation HDCommonButton
#pragma mark - life cycle
- (void)commonInit {
    // 默认
    _type = HDCommonButtonImageLLabelR;
    _textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textAlignment = _textAlignment;

    self.imageView.contentMode = UIViewContentModeCenter;
    self.adjustsImageWhenDisabled = NO;
    self.isTextAlignmentCenterToWhole = NO;
    self.clipsToBounds = YES;
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

#pragma mark - getters and setters
- (void)setType:(HDCommonButtonType)type {
    if (_type == type) return;

    _type = type;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;

    _textAlignment = textAlignment;

    self.titleLabel.textAlignment = textAlignment;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setImageViewEdgeInsets:(UIEdgeInsets)imageViewEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_imageViewEdgeInsets, imageViewEdgeInsets)) return;

    _imageViewEdgeInsets = imageViewEdgeInsets;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_labelEdgeInsets, labelEdgeInsets)) return;

    _labelEdgeInsets = labelEdgeInsets;

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setImageViewContainerColor:(UIColor *)imageViewContainerColor {
    if (_imageViewContainerColor == imageViewContainerColor) return;

    _imageViewContainerColor = imageViewContainerColor;

    [self.iconViewContainer removeFromSuperview];
    self.iconViewContainer = nil;
    _iconViewContainer = [[UIView alloc] init];
    _iconViewContainer.backgroundColor = imageViewContainerColor;
    [self insertSubview:_iconViewContainer belowSubview:self.imageView];

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat w = self.width, h = self.height;

    switch (_type) {
        case HDCommonButtonImageLLabelR: {
            [self.imageView sizeToFit];
            self.imageView.left = _imageViewEdgeInsets.left;
            self.imageView.centerY = h * 0.5;

            if (self.textAlignment == NSTextAlignmentCenter && self.isTextAlignmentCenterToWhole) {
                self.titleLabel.width = w - _labelEdgeInsets.right - _labelEdgeInsets.left;
                self.titleLabel.height = h;
                self.titleLabel.left = _labelEdgeInsets.left;
                self.titleLabel.centerY = h * 0.5;
            } else {
                self.titleLabel.width = w - self.imageView.right - _imageViewEdgeInsets.right - _labelEdgeInsets.left;
                self.titleLabel.height = h;
                self.titleLabel.left = self.imageView.right + _imageViewEdgeInsets.right + _labelEdgeInsets.left;
                self.titleLabel.centerY = h * 0.5;
            }

            break;
        }

        case HDCommonButtonImageRLabelL: {
            [self.imageView sizeToFit];
            self.imageView.left = w - self.imageView.width - _imageViewEdgeInsets.right;
            self.imageView.centerY = h * 0.5;

            if (self.textAlignment == NSTextAlignmentCenter && self.isTextAlignmentCenterToWhole) {
                self.titleLabel.width = w - _labelEdgeInsets.left - _labelEdgeInsets.right;
            } else {
                self.titleLabel.width = self.imageView.left - _imageViewEdgeInsets.left - _labelEdgeInsets.left - _labelEdgeInsets.right;
            }
            self.titleLabel.height = h;
            self.titleLabel.left = _labelEdgeInsets.left;
            self.titleLabel.centerY = h * 0.5;

            break;
        }
        case HDCommonButtonImageULabelD: {
            [self.titleLabel sizeToFit];
            CGFloat labelW = w - _labelEdgeInsets.left - _labelEdgeInsets.right;
            CGFloat labelH = self.titleLabel.height;
            self.titleLabel.frame = CGRectMake(_labelEdgeInsets.left, h - _labelEdgeInsets.bottom - labelH, labelW, labelH);

            [self.imageView sizeToFit];
            self.imageView.centerX = w * 0.5;
            self.imageView.centerY = self.titleLabel.top * 0.5;

            break;
        }
        case HDCommonButtonImageDLabelU: {
            [self.titleLabel sizeToFit];

            CGFloat labelW = w - _labelEdgeInsets.left - _labelEdgeInsets.right;
            CGFloat labelH = self.titleLabel.height;
            self.titleLabel.frame = CGRectMake(_labelEdgeInsets.left, _labelEdgeInsets.top, labelW, labelH);

            [self.imageView sizeToFit];
            self.imageView.centerX = w * 0.5;
            self.imageView.top = self.titleLabel.bottom + _labelEdgeInsets.bottom + _imageViewEdgeInsets.top;

            break;
        }

        default:
            break;
    }
    // 设置图片容器 frame
    if (_iconViewContainer) {
        if (_type == HDCommonButtonImageLLabelR) {
            _iconViewContainer.frame = CGRectMake(0, 0, self.imageView.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right, self.height);
        } else if (_type == HDCommonButtonImageRLabelL) {
            _iconViewContainer.frame = CGRectMake(self.imageView.left - self.imageViewEdgeInsets.left, 0, self.imageView.width + self.imageViewEdgeInsets.left + self.imageViewEdgeInsets.right, self.height);
        } else if (_type == HDCommonButtonImageULabelD) {
            _iconViewContainer.frame = CGRectMake(0, 0, self.width, self.imageView.height + +self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom);
        } else if (_type == HDCommonButtonImageDLabelU) {
            _iconViewContainer.frame = CGRectMake(0, self.imageView.top - self.imageViewEdgeInsets.top, self.width, self.imageView.height + self.imageViewEdgeInsets.top + self.imageViewEdgeInsets.bottom);
        }
    }
}
@end
