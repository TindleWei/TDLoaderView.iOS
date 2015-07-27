//
//  TDLoaderController.m
//  TDLoaderView.iOS
//
//  Created by tindle on 15/7/26.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "TDLoaderController.h"


@implementation TDLoaderController

#pragma mark - View life cycle

- (void)loadView
{
    self.view = self.loaderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loaderView setup];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    [self.loaderView resetTransition];
//    [self.loaderView invalidateLayout];
}

#ifdef __IPHONE_7_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
#endif

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *viewController = [self currentControllerFromWindow:self.loaderView.oldKeyWindow];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *viewController = [self currentControllerFromWindow:self.loaderView.oldKeyWindow];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewController = [self currentControllerFromWindow:self.loaderView.oldKeyWindow];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}

#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *window = self.loaderView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    return [[self viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *window = self.loaderView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    return [[self viewControllerForStatusBarHidden] prefersStatusBarHidden];
}
#endif


#pragma mark - Utils

- (UIViewController *)currentControllerFromWindow:(UIWindow *)window
{
    UIViewController *viewController = window.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

#ifdef __IPHONE_7_0
- (UIViewController *)viewControllerForStatusBarStyle
{
    UIViewController *currentViewController = [self currentControllerFromWindow:self.loaderView.oldKeyWindow];
    
    while ([currentViewController childViewControllerForStatusBarStyle]) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController *)viewControllerForStatusBarHidden
{
    UIViewController *currentViewController = [self currentControllerFromWindow:self.loaderView.oldKeyWindow];
    
    while ([currentViewController childViewControllerForStatusBarHidden]) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}
#endif

@end
