//
//  TDAlertButtonItem.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/28.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDAlertView.h"

@interface TDAlertButtonItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TDAlertButtonType type;
@property (nonatomic, copy) TDLoaderViewHandler action;

@end

