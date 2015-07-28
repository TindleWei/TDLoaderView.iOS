//
//  TDLoaderView.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TDLoaderViewWillShowNotification;
extern NSString *const TDLoaderViewWillDismissNofification;

extern UIWindowLevel const UIWindowLevelTDAlert;  // don't overlap system's alert
extern UIWindowLevel const UIWindowLevelTDAlertBackground; // below the alert window

typedef NS_ENUM(NSInteger, TDAlertViewType){
    TDLoaderViewTypeHUD         = 0,
    TDLoaderViewTypeLoading     = 1,
    TDLoaderViewTypeChoosen     = 2,
    TDLoaderViewTypeResult      = 3
};

typedef NS_ENUM(NSInteger, TDLoaderViewTextType){
    TDLoaderViewTextTypeDefault    = 0, // white bg
    TDLoaderViewTextTypePrimary    = 1, // blue bg
    TDLoaderViewTextTypeInfo       = 2, // light blue bg
    TDLoaderViewTextTypeSuccess    = 3, // green bg
    TDLoaderViewTextTypeWarning    = 4, // yellow bg
    TDLoaderViewTextTypeFail       = 5  // red bg
};

typedef NS_ENUM(NSInteger, TDLoaderViewLoaderType){
    TDLoaderViewStyleChecking       = 0,
    TDLoaderViewStyleUploading      = 1,
    TDLoaderViewStyleDownloading    = 2
};

@class TDAlertView;

typedef void (^TDLoaderViewHandler)(TDAlertView *loaderView);

@interface TDAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) TDLoaderViewHandler willShowHandler;
@property (nonatomic, copy) TDLoaderViewHandler didShowHandler;
@property (nonatomic, copy) TDLoaderViewHandler willDismissHandler;
@property (nonatomic, copy) TDLoaderViewHandler didDismissHandler;

- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state;
- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state;
- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state;

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(TDLoaderViewTextType)type handler:(TDLoaderViewHandler)handler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;


//Open to others

@property (nonatomic, weak) UIWindow *oldKeyWindow;

-(void)setup;

@end
