//
//  TDLoaderBackgroundWindow.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/27.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderBackgroundWindow.h"


@implementation TDLoaderBackgroundWindow

- (id)initWithFrame:(CGRect)frame andStyle:(TDAlertViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelTDAlertBackground;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.type) {
        case 0: //Gradient
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height);
            CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
        case 1: //solid
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
    }
}


@end
