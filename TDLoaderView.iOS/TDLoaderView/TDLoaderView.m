//
//  TDLoaderView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderView.h"
#import "TDLoaderController.h"
#import "TDLoaderBackgroundWindow.h"
#import "TDLoaderButtonItem.h"

#define debugMethod() NSLog(@"%s", __func__)

NSString *const TDLoaderViewWillShowNotification = @"TDLoaderViewWillShowNotification";
NSString *const TDLoaderViewWillDismissNofification = @"TDLoaderViewWillDismissNofification";

#define DEBUG_LAYOUT 0

#define MESSAGE_MIN_LINE_COUNT 3
#define MESSAGE_MAX_LINE_COUNT 5
#define GAP 10
#define CANCEL_BUTTON_PADDING_TOP 5
#define CONTENT_PADDING_LEFT 10
#define CONTENT_PADDING_TOP 12
#define CONTENT_PADDING_BOTTOM 10
#define BUTTON_HEIGHT 44
#define CONTAINER_WIDTH 300

const UIWindowLevel UIWindowLevelTDLoader = 1996.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelTDLoaderBackground = 1985.0; // below the alert window

static TDLoaderBackgroundWindow *_background_window;
static TDLoaderView *_current_view;

@interface TDLoaderView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIWindow *loaderWindow;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;


+ (TDLoaderView *)currentLoaderView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invalidateLayout;
- (void)resetTransition;

@end


#pragma mark - TDLoaderView

@implementation TDLoaderView

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
    debugMethod();
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Class methods

+ (void)showBackground
{
    debugMethod();
    if (!_background_window) {
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)])
        {
            frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
        }
        
        _background_window = [[TDLoaderBackgroundWindow alloc] initWithFrame:frame
                                                                             andStyle:0];
        [_background_window makeKeyAndVisible];
        _background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _background_window.alpha = 1;
                         }];
    }
}

#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title type:(TDLoaderViewTextType)type handler:(TDLoaderViewHandler)handler
{
    TDLoaderButtonItem *item = [[TDLoaderButtonItem alloc] init];
    item.title = title;
    item.type = type;
    item.action = handler;
    [self.items addObject:item];
}


- (void)show {

    debugMethod();
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TDLoaderViewWillShowNotification object:self userInfo:nil];
    
    [TDLoaderView showBackground];
    
    //Make Root Controller here
    TDLoaderController *viewController = [[TDLoaderController alloc] initWithNibName:nil bundle:nil];
    viewController.loaderView = self;
    
    if (!self.loaderWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelTDLoader;
        window.rootViewController = viewController;
        self.loaderWindow = window;
    }
    [self.loaderWindow makeKeyAndVisible];
    
    [self validateLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    debugMethod();
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout {
    debugMethod();
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout {
    debugMethod();
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
    
    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - CONTAINER_WIDTH) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat y = CONTENT_PADDING_TOP;
    if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.messageLabel) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        self.messageLabel.text = self.message;
        CGFloat height = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.items.count > 0) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        if (self.items.count == 2) {
            CGFloat width = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2 - GAP) * 0.5;
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, width, BUTTON_HEIGHT);
            button = self.buttons[1];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT + width + GAP, y, width, BUTTON_HEIGHT);
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, BUTTON_HEIGHT);
                if (self.buttons.count > 1) {
                    if (i == self.buttons.count - 1) {
                        CGRect rect = button.frame;
                        rect.origin.y += CANCEL_BUTTON_PADDING_TOP;
                        button.frame = rect;
                    }
                    y += BUTTON_HEIGHT + GAP;
                }
            }
        }
    }
}

#pragma mark - Height

- (CGFloat)preferredHeight
{
    CGFloat height = CONTENT_PADDING_TOP;
    if (self.title) {
        height += [self heightForTitleLabel];
    }
    if (self.message) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    if (self.items.count > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.items.count <= 2) {
            height += BUTTON_HEIGHT;
        } else {
            height += (BUTTON_HEIGHT + GAP) * self.items.count - GAP;
            if (self.buttons.count > 2 ) {
                height += CANCEL_BUTTON_PADDING_TOP;
            }
        }
    }
    height += CONTENT_PADDING_BOTTOM;
    return height;
}

