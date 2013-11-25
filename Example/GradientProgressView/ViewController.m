//
//  ViewController.m
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgressView.h"

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 22.0f, CGRectGetWidth([[self view] bounds]), 1.0f);
    progressView = [[GradientProgressView alloc] initWithFrame:frame];
    
    UIView *view = [self view];
    [view setBackgroundColor:[UIColor blackColor]];
    [view addSubview:progressView];
    [progressView release];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Starts the moving gradient effect
    [progressView startAnimating];
    
    // Continuously updates the progress value using random values
    [self simulateProgress];
}

- (void)simulateProgress {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        CGFloat progress  = [progressView progress] + increment;
        [progressView setProgress:progress];
        if (progress < 1.0) {
            
            [self simulateProgress];
        }
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
