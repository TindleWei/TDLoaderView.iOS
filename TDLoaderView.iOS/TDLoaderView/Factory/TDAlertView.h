//
//  TDLoaderView.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDView.h"

extern NSString *const TDLoaderViewWillShowNotification;
extern NSString *const TDLoaderViewWillDismissNofification;

typedef NS_ENUM(NSInteger, TDAlertButtonType){
    TDAlertButtonTypeDefault    = 0, // white bg
    TDAlertButtonTypePrimary    = 1, // blue bg
    TDAlertButtonTypeInfo       = 2, // light blue bg
    TDAlertButtonTypeSuccess    = 3, // green bg
    TDAlertButtonTypeWarning    = 4, // yellow bg
    TDAlertButtonTypeFail       = 5  // red bg
};

@class TDAlertView;

typedef void (^TDLoaderViewHandler)(TDAlertView *loaderView);

@interface TDAlertView : TDView

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(TDAlertButtonType)type handler:(TDLoaderViewHandler)handler;


@end
