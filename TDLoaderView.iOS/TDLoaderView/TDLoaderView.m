//
//  TDLoaderView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/28.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderView.h"
#import "TDProgressView.h"

#define debugMethod() NSLog(@"%s", __func__)

#define HUB_VIEW_SIZE 100
#define PROGRESS_VIEW_SIZE 40

const UIWindowLevel UIWindowLevelTDLoader = 1996.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelTDLoaderBackground = 1985.0; // below the alert window

@interface TDLoaderView ()

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UIControl *containerView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) TDProgressView *progressView;

@end

@implementation TDLoaderView

- (id)initProgressWithStatus:(NSString *)status{
    debugMethod();
    self = [super init];
    if (self) {
        _status = status;
    }
    return self;
}


-(void)show{
    debugMethod();
    
    if(!self.containerView.superview){
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        [window addSubview:self.containerView];
    }
    
    [self.containerView addSubview:self];
    self.containerView.userInteractionEnabled = NO;
    self.containerView.hidden = NO;
    self.containerView.backgroundColor = [UIColor clearColor];
    
    [self.hudView addSubview:self.progressView];
    self.hudView.accessibilityLabel = @"hudView";
    self.hudView.isAccessibilityElement = YES;

    [self validateLayout];
}

- (void)validateLayout {
    
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat hubX = (screenWidth - HUB_VIEW_SIZE)/2;
    CGFloat hubY = (screenHeight - HUB_VIEW_SIZE)/2;
    
    self.hudView.frame = CGRectMake(hubX, hubY, HUB_VIEW_SIZE, HUB_VIEW_SIZE);
    
    CGFloat offsetX = (HUB_VIEW_SIZE - PROGRESS_VIEW_SIZE)/2;
    
    self.progressView.frame = CGRectMake(offsetX+5, offsetX-5, PROGRESS_VIEW_SIZE, PROGRESS_VIEW_SIZE);
    
    
    CGFloat stringWidth = 0.0f;
    CGFloat stringHeight = 0.0f;
    CGRect labelRect = CGRectZero;
    
    NSString *string = self.statusLabel.text;
    
    if(string) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        CGRect stringRect;
        if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
            stringRect = [string boundingRectWithSize:constraintSize
                                              options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{NSFontAttributeName: self.statusLabel.font}
                                              context:NULL];
        } else {
            CGSize stringSize;
            if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
                stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.statusLabel.font.fontName size:self.statusLabel.font.pointSize]}];
            } else {
                stringSize = [string sizeWithFont:self.statusLabel.font constrainedToSize:CGSizeMake(200.0f, 300.0f)];
            }
            stringRect = CGRectMake(0.0f, 0.0f, stringSize.width, stringSize.height);
        }
        stringWidth = stringRect.size.width;
        stringHeight = ceil(CGRectGetHeight(stringRect));
        
        CGFloat labelRectY = 9.0f;
        labelRect = CGRectMake(0.0f, labelRectY, 100, stringHeight);
        
        
        self.statusLabel.frame = labelRect;
        
        
        [self.hudView setNeedsDisplay];
        
    }
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

- (UIControl *)containerView {
    if(!_containerView) {
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        _containerView = [[UIControl alloc] initWithFrame:windowBounds];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _containerView.backgroundColor = [UIColor clearColor];
        [_containerView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _containerView;
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    debugMethod();

}

- (TDProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[TDProgressView alloc] initWithFrame:CGRectZero];
        _progressView.strokeThickness = 2.5;
        _progressView.strokeColor = [UIColor blackColor];
        _progressView.radius = 20;
        [_progressView sizeToFit];
    }
    return _progressView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 1;
//        _statusLabel.adjustsFontSizeToFitWidth      = NO;
        _statusLabel.text = @"Saving";
        _statusLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    if(!_statusLabel.superview)
        [self.hudView addSubview:_statusLabel];
    
    _statusLabel.textColor = [UIColor blackColor];
    
    return _statusLabel;
}

- (UIView *)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.backgroundColor = [UIColor whiteColor];
        _hudView.layer.cornerRadius = 4;
        _hudView.layer.masksToBounds = YES;
        
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    }
    
    if(!_hudView.superview)
        [self addSubview:_hudView];
    
    return _hudView;
}

@end
