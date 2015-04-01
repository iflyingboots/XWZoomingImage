//
//  XWTapDetectingImageView.h
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol XWTapImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;

@end

@interface XWTapDetectingImageView : UIImageView

@property (nonatomic, weak) id <XWTapImageViewDelegate> tapDelegate;

@end
