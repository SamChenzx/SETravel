//
//  SEHTMLTextView.m
//  SETravel_Example
//
//  Created by Sam Chen on 2024/7/4.
//  Copyright © 2024 chenzhixiang. All rights reserved.
//

#import "SEHTMLTextView.h"
#import <WebKit/WebKit.h>

@interface SEHTMLTextView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *titleTextView;

@end

@implementation SEHTMLTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleTextView];
    }
    return self;
}

- (void)setTabDescription:(NSString *)tabDescription {
    _tabDescription = tabDescription;
    NSMutableAttributedString *htmlString = [[NSMutableAttributedString alloc] initWithString:@""];
    [NSMutableAttributedString loadFromHTMLWithString:tabDescription options:@{
        NSDocumentTypeDocumentOption : NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentOption : @(NSUTF8StringEncoding)
    } completionHandler:^(NSAttributedString * _Nullable attrString, NSDictionary<NSAttributedStringDocumentAttributeKey,id> * _Nullable attrDict, NSError * _Nullable error) {
        CGFloat padding = 16.0f;
//        dispatch_async(dispatch_get_main_queue(), ^{
            [htmlString appendAttributedString:attrString];
            [htmlString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, htmlString.length)];
            [htmlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, htmlString.length)];
            self.titleTextView.attributedText = htmlString;
            CGSize textViewSize = [htmlString boundingRectWithSize:CGSizeMake(self.bounds.size.width-padding*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            CGFloat textViewHeight = textViewSize.height;
            self.titleTextView.frame = CGRectMake(padding, padding, self.bounds.size.width-padding*2, textViewHeight);
            [self layoutIfNeeded];
//                [self setNeedsLayout];
//        });
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"Sam dev: %s %@", __FUNCTION__, textView);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 16.0f;
    CGSize textViewSize = self.titleTextView.contentSize;
//    if (self.titleTextView.attributedText.length) {
//        textViewSize = [self.titleTextView.attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width - padding * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    }
    CGFloat textViewHeight = textViewSize.height;
    self.titleTextView.frame = CGRectMake(padding, padding, self.bounds.size.width-padding*2, textViewHeight);
//    [self.titleTextView sizeToFit];
}

- (UITextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] init];
        _titleTextView.backgroundColor = [UIColor.purpleColor colorWithAlphaComponent:0.5];
        _titleTextView.editable = NO;
        _titleTextView.selectable = YES;
        _titleTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _titleTextView.delegate = self;
    }
    return _titleTextView;
}

@end
