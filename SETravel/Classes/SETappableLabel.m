//
//  SETappableLabel.m
//  SETravel
//
//  Created by Sam Chen on 8/18/22.
//

#import "SETappableLabel.h"
#import <CoreText/CoreText.h>

@implementation SEBaseLabel

- (instancetype)init {
    self = [super init];
    NSLog(@"SEBaseLabel %s", __FUNCTION__);
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"SEBaseLabel before spuer %s", __FUNCTION__);
    self = [super initWithFrame:frame];
    NSLog(@"SEBaseLabel after spuer %s", __FUNCTION__);
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.userInteractionEnabled = YES;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    NSLog(@"SEBaseLabel %s", __FUNCTION__);
}


@end

@interface SETappableLabel () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSMutableDictionary<NSValue *, NSString *> *tappableDictionary;

@end

@implementation SETappableLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:self.tap];
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    NSLog(@"SETappableLabel %s", __FUNCTION__);
}

- (BOOL)isValidRange:(NSRange)range {
    if (self.text.length <= 0 || range.length <= 0 || range.location < 0) {
        return NO;
    }
    if ((range.location + range.length) > self.text.length) {
        return NO;
    }
    return YES;
}

- (void)addTapActionForRange:(NSRange)range {
    if (self.text.length && [self isValidRange:range]) {
        NSString *substring = [self.text substringWithRange:range];
        if (substring) {
            [self.tappableDictionary setObject:substring forKey:[NSValue valueWithRange:range]];
        }
    }
}

- (void)addTapActionForSubstring:(NSString *)substring {
    if (substring.length) {
        NSArray<NSValue *> *ranges = [self rangesOfSubstring:substring inString:self.text];
        for (NSValue *range in ranges) {
            [self addTapActionForRange:[range rangeValue]];
        }
    }
}

- (void)addTapActionForSubstrings:(NSArray<NSString *> *)substrings {
    for (NSString *substring in substrings) {
        [self addTapActionForSubstring:substring];
    }
}

- (void)removeAllTappableRange {
    [self.tappableDictionary removeAllObjects];
}

- (NSArray<NSValue *> *)rangesOfSubstring:(NSString *)substring inString:(NSString *)string {
    NSError *error = NULL;
    NSString *regex = [NSString stringWithFormat:@"\\b%@", substring];
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    NSArray *matches = [regExpression matchesInString:string options:NSMatchingAnchored range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in matches) {
        [ranges addObject:[NSValue valueWithRange:match.range]];
    }
    return [ranges copy];
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(tappableLabel:tapAtSubstring:range:)]) {
        CGPoint location = [tap locationInView:self];
        NSValue *rangeValue = [self tappableTextRangeForPoint:location];
        if (rangeValue && self.tappableDictionary[rangeValue]) {
            [self.delegate tappableLabel:self
                          tapAtSubstring:self.tappableDictionary[rangeValue]
                                   range:[rangeValue rangeValue]];
        }
    }
}

- (NSValue *)tappableTextRangeForPoint:(CGPoint)point {
    NSInteger indexOfCharacter = [self characterIndexForPoint:point];
    if (indexOfCharacter != kCFNotFound) {
        for (NSValue *rangeValue in self.tappableDictionary) {
            NSRange range = [rangeValue rangeValue];
            if (NSLocationInRange(indexOfCharacter, range)) {
                return rangeValue;
            }
        }
    }
    return nil;
}

- (NSInteger)characterIndexForPoint:(CGPoint)point {
    CGRect boundingBox = [self textBoundingBox];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, boundingBox);
    if (!self.attributedText) {
        return 0;
    }
    NSParagraphStyle *paragraphStyle = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    if (!paragraphStyle) {
        paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    }
    NSMutableParagraphStyle *mParagraphStyle = [paragraphStyle mutableCopy];
    mParagraphStyle.alignment = self.textAlignment;
    NSMutableAttributedString *mAttrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [mAttrText addAttribute:NSParagraphStyleAttributeName value:mParagraphStyle range:NSMakeRange(0, mAttrText.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mAttrText);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, NULL);
    CGFloat verticalPadding = (CGRectGetHeight(self.frame) - CGRectGetHeight(boundingBox)) / 2;
    CGFloat horizontalPadding = (CGRectGetWidth(self.frame) - CGRectGetWidth(boundingBox)) / 2;
    CGFloat ctPointX = 0;
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
        case NSTextAlignmentJustified:
            ctPointX = point.x - horizontalPadding;
            break;
        case NSTextAlignmentLeft:
            ctPointX = point.x;
            break;
        case NSTextAlignmentRight:
            ctPointX = point.x - horizontalPadding * 2;
            break;
        case NSTextAlignmentNatural: {
            if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
                ctPointX = point.x - horizontalPadding * 2;
            } else {
                ctPointX = point.x;
            }
        }
            break;
        default:
            break;
    }
    
    CGFloat ctPointY = CGRectGetHeight(boundingBox) - (point.y - verticalPadding);
    CGPoint ctPoint = CGPointMake(ctPointX, ctPointY);
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint *lineOrigins = malloc(sizeof(CGPoint)*CFArrayGetCount(lines));
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0,0), lineOrigins);
    NSInteger indexOfCharacter = kCFNotFound;
    for(CFIndex index = 0; index < CFArrayGetCount(lines); index++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat lineWidth = CTLineGetBoundsWithOptions(line, kCTLineBoundsExcludeTypographicLeading).size.width;
        CGPoint origin = lineOrigins[index];
        if (ctPoint.x >= origin.x &&
            ctPoint.x <= (origin.x+lineWidth) &&
            ctPoint.y >= (origin.y-descent) &&
            ctPoint.y <= (origin.y+ascent+descent+leading)) {
            indexOfCharacter = CTLineGetStringIndexForPosition(line, CGPointMake(ctPoint.x-origin.x, ctPoint.y));
            break;
        }
    }
    free(lineOrigins);
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(framesetter);
    return indexOfCharacter;
}

- (CGRect)textBoundingBox {
    if (!self.attributedText.length) {
        return CGRectZero;
    }
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.size = self.bounds.size;
    [layoutManager addTextContainer:textContainer];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    [textStorage addLayoutManager:layoutManager];
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGFloat boxHeight = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.attributedText);
    CGRect box = CGRectMake(0, 0, CGRectGetWidth(textBoundingBox), CGFLOAT_MAX);
    CFIndex startIndex = 0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lineArray);
    if (lineCount > self.numberOfLines && self.numberOfLines != 0) {
        lineCount = self.numberOfLines;
    }
    CGFloat fontHeight, ascent, descent, leading;
    for (CFIndex index = 0; index < lineCount; index++) {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, index);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        fontHeight = ascent + descent + leading;
        boxHeight += fontHeight;
    }
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    box.size.height = boxHeight;
    return box;
}

#pragma mark - setter/getter

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(didTap:)];
        _tap.delegate = self;
    }
    return _tap;
}

- (NSMutableDictionary<NSValue *,NSString *> *)tappableDictionary {
    if (!_tappableDictionary) {
        _tappableDictionary = [NSMutableDictionary dictionary];
    }
    return _tappableDictionary;
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL shouldReceive = NO;
    if (![gestureRecognizer isKindOfClass:UITapGestureRecognizer.class]) {
        return shouldReceive;
    }
    CGPoint location = [touch locationInView:self];
    NSValue *rangeValue = [self tappableTextRangeForPoint:location];
    if (rangeValue) {
        shouldReceive = YES;
    }
    return shouldReceive;
}

@end
