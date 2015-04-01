//
//  XWZoomingScrollView.m
//  XWZoomingImage
//
//  Created by sutar on 3/31/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//
//  Acknowledgements: some code from MWPhotoBrowser

#import "XWZoomingScrollView.h"
#import "XWTapDetectingView.h"
#import "XWTapDetectingImageView.h"

@interface XWZoomingScrollView() <XWTapDetectingView, XWTapImageViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) XWTapDetectingView *tapView;
@property (nonatomic, strong) XWTapDetectingImageView *photoImageView;
@property (nonatomic, assign) CGRect thumbnailOriginalFrame;

@end

@implementation XWZoomingScrollView

const CGFloat kAnimationDuration = .5f;

- (instancetype)init
{
    if (self = [super init]) {
        self.tapView = [[XWTapDetectingView alloc] initWithFrame:self.bounds];
        self.tapView.tapDelegate = self;
        self.tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.tapView];
        
        self.photoImageView = [[XWTapDetectingImageView alloc] initWithFrame:CGRectZero];
        self.photoImageView.tapDelegate = self;
        self.photoImageView.contentMode = UIViewContentModeCenter;
        [self addSubview: self.photoImageView];
        
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.hidden = YES;
        
    }
    
    return self;
}

#pragma mark - Public
- (void)zoomIn
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.thumbnailImageView.frame = self.photoImageView.frame;
    } completion:^(BOOL finished) {
        self.hidden = NO;
        self.thumbnailImageView.hidden = YES;
    }];
}

- (void)zoomOut
{
    self.thumbnailImageView.hidden = NO;
    self.hidden = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self setMaxMinZoomScalesForCurrentBounds];
        self.thumbnailImageView.frame = self.thumbnailOriginalFrame;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Setter
- (void)setThumbnailImageView:(UIImageView *)thumbnailImageView
{
    _thumbnailImageView = thumbnailImageView;
    self.thumbnailOriginalFrame = thumbnailImageView.frame;
    [self setPhoto:_thumbnailImageView.image];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    self.tapView.frame = self.bounds;
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.photoImageView.frame, frameToCenter))
        self.photoImageView.frame = frameToCenter;
}

#pragma mark - Action
- (CGFloat)initialZoomScaleWithMinScale {
    
    CGFloat zoomScale = self.minimumZoomScale;
    
    if (self.photoImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = self.photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_photoImageView.image == nil) return;
    
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
    CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }
    
    // Layout
    [self setNeedsLayout];
    
}


- (void)setPhoto:(UIImage *)img
{
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    _photoImageView.image = img;
    
    // Setup photo frame
    CGRect photoImageViewFrame;
    photoImageViewFrame.origin = CGPointZero;
    photoImageViewFrame.size = img.size;
    _photoImageView.frame = photoImageViewFrame;
    self.contentSize = photoImageViewFrame.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setNeedsLayout];
}

- (void)handleDoubleTap:(CGPoint)touchPoint
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Zoom
    if (self.zoomScale != self.minimumZoomScale) {
        
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
    }
}


#pragma mark - Delegate

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch
{
    [self performSelector:@selector(zoomOut) withObject:self afterDelay:.2f];
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch
{
    [self handleDoubleTap:[touch locationInView:imageView]];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch
{
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

@end
