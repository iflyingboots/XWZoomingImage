//
//  UIImageView+XWZooming.m
//  XWZoomingImage
//
//  Created by sutar on 4/1/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import "UIImageView+XWZooming.h"
#import "XWZoomingScrollView.h"
#import <objc/runtime.h>

@interface UIImageView()
@property (nonatomic, strong) XWZoomingScrollView *zoomingScrollView;
@end

@implementation UIImageView (XWZooming)

static char XWZoomingScrollViewKey;

- (void)xw_addZoomingView
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThumbnail)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Setter and getter
- (void)setZoomingScrollView:(XWZoomingScrollView *)zoomingScrollView
{
    objc_setAssociatedObject(self, &XWZoomingScrollViewKey, zoomingScrollView, OBJC_ASSOCIATION_ASSIGN);
}

- (XWZoomingScrollView *)zoomingScrollView
{
    return objc_getAssociatedObject(self, &XWZoomingScrollViewKey);
}

#pragma mark - Private

- (void)tapThumbnail
{
    if (!self.zoomingScrollView) {
        XWZoomingScrollView *zoomingScrollView = [[XWZoomingScrollView alloc] init];
        self.zoomingScrollView = zoomingScrollView;
        self.zoomingScrollView.frame = [UIScreen mainScreen].bounds;
        [self.window addSubview: self.zoomingScrollView];
        self.zoomingScrollView.thumbnailImageView = self;
    }

    [self.zoomingScrollView zoomIn];
}

@end
