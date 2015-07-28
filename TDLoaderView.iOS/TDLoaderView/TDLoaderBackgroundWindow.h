//
//  TDLoaderBackgroundWindow.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/27.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDAlertView.h"

@interface TDLoaderBackgroundWindow : UIWindow

@property (nonatomic, assign) TDAlertViewType type;

- (id)initWithFrame:(CGRect)frame andStyle:(TDAlertViewType)type;

@end
