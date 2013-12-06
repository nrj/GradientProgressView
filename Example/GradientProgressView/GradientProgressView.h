//
//  GradientProgressView.h
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientProgressView : UIView {
    
    CALayer *maskLayer;
}

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
@property (nonatomic, readwrite, assign) CGFloat progress;

- (void)startAnimating;
- (void)stopAnimating;

@end