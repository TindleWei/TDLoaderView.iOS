//
//  TDLoaderButtonItem.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/27.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDLoaderView.h"

@interface TDLoaderButtonItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TDLoaderViewTextType type;
@property (nonatomic, copy) TDLoaderViewHandler action;

@end
