//
//  HTNavigationController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Layer.h"

@interface HTNavigationController ()
{
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@end


@implementation HTNavigationController

- (void)dealloc
{
    [_backgroundView removeFromSuperview];
    _backgroundView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;

    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.height);
    [self.view addSubview:shadowImageView];
    
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    recognizer.edges = UIRectEdgeLeft;
    [recognizer delaysTouchesBegan];
    recognizer.delaysTouchesBegan = YES;
    
    [self.view addGestureRecognizer:recognizer];
    
    //  关闭系统侧滑手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //  移除底下的黑线
    [self removeNavigationBarbottomLine:self.navigationBar];
}

//  MARK:remove bottom line
- (void)removeNavigationBarbottomLine:(UIView *)superView
{
    if ([superView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
    {
        //移除分割线
        for (UIView *view in superView.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
                return;
            }
        }
      }
    
    for (UIView *view in superView.subviews)
    {
        [self removeNavigationBarbottomLine:view];
    }
  
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        [self.screenShotsList addObject:[self capture]];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [APPKeyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    x = x > APPScreenWidth ? APPScreenWidth :x;
    x = x < 0 ? 0 : x ;
 
    NSLog(@"movingX:%.2f", x);
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    //float scale = (x / (APPScreenWidth / 0.05)) + 0.95;
    float alpha = 0.4 - (x / 800);
    
    lastScreenShotView.transform = CGAffineTransformMakeTranslation(x * .5, 0);
    blackMask.alpha = alpha;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:APPKeyWindow];
    
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        if (!self.backgroundView.superview)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        lastScreenShotView.right = APPScreenWidth / 2.0f;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:APPScreenWidth];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                self.backgroundView.hidden = NO;
                
            }];
            
        } else {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                self.backgroundView.hidden = NO;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateChanged) {
        
        [self moveViewWithX:touchPoint.x];
    }
}


@end
