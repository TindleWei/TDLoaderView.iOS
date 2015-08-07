//
//  TDLoaderView.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//
#import "TDAlertButtonItem.h"
#import "TDAlertView.h"
#import "ScreenUtil.h"

NSString *const TDLoaderViewWillShowNotification = @"TDLoaderViewWillShowNotification";
NSString *const TDLoaderViewWillDismissNofification = @"TDLoaderViewWillDismissNofification";

#define DEBUG_LAYOUT 0

#define PADDING_GAP 10
#define PADDING_TOP 32
#define PADDING_LEFT 10
#define PADDING_BOTTOM 10
#define BUTTON_HEIGHT 44
#define VIEW_WIDTH 300

@interface TDAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray *modelItems;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray *buttons;

@end


#pragma mark - TDLoaderView

@implementation TDAlertView

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
    debugMethod();
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        self.modelItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setTitle:(NSString *)title andMessage:(NSString *)message{
    _title = title;
    _message = message;

}

# pragma mark - Public Method

- (void)show{
    debugMethod();
    [self initViews];
    [self validateLayout];
}

- (CGSize)getSize{
    return CGSizeMake(VIEW_WIDTH, [self layoutHeight]);
}

- (void)addButtonWithTitle:(NSString *)title type:(TDAlertButtonType)type handler:(TDLoaderViewHandler)handler{
    TDAlertButtonItem *item = [[TDAlertButtonItem alloc] init];
    item.title = title;
    item.type = type;
    item.action = handler;
    [self.modelItems addObject:item];
}

- (void)dismiss{
    
}

# pragma mark - Setup Views

- (void)initViews{
    debugMethod();
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
        [self addSubview:self.titleLabel];
        
        self.titleLabel.text = @"Hi, Title";
    }
    
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.numberOfLines = 3;
        [self addSubview:self.messageLabel];
        
        self.messageLabel.text = @"Is there any questions?";
    }
    
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.modelItems.count];
    for (NSUInteger i = 0; i < self.modelItems.count; i++) {
        UIButton *button = [self setupButtonForItemIndex:i];
        [self.buttons addObject:button];
        [self addSubview:button];
    }
    
    
}


- (UIButton *)setupButtonForItemIndex:(NSInteger)index{
    TDAlertButtonItem *item = self.modelItems[index];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    [button setTitle:item.title forState:UIControlStateNormal];
    
    UIColor *buttonColor = [UIColor colorWithWhite:0.4 alpha:1];
    
    switch (item.type) {
        case 0:
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[buttonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            break;
        case 1:
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[buttonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            break;
        case 2:
        default:
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[buttonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            break;
    }

    [button setBackgroundImage:[self imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


# pragma mark - Validate Layout

- (void)validateLayout{
    debugMethod();
    
    CGFloat height = [self layoutHeight];
    
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0, 0, VIEW_WIDTH, height);
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat y = PADDING_TOP;
    if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLable];
        self.titleLabel.frame = CGRectMake(PADDING_LEFT, y, self.bounds.size.width - PADDING_LEFT * 2, height);
        y += height;
    }
    
    if (self.messageLabel) {
        if (y > PADDING_TOP) {
            y += PADDING_GAP;
        }
        self.messageLabel.text = self.message;
        CGFloat height = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(PADDING_LEFT, y, self.bounds.size.width - PADDING_LEFT * 2, height);
        y += height;
    }
    
    if (self.modelItems.count > 0) {
        y += PADDING_GAP;
        if ([self.modelItems count]==2) {
            CGFloat width = (self.bounds.size.width - PADDING_LEFT *2 - PADDING_GAP) * 0.5;
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(PADDING_LEFT, y, width, BUTTON_HEIGHT);
            button = self.buttons[1];
            button.frame = CGRectMake(PADDING_LEFT + width + PADDING_GAP, y, width, BUTTON_HEIGHT);
        } else {
            for (NSInteger i=0; i<[self.buttons count]; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(PADDING_LEFT, y, self.bounds.size.width - PADDING_LEFT *2, BUTTON_HEIGHT);
                y += BUTTON_HEIGHT + PADDING_GAP;
            }
        }
    }
}

# pragma mark - Calculate Height

- (CGFloat)layoutHeight{
    debugMethod();
    CGFloat height = PADDING_TOP;
    
    if(self.titleLabel){
        height +=[self heightForTitleLable];
    }
    
    if(self.messageLabel){
        if(height > PADDING_TOP){
            height += PADDING_GAP;
        }
        height += [self heightForMessageLabel];
    }
    
    if ([self.modelItems count]>0) {
        if ([self.modelItems count]<=2) {
            height += BUTTON_HEIGHT + PADDING_GAP;
        } else {
            height += (BUTTON_HEIGHT + PADDING_GAP) * [self.modelItems count];
        }
    }
    
    height += PADDING_BOTTOM;
    
    return height;
}

- (CGFloat)heightForTitleLable{
    if (self.titleLabel) {
#ifdef __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font,
                                     NSParagraphStyleAttributeName: paragraphStyle.copy};
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(VIEW_WIDTH - PADDING_LEFT * 2, CGFLOAT_MAX)
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
    CGFloat minHeight = 3 * self.messageLabel.font.lineHeight;
    if (self.messageLabel) {
        CGFloat maxHeight = 5 * self.messageLabel.font.lineHeight;
        
#ifdef __IPHONE_7_0
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.messageLabel.lineBreakMode;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.messageLabel.font,
                                     NSParagraphStyleAttributeName: paragraphStyle.copy};
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(VIEW_WIDTH - PADDING_LEFT * 2, maxHeight)
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

# pragma mark - Actions

- (void)buttonAction:(UIButton *)button
{
    debugMethod();
    //[self setAnimating:YES]; // set this flag to YES in order to prevent showing another alert in action block
    TDAlertButtonItem *item = self.modelItems[button.tag];
    if (item.action) {
        item.action(self);
    }
    //[self dismissAnimated:YES];
}

# pragma mark - Others

@end













