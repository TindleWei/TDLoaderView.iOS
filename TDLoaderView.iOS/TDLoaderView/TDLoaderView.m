//
//  TDLoaderView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/28.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderView.h"

const UIWindowLevel UIWindowLevelTDLoader = 1996.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelTDLoaderBackground = 1985.0; // below the alert window

@interface TDLoaderView ()

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, readwrite) TDLoaderViewType currentViewType;

@end

@implementation TDLoaderView
- (void)changeViewType:(TDLoaderViewType)type{
    if (type == _currentViewType) {
        return;
    }
    _currentViewType = type;
//     [self teardown];
    
    
    if(type==TDLoaderViewTypeProgress){
        
        
        
    }else if(type==TDLoaderViewTypeLoad){
        
    }else if(type==TDLoaderViewTypeAlert){
        [UIView animateWithDuration:0.3 animations:^{

            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{

            }];
        }];
    }else if(type==TDLoaderViewTypeToast){
        
    }
    
    
    
}
- (void)dismissAnimated:(BOOL)animated{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        
    }
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];

    };
}

- (void)teardown {
    [self.overlayView removeFromSuperview];
    [self.containerView removeFromSuperview];
}

#pragma mark - Class Method

+ (TDLoaderView*)sharedView {
    static dispatch_once_t once;
    static TDLoaderView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]; });
    return sharedView;
}

#pragma mark - Layout

#pragma mark - Getters

- (UIControl *)overlayView {
    if(!_overlayView) {
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    debugMethod();

}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
        
        _containerView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    }
    
    if(!_containerView.superview)
        [self addSubview:_containerView];
    
    return _containerView;
}

@end