- (CGFloat)heightForTitleLabel
{
    if (self.titleLabel) {
#ifdef __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font,
                                     NSParagraphStyleAttributeName: paragraphStyle.copy};
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes
                                                         context:nil];
        return ceil(rect.size.height);
#else
        CGSize size = [self.title sizeWithFont:self.titleLabel.font
                                   minFontSize:
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
                       self.titleLabel.font.pointSize * self.titleLabel.minimumScaleFactor
#else
                       self.titleLabel.minimumFontSize
#endif
                                actualFontSize:nil
                                      forWidth:CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2
                                 lineBreakMode:self.titleLabel.lineBreakMode];
        return size.height;
#endif
    }
    
    return 0;
}

- (CGFloat)heightForMessageLabel
{
    CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageLabel.font.lineHeight;
    if (self.messageLabel) {
        CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageLabel.font.lineHeight;
        
#ifdef __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.messageLabel.lineBreakMode;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.messageLabel.font,
                                     NSParagraphStyleAttributeName: paragraphStyle.copy};
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes
                                                         context:nil];
        
        return MAX(minHeight, ceil(rect.size.height));
#else
        CGSize size = [self.message sizeWithFont:self.messageLabel.font
                               constrainedToSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight)
                                   lineBreakMode:self.messageLabel.lineBreakMode];
        
        return MAX(minHeight, size.height);
#endif
    }
    
    return minHeight;
}


#pragma mark - Setup

- (void)setup
{
    debugMethod();
    
    [self setupContainerView];
    [self updateTitleLabel];
    [self updateMessageLabel];
//    [self setupButtons];
    [self invalidateLayout];
}

- (void)teardown
{
    debugMethod();
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    [self.buttons removeAllObjects];
//    [self.alertWindow removeFromSuperview];
//    self.alertWindow = nil;
    self.layoutDirty = NO;
}

- (void)setupContainerView
{
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 2.0;
    self.containerView.layer.shadowOffset = CGSizeZero;
    self.containerView.layer.shadowRadius = 8.0;
    self.containerView.layer.shadowOpacity = 0.5;
    [self addSubview:self.containerView];
}

- (void)updateTitleLabel
{
    if (self.title) {
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
            self.titleLabel.minimumScaleFactor = 0.75;
#else
            self.titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
#endif
            [self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.titleLabel.text = self.title;
    } else {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
    [self invalidateLayout];
}

- (void)updateMessageLabel
{
    if (self.message) {
        if (!self.messageLabel) {
            self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.backgroundColor = [UIColor clearColor];
            self.messageLabel.numberOfLines = MESSAGE_MAX_LINE_COUNT;
            [self.containerView addSubview:self.messageLabel];
#if DEBUG_LAYOUT
            self.messageLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.messageLabel.text = self.message;
    } else {
        [self.messageLabel removeFromSuperview];
        self.messageLabel = nil;
    }
    [self invalidateLayout];
}


- (void)setupButtons
{
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index {
    TDLoaderButtonItem *item = self.items[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    button.titleLabel.font = self.buttonFont;
    [button setTitle:item.title forState:UIControlStateNormal];
//    UIImage *normalImage = nil;
//    UIImage *highlightedImage = nil;
//    
//    CGFloat hInset = floorf(normalImage.size.width / 2);
//    CGFloat vInset = floorf(normalImage.size.height / 2);
//    UIEdgeInsets insets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
//    normalImage = [normalImage resizableImageWithCapInsets:insets];
//    highlightedImage = [highlightedImage resizableImageWithCapInsets:insets];
//    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)button
{
    [TDLoaderView setAnimating:YES]; // set this flag to YES in order to prevent showing another alert in action block
    TDLoaderButtonItem *item = self.items[button.tag];
    if (item.action) {
        item.action(self);
    }
    [self dismissAnimated:YES];
}

#pragma mark - UIAppearance setters

@end













