//
//  ViewController.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "ViewController.h"
#import "TDLoaderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self alert2];
    
}

- (void)alert2
{
    TDLoaderView *alertView = [[TDLoaderView alloc] initWithTitle:@"Title2" andMessage:@"Message2"];
    [alertView addButtonWithTitle:@"Cancel"
                             type:0
                          handler:^(TDLoaderView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:@"OK"
                             type:0
                          handler:^(TDLoaderView *alertView) {
                              NSLog(@"OK Clicked");
                              
                          }];
//    alertView.titleColor = [UIColor blueColor];
//    alertView.cornerRadius = 10;
//    alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
//    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
//    alertView.willShowHandler = ^(SIAlertView *alertView) {
//        NSLog(@"%@, willShowHandler2", alertView);
//    };
//    alertView.didShowHandler = ^(SIAlertView *alertView) {
//        NSLog(@"%@, didShowHandler2", alertView);
//    };
//    alertView.willDismissHandler = ^(SIAlertView *alertView) {
//        NSLog(@"%@, willDismissHandler2", alertView);
//    };
//    alertView.didDismissHandler = ^(SIAlertView *alertView) {
//        NSLog(@"%@, didDismissHandler2", alertView);
//    };
    
    [alertView show];
}

@end
