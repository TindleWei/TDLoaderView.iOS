//
//  TDLoaderView.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/28.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDAlertView.h"
#import "TDProgressView.h"

extern UIWindowLevel const UIWindowLevelTDLoader;
extern UIWindowLevel const UIWindowLevelTDLoaderBackground;

typedef NS_ENUM(NSInteger, TDLoaderViewType){
    TDLoaderViewTypeNone        = 0,
    TDLoaderViewTypeProgress    = 1,
    TDLoaderViewTypeLoad        = 2,
    TDLoaderViewTypeAlert       = 3,
    TDLoaderViewTypeToast       = 4
};

typedef NS_ENUM(NSInteger, TDLoaderBootsType){
    TDLoaderBootsSuccess    = 0,
    TDLoaderBootsError     = 1,
    TDLoaderBootsWarning       = 2,
    TDLoaderBootsInfo      = 3
};

@interface TDLoaderView : UIView

- (void)initProgressWithStatus:(NSString *)status;
- (void)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

- (id)initLoaderWithStatus:(NSString *)status;
- (id)initToastWithStatus:(NSString *)status;

- (void)show;
- (void)dismiss;
- (void)changeViewWithType:(TDLoaderViewType)type;

- (void)resizeLayout;

- (TDAlertView *)alertView;
- (TDProgressView *)progressView;

- (void)setBootsType:(TDLoaderBootsType)type;



@end
