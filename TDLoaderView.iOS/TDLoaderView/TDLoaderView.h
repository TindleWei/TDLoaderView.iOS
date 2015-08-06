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
    TDLoaderViewTypeProgress    = 0,
    TDLoaderViewTypeLoad     = 1,
    TDLoaderViewTypeAlert       = 2,
    TDLoaderViewTypeToast      = 3
};

typedef NS_ENUM(NSInteger, TDLoaderBootsType){
    TDLoaderBootsSuccess    = 0,
    TDLoaderBootsError     = 1,
    TDLoaderBootsWarning       = 2,
    TDLoaderBootsInfo      = 3
};

@interface TDLoaderView : UIView

@property (nonatomic, assign, getter = isVisible) BOOL visible;

- (id)initProgressWithStatus:(NSString *)status;
- (id)initLoaderWithStatus:(NSString *)status;
- (id)initAlertWithStatus:(NSString *)status;
- (id)initToastWithStatus:(NSString *)status;

- (void)show;
- (void)changeViewType:(TDLoaderViewType)type;
- (void)setBootsType:(TDLoaderBootsType)type;
- (void)dismissAnimated:(BOOL)animated;

- (void)setProgressStatus:(NSString *)status;


@end
