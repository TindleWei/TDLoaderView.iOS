//
//  TDLoaderView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/28.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderView.h"
#import "ScreenUtil.h"

const UIWindowLevel UIWindowLevelTDLoader = 1996.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelTDLoaderBackground = 1985.0; // below the alert window

@interface TDLoaderView ()

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, readwrite) TDLoaderViewType currentViewType;
@property (nonatomic, strong) TDView *currentView;

@property (nonatomic, strong) TDProgressView *progressView;
@property (nonatomic, strong) TDAlertView *alertView;

@end

@implementation TDLoaderView

//+ (TDLoaderView*)sharedView {
//    static dispatch_once_t once;
//    static TDLoaderView *sharedView;
//    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]; });
//    return sharedView;
//}

- (void)initProgressWithStatus:(NSString *)status{
    
    [self.progressView setWithStatus:status];
    _currentViewType = TDLoaderViewTypeProgress;
    _currentView = self.progressView;
}

- (void)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    [self.alertView setTitle:title andMessage:message];
    _currentViewType = TDLoaderViewTypeAlert;
    _currentView = self.alertView;
}

- (void)changeViewWithType:(TDLoaderViewType)type{
    if (type == _currentViewType) {
        return;
    }
    _currentViewType = type;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _currentView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [_currentView removeFromSuperview];
        _currentView = nil;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            switch (type) {
                case TDLoaderViewTypeProgress:{
                    
                    [self initProgressWithStatus:@"changed"];
                    [self show];
                    
                    CGFloat viewW = [self getSize].width;
                    CGFloat viewH = [self getSize].height;
                    CGFloat screenW = [ScreenUtil getScreenWidth];
                    CGFloat screenH = [ScreenUtil getScreenHeightWithoutStatusbar];
                    
                    self.containerView.frame = CGRectMake((screenW - viewW) * 0.5, (screenH - viewH) * 0.5, viewW, viewH);
                    [self resizeLoaderWithFrame:self.containerView.frame];
                    
                    break;
                }
                case TDLoaderViewTypeAlert:{
                    
                    [self initAlertWithTitle:@"change" andMessage:@"now"];
                    [self show];
                    
                    CGFloat viewW = [self getSize].width;
                    CGFloat viewH = [self getSize].height;
                    CGFloat screenW = [ScreenUtil getScreenWidth];
                    CGFloat screenH = [ScreenUtil getScreenHeightWithoutStatusbar];
                    
                    self.containerView.frame = CGRectMake((screenW - viewW) * 0.5, (screenH - viewH) * 0.5, viewW, viewH);
                    [self resizeLoaderWithFrame:self.containerView.frame];
                    break;
                }
                case TDLoaderViewTypeLoad:{
                    
                    break;
                }
                case TDLoaderViewTypeToast:{
                    
                    break;
                }
                default:
                    break;
            }
            
        }];
    }];
}

- (void)show{
    [_currentView show];
}

- (CGSize)getSize{
    return [_currentView getSize];
}

- (void)dismiss{
    
}

#pragma mark - Layout

/**
 fixed bug: resize the scope of superview action frame
 @date: 2015-8-17
 */
- (void)resizeLoaderWithFrame:(CGRect) rect{
    self.frame = rect;
}

#pragma mark - Actions

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    debugMethod();
    
}

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

- (UIView *)containerView {
    if(!_containerView) {
        CGFloat screenWidth = [ScreenUtil getScreenWidth];
        CGFloat screenHeight = [ScreenUtil getScreenHeightWithoutStatusbar];
        
        CGFloat left = (screenWidth - 100) * 0.5;
        CGFloat top = (screenHeight - 100) * 0.5;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(left, top, 100, 100)];
        _containerView.backgroundColor = [UIColor greenColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = YES;
        _containerView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);

    }
    
    if(!_containerView.superview){
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (TDAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[TDAlertView alloc] initWithTitle:@"" andMessage:@""];
        [self.containerView addSubview:self.alertView];
    }
    return _alertView;
}

- (TDProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[TDProgressView alloc] initWithFrame:CGRectZero];
        [self.containerView addSubview:self.progressView];
    }
    return _progressView;
}

@end
