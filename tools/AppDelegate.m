//
//  AppDelegate.m
//  tools
//
//  Created by wcc on 2018/3/30.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "AppDelegate.h"
#import "ADSBaseViewController.h"
#import "ADSNavigationController.h"
#import "ADSHomeViewController.h"
#import "ADSSettingViewController.h"

@interface ADSExpandAnimatorObject : NSObject<UIViewControllerAnimatedTransitioning>

@end

@implementation ADSExpandAnimatorObject

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [[transitionContext containerView] addSubview:toView];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [toView wcc_addFrameAnimation:toViewFinalFrame duration:[self transitionDuration:transitionContext] autoReverse:NO];
                     }
                     completion:^(BOOL finished) {
                         if (![transitionContext transitionWasCancelled]) {
                             [fromView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }
                         else {
                             [toView removeFromSuperview];
                             [transitionContext completeTransition:NO];
                         }
                     }];
}
@end

@interface AppDelegate ()<UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ADSHomeViewController *baseVC = [[ADSHomeViewController alloc]init];
    ADSNavigationController *navVC = [[ADSNavigationController alloc]initWithRootViewController:baseVC];
    navVC.delegate = self;
    _window.rootViewController = navVC;
    [_window makeKeyAndVisible];
    return YES;
}

- ( id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [[ADSExpandAnimatorObject alloc]init];
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

@end
