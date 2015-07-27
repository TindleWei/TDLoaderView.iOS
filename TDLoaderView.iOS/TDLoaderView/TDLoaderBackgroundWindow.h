//
//  TDLoaderBackgroundWindow.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/27.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDLoaderView.h"

@interface TDLoaderBackgroundWindow : UIWindow

@property (nonatomic, assign) TDLoaderViewType type;

- (id)initWithFrame:(CGRect)frame andStyle:(TDLoaderViewType)type;

@end
