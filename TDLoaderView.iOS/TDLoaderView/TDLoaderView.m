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

@property (nonatomic, readwrite) TDLoaderViewType currentViewType;

//alert view
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttons;



@end

@implementation TDLoaderView

- (id)initProgressWithStatus:(NSString *)status{
    debugMethod();
    self = [super init];
    if (self) {
        self.status = status;
        self.currentViewType = TDLoaderViewTypeProgress;
    }
    return self;
}

- (void)setProgressStatus:(NSString *)status{
    self.status = status;
}

- (void)changeViewType:(TDLoaderViewType)type{
    if (type == _currentViewType) {
        return;
    }
    _currentViewType = type;
//     [self teardown];
    
    
    if(type==TDLoaderViewTypeProgress){
        
        
        
    }else if(type==TDLoaderViewTypeLoader){
        
    }else if(type==TDLoaderViewTypeAlert){
        [UIView animateWithDuration:0.3 animations:^{
            self.statusLabel.alpha = 0;
            self.progressView.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.statusLabel = nil;
            self.progressView = nil;
            
            [UIView animateWithDuration:0.3 animations:^{
                [self addAlertView];
            }];
        }];
    }else if(type==TDLoaderViewTypeToast){
        
    }
    
    
    
}

- (void) addAlertView{
    
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
        [self.hudView addSubview:self.titleLabel];
        
        self.titleLabel.text = @"Hi, Title";
    }
    
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.numberOfLines = 3;
        [self.hudView addSubview:self.messageLabel];
        
        self.messageLabel.text = @"Is there any questions?";
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat height = [self preferredHeight];
    CGFloat left = (screenWidth - 300) * 0.5;
    CGFloat top = (screenHeight - height) * 0.5;
    
    self.hudView.transform = CGAffineTransformIdentity;
    self.hudView.frame = CGRectMake(left, top, 300, height);
    
    CGFloat y = 10;
    if (self.titleLabel) {
        self.titleLabel.frame = CGRectMake(10, y, self.hudView.bounds.size.width - 10 * 2, 40);
        y = CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.messageLabel) {
        y += 10;
        self.messageLabel.frame = CGRectMake(10, y, self.hudView.bounds.size.width - 10 * 2, 40);
    }
    
    [self setupButtons];
}

-(void)setupButtons{
    self.buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
}

- (CGFloat)preferredHeight {
    
    CGFloat height = 10;
    if(self.titleLabel){
        height +=40;
    }
    if(self.messageLabel){
        if(height>10){
            height +=10;
        }
        height += 40;
        //add calculate height
        
    }
    return height+200;
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
    [self.containerView removeFromSuperview];
    [self.hudView removeFromSuperview];
}

-(void)show{
    
    debugMethod();
    if (self.isVisible) {
        return;
    }
    self.visible = YES;
    
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
    CGFloat offsetY = (HUB_VIEW_SIZE - PROGRESS_VIEW_SIZE)/2;
    
    if (_status) {
        offsetY -= 5;
        self.statusLabel.text = _status;
    }else{
        offsetY += 5;
    }
    
    self.progressView.frame = CGRectMake(offsetX+5, offsetY, PROGRESS_VIEW_SIZE, PROGRESS_VIEW_SIZE);
    [self setRectForLabel:self.statusLabel];
    
    [self.hudView setNeedsDisplay];
}

-(void)setRectForLabel:(UILabel *)lable{
    
    if (!lable) {
        return;
    }
    
    CGFloat stringWidth = 0.0f;
    CGFloat stringHeight = 0.0f;
    CGRect labelRect = CGRectZero;
    
    NSString *string = lable.text;
    
    if(string) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        CGRect stringRect;
        if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
            stringRect = [string boundingRectWithSize:constraintSize
                                              options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{NSFontAttributeName: lable.font}
                                              context:NULL];
        } else {
            CGSize stringSize;
            if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
                stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:lable.font.fontName size:lable.font.pointSize]}];
            }
            stringRect = CGRectMake(0.0f, 0.0f, stringSize.width, stringSize.height);
        }
        stringWidth = stringRect.size.width;
        stringHeight = ceil(CGRectGetHeight(stringRect));
        
        CGFloat labelRectY = CGRectGetMaxY(self.progressView.frame);
        labelRect = CGRectMake(0.0f, labelRectY, HUB_VIEW_SIZE, stringHeight);
        
        
        lable.frame = labelRect;
    }else{
        
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
        _statusLabel.adjustsFontSizeToFitWidth      = NO;
//        _statusLabel.text = @"Saving";
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
