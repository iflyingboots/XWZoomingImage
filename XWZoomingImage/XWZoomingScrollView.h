//
//  XWZoomingScrollView.h
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWZoomingScrollView : UIScrollView
@property (nonatomic, weak) UIImageView *thumbnailImageView;

- (void)zoomIn;
- (void)zoomOut;

@end
