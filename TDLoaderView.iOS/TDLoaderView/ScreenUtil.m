//
//  ScreenUtil.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/8/5.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "ScreenUtil.h"

@implementation ScreenUtil

+ (CGFloat)getScreenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}


+ (CGFloat)getScreenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)getScreenHeightWithoutStatusbar{
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (CGFloat)getScreenHeightWithoutStatusbarAndNavbar{
    return [self getScreenHeightWithoutStatusbar] - 44;
}

@end
