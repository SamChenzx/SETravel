//
//  ZMBasicPlusPanel.m
//  iZipow
//
//  Created by Sam Chen on 6/26/23.
//  Copyright © 2023 Zoom Video Communications, Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error ARC (-fobjc-arc) is required to build this code.
#endif

static const CGFloat ZMBPHostPanelHeight = 160.0f;
static const CGFloat ZMBPParticipantPanelHeight = 70.0f;
static const CGFloat ZMBPIconHeight = 24.0f;

#import "ZMBasicPlusPanel.h"
#import "UIColor+Hex.h"

@interface ZMBasicPlusPanel ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) ZMBasicPlusAction action;

@end

#pragma clang diagnostic push
#pragma clang diagnostic error "-Wprotocol"
#pragma clang diagnostic error "-Wobjc-protocol-property-synthesis"
@implementation ZMBasicPlusPanel
#pragma clang diagnostic pop

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.iconImageView];
    [self addSubview:self.mainTitle];
    [self addSubview:self.subTitle];
    [self addSubview:self.button];
}

- (void)didTapButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didTapWithAction:)]) {
        [self.delegate didTapWithAction:self.action];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)slideToStyle:(ZMMeetingPanelStyle)style {
    
}

#pragma mark - setter/getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_extend_meeting"]];
    }
    return _iconImageView;
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _mainTitle.textColor = [UIColor staticColorWithHex:0xF5F5F5 alpha:1];
        _mainTitle.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitle.textColor = [UIColor staticColorWithHex:0xF5F5F5 alpha:1];
        _subTitle.font = [UIFont systemFontOfSize:12];
        _subTitle.numberOfLines = 2;
    }
    return _subTitle;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 10.0f;
        _button.backgroundColor = [UIColor staticColorWithHex:0x0E72ED alpha:1];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _button.titleLabel.textColor = [UIColor staticColorWithHex:0xF5F5F5 alpha:1];
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end

