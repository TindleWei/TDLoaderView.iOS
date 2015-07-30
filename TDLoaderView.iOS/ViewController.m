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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) UIView *myView;

@property (strong, nonatomic) TDLoaderView *loaderView;

@property (nonatomic, assign) NSInteger num;

@end

@implementation ViewController

- (IBAction)action:(id)sender {
    
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
