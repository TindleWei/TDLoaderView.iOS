//
//  TDView.h
//  TDLoaderView.iOS
//
//  Created by tindle on 15/8/5.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import <UIKit/UIKit.h>

#define debugMethod() NSLog(@"%s", __func__)

@interface TDView : UIView

- (void)create;
- (void)show;
- (void)dismiss;
- (CGSize)getSize;

@end
