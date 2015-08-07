//
//  ViewController.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "ViewController.h"
#import "TDAlertView.h"
#import "TDLoaderView.h"
#import "TDProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) UIView *myView;

@property (strong, nonatomic) TDLoaderView *loaderView;

@property (nonatomic, assign) NSInteger num;

@end

@implementation ViewController

- (IBAction)action:(id)sender {
//    [self alertTest];
    [self originTest];
//    [self progressTest];
}

- (void)originTest{
    if (_num%3==0) {
        _num++;
        if (!_loaderView) {
            _loaderView = [[TDLoaderView alloc] initWithFrame:CGRectZero];
            [self.view addSubview:_loaderView];
        }
        [_loaderView changeViewWithType:TDLoaderViewTypeProgress];
        [[_loaderView progressView] setWithStatus:@"Checking"];
        [_loaderView show];
        
    }else if(_num%3==1){
  
        [_loaderView changeViewWithType:TDLoaderViewTypeAlert];
        [[_loaderView alertView] setTitle:@"Error" andMessage:@"What have you done?"];
        [[_loaderView alertView] addButtonWithTitle:@"Next"
                                               type:0
                                            handler:^(TDAlertView *alertView) {
                                                [_loaderView changeViewWithType:TDLoaderViewTypeProgress];
                                                [[_loaderView progressView] setWithStatus:@"Loading"];
                                                [_loaderView show];
                                            }];
        [[_loaderView alertView] addButtonWithTitle:@"Cancel"
                                               type:1
                                            handler:^(TDAlertView *alertView) {
                                                NSLog(@"Button2 Clicked");
                                            }];
        [_loaderView show];
        [_loaderView resizeLayout];
        
        _num++;
        return;
    }else{

        [_loaderView removeFromSuperview];
        _loaderView = nil;
        _num++;
        return;
    }
}

- (void)progressTest{
    if (_num%2==0) {
        TDProgressView *view = [[TDProgressView alloc] initWithFrame:CGRectZero];
        //view = [[TDProgressView alloc]initProgressWithStatus:@"Loading"];
        [self.view addSubview:view];
        [view show];
    }else{
        TDProgressView *view = [[TDProgressView alloc]initWithStatus:@"Loading"];
        [self.view addSubview:view];
        [view show];
    }
    _num++;
    
}

- (void)alertTest{
    TDAlertView *alertView = [[TDAlertView alloc] initWithTitle:@"Title1" andMessage:@"What are you doing, man, dude, guy, bro, friend, buddy?"];
    [self.view addSubview:alertView];
    
    [alertView addButtonWithTitle:@"Button1"
                             type:0
                          handler:^(TDAlertView *alertView) {
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button2"
                             type:1
                          handler:^(TDAlertView *alertView) {
                              NSLog(@"Button2 Clicked");
                          }];
//    [alertView addButtonWithTitle:@"Button3"
//                             type:2
//                          handler:^(TDAlertView *alertView) {
//                              NSLog(@"Button3 Clicked");
//                          }];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _num = 0;
    
}

- (void)alert2
{
    TDAlertView *alertView = [[TDAlertView alloc] initWithTitle:@"Title2" andMessage:@"Message2"];
    [alertView addButtonWithTitle:@"Cancel"
                             type:0
                          handler:^(TDAlertView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:@"OK"
                             type:0
                          handler:^(TDAlertView *alertView) {
                              NSLog(@"OK Clicked");
                              
                          }];
    
    [alertView show];
    
}

@end
