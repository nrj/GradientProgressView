//
//  GradientProgressView.m
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import "GradientProgressView.h"

@implementation GradientProgressView

@synthesize animating, progress;

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        // Use a horizontal gradient
        
        CAGradientLayer *layer = (id)[self layer];
        [layer setStartPoint:CGPointMake(0.0, 0.5)];
        [layer setEndPoint:CGPointMake(1.0, 0.5)];
        
        // Create the gradient colors using hues in 5 degree increments
        
        NSMutableArray *colors = [NSMutableArray array];
        for (NSInteger deg = 0; deg <= 360; deg += 5) {
            
            UIColor *color;
            color = [UIColor colorWithHue:1.0 * deg / 360.0
                               saturation:1.0
                               brightness:1.0
                                    alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [layer setColors:[NSArray arrayWithArray:colors]];
        
        // Create another layer to use as a mask. The width of this layer will
        // be modified to reflect the current progress value.
        
        maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [maskLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
        [layer setMask:maskLayer];
    }
    return self;
}

+ (Class)layerClass {
    
    // Tells UIView to use CAGradientLayer as our backing layer
    
    return [CAGradientLayer class];
}

- (void)setProgress:(CGFloat)value {
    
    if (progress != value) {
        
        // progress values go from 0.0 to 1.0
        
        progress = MIN(1.0, fabs(value));
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    
    // Resize our mask layer based on the current progress
    
    CGRect maskRect = [maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * progress;
    [maskLayer setFrame:maskRect];
}

- (NSArray *)shiftColors:(NSArray *)colors {
    
    // Moves the last item in the array to the front
    // shifting all the other elements.
    
    NSMutableArray *mutable = [colors mutableCopy];
    id last = [[mutable lastObject] retain];
    [mutable removeLastObject];
    [mutable insertObject:last atIndex:0];
    [last release];
    return [NSArray arrayWithArray:[mutable autorelease]];
}

- (void)performAnimation {
    
    // Update the colors on the model layer
    
    CAGradientLayer *layer = (id)[self layer];
    NSArray *fromColors = [layer colors];
    NSArray *toColors = [self shiftColors:fromColors];
    [layer setColors:toColors];
    
    // Create an animation to slowly move the hue gradient left to right.
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setFromValue:fromColors];
    [animation setToValue:toColors];
    [animation setDuration:0.08];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    
    // Add the animation to our layer
    
    [layer addAnimation:animation forKey:@"animateGradient"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    
    if ([self isAnimating]) {
        
        [self performAnimation];
    }
}

- (void)startAnimating {
    
    if (![self isAnimating]) {
        
        animating = YES;
        
        [self performAnimation];
    }
}

- (void)stopAnimating {
    
    if ([self isAnimating]) {
        
        animating = NO;
    }
}

@end
