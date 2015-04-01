//
//  XWTapDetectingView.m
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import "XWTapDetectingView.h"

@implementation XWTapDetectingView

- (id)init {
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 2:
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleDoubleTap:(UITouch *)touch
{
    if ([_tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)]) {
        [_tapDelegate view:self doubleTapDetected:touch];
    }
}


@end
