//
//  XWTapDetectingView.h
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWTapDetectingView <NSObject>

@optional

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end

@interface XWTapDetectingView : UIView

@property (nonatomic, weak) id <XWTapDetectingView> tapDelegate;
@end
