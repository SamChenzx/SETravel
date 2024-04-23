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

static const CGFloat ZMBPIconHeight = 24.0f;
static const CGSize ZMBPButtonSize = {313.0f, 40.0f};

#import "ZMBasicPlusPanel.h"
#import "UIColor+Hex.h"

@interface ZMBasicPlusPanel ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) ZMBasicPlusAction action;
@property (nonatomic, assign) ZMBasicPlusStatus status;

@end

@implementation ZMBasicPlusPanel

- (instancetype)initWithFrame:(CGRect)frame status:(ZMBasicPlusStatus)status {
    self = [super initWithFrame:frame];
    _status = status;
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
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
    self.iconImageView.hidden = YES;
    self.mainTitle.hidden = YES;
    self.subTitle.hidden = YES;
    self.button.hidden = YES;
    self.button.layer.borderColor = [UIColor clearColor].CGColor;
    self.button.layer.borderWidth = 0;
    self.button.backgroundColor = [UIColor staticColorWithHex:0x0E72ED alpha:1];
    [self.button setTitle:l10nString(@"LN_MEET_BASICPLUS_PANEL_BUTTON_528113") forState:UIControlStateNormal];
    switch (self.status) {
        case ZMBasicPlusStatusEarlyExtend:
            self.iconImageView.hidden = NO;
            self.iconImageView.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPIconHeight)/2, 30, ZMBPIconHeight, ZMBPIconHeight);
            self.subTitle.hidden = NO;
            self.subTitle.frame = CGRectMake(0, 65, CGRectGetWidth(self.frame), 33);
            self.button.hidden = NO;
            self.button.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPButtonSize.width)/2, 112, ZMBPButtonSize.width, ZMBPButtonSize.height);
            break;
        case ZMBasicPlusStatusLateExtend:
            [self attachIconWithMainTitle];
            self.mainTitle.hidden = NO;
            self.mainTitle.frame = CGRectMake(0, 34, CGRectGetWidth(self.frame), 24);
            self.subTitle.hidden = NO;
            self.subTitle.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 32);
            self.button.hidden = NO;
            self.button.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPButtonSize.width)/2, 112, ZMBPButtonSize.width, ZMBPButtonSize.height);
            break;
        case ZMBasicPlusStatusCancel:
            [self attachIconWithMainTitle];
            self.mainTitle.hidden = NO;
            self.mainTitle.frame = CGRectMake(0, 34, CGRectGetWidth(self.frame), 24);
            self.subTitle.hidden = NO;
            self.subTitle.frame = CGRectMake(0, 74, CGRectGetWidth(self.frame), 16);
            self.button.hidden = NO;
            self.button.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPButtonSize.width)/2, 112, ZMBPButtonSize.width, ZMBPButtonSize.height);
            [self.button setTitle:l10nString(@"Cancel") forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor staticColorWithHex:0x131619 alpha:1];
            self.button.layer.borderColor = [UIColor staticColorWithHex:0x6E7680 alpha:1].CGColor;
            self.button.layer.borderWidth = 1;
            break;
        case ZMBasicPlusStatusExtended:
            self.iconImageView.hidden = NO;
            self.iconImageView.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPIconHeight)/2, 30, ZMBPIconHeight, ZMBPIconHeight);
            self.mainTitle.hidden = NO;
            self.mainTitle.frame = CGRectMake(0, 82, CGRectGetWidth(self.frame), 24);
            self.subTitle.hidden = NO;
            self.subTitle.frame = CGRectMake(0, 116, CGRectGetWidth(self.frame), 16);
            break;
        case ZMBasicPlusStatusEnding:
            self.iconImageView.hidden = NO;
            self.iconImageView.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPIconHeight)/2, 57, ZMBPIconHeight, ZMBPIconHeight);
            self.mainTitle.hidden = NO;
            self.mainTitle.frame = CGRectMake(0, 92, CGRectGetWidth(self.frame), 24);
            break;
        case ZMBasicPlusStatusUnavailable:
            self.iconImageView.hidden = NO;
            self.iconImageView.frame = CGRectMake((CGRectGetWidth(self.frame)-ZMBPIconHeight)/2, 64, ZMBPIconHeight, ZMBPIconHeight);
            self.subTitle.hidden = NO;
            self.subTitle.frame = CGRectMake(0, 98, CGRectGetWidth(self.frame), 32);
            break;
    }
}

- (void)attachIconWithMainTitle {
    NSDictionary *attributes = @{
        NSFontAttributeName : self.mainTitle.font,
        NSForegroundColorAttributeName : self.mainTitle.textColor
    };
    NSString *originText = self.mainTitle.text;
    if (!originText) {
        return;
    }
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:originText
                                                                                    attributes:attributes];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"icon_extend_meeting"];
    CGFloat offset = -(ZMBPIconHeight - self.mainTitle.font.pointSize - self.mainTitle.font.descender)/2;
    attachment.bounds = CGRectMake(0, offset, ZMBPIconHeight, ZMBPIconHeight);
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attachment];
    if (mAttrString.length) {
        NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:5]}];
        [mAttrString insertAttributedString:space atIndex:0];
        [mAttrString insertAttributedString:imageString atIndex:0];
    }
    self.mainTitle.attributedText = mAttrString;
    self.mainTitle.accessibilityLabel = originText;
}

- (void)updateWithDataSource:(id<ZMBasicPlusPanelDataSource>)data {
    self.status = data.status;
    self.mainTitle.text = data.mainTitle;
    self.subTitle.text = data.subTitle;
    [self setNeedsLayout];
}

#pragma mark ZMMeetingPanelProtocol

- (NSArray<ZMMeetingPanelStyle> *)validStyles {
    return @[ZMMeetingPanelBottomStyle, ZMMeetingPanelTopStyle];
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
        _mainTitle.text = [NSString stringWithFormat:l10nString(@"LN_MEET_BASICPLUS_TIME_LEFT_528113"), @""];
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
        _subTitle.textAlignment = NSTextAlignmentCenter;
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

