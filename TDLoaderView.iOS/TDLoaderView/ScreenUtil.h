//
//  ScreenUtil.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/8/5.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenUtil : NSObject

// default is portrait
+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;
+ (CGFloat)getScreenHeightWithoutStatusbar;
+ (CGFloat)getScreenHeightWithoutStatusbarAndNavbar;

@end
