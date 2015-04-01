//
//  XWTapDetectingImageView.m
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import "XWTapDetectingImageView.h"

@implementation XWTapDetectingImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch
{
    if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)]) {
        [_tapDelegate imageView:self singleTapDetected:touch];
    }
}

- (void)handleDoubleTap:(UITouch *)touch
{
    if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)]) {
        [_tapDelegate imageView:self doubleTapDetected:touch];
    }
}

@end
