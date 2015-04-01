//
//  ViewController.m
//  XWZoomingImageDemo
//
//  Created by sutar on 4/1/15.
//  Copyright (c) 2015 Xin Wang. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+XWZooming.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZoomingImage Demo";
    
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.f - 100.f, 100.f, 200.f, 200.f)];
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    photoImageView.image = [UIImage imageNamed:@"photo.jpg"];
    
    // add zooming
    [photoImageView xw_addZoomingView];
    
    [self.view addSubview:photoImageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
