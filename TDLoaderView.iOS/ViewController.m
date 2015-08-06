//
//  ViewController.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/24.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "ViewController.h"
#import "TDAlertView.h"
#import "TDProgressHUD.h"
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
//    [self originTest];
    [self progressTest];
}

- (void)progressTest{
    if (_num%2==0) {
        TDProgressView *view = [[TDProgressView alloc] initWithFrame:CGRectZero];
        //view = [[TDProgressView alloc]initProgressWithStatus:@"Loading"];
        [self.view addSubview:view];
        [view show];
    }else{
        TDProgressView *view = [[TDProgressView alloc]initProgressWithStatus:@"Loading"];
        [self.view addSubview:view];
        [view show];
    }
    _num++;
    
}

- (void)originTest{
    if (_num%3==0) {
        _num++;
        if (!_loaderView) {
            _loaderView = [[TDLoaderView alloc] initWithFrame:CGRectZero];
            //_loaderView = [[TDLoaderView alloc]initProgressWithStatus:@"Loading"];
            [self.view addSubview:_loaderView];
        }
        
        [_loaderView setProgressStatus:@"正在加载中"];
        [_loaderView show];
        
    }else if(_num%3==1){
        [_loaderView changeViewType:TDLoaderViewTypeAlert];
        _num++;
        return;
    }else{
        [_loaderView removeFromSuperview];
        _loaderView = nil;
        _num++;
        return;
    }
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

- (void)startAnimation {
    NSLog(@"startAnimation self");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _num = 0;
    
//    CGRect viewRect = CGRectMake(50,100,200,200);
//    
//    self.myView= [[UIView alloc] initWithFrame:viewRect];
//    self.myView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:self.myView];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    //[TDProgressHUD show];
    //[TDProgressHUD showWithStatus:@"Doing Stuff"];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - Notification Methods Sample

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notif
{
    NSLog(@"Notification recieved: %@", notif.name);
    NSLog(@"Status user info key: %@", [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey]);
}


@end
