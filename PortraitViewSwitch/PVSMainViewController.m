//
//  PTVSMainViewController.m
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/19/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import "PVSMainViewController.h"
#import "PVSCurrentViewController.h"
#import "UIView+Utility.h"

#define Width_Screen [UIScreen mainScreen].bounds.size.width
#define Height_Screen [UIScreen mainScreen].bounds.size.height

#define Position_Default_Rect CGRectMake(0, -Height_Screen, Width_Screen, 3*Height_Screen)
#define Position_Bottom_Rect CGRectMake(0, 0, Width_Screen, Height_Screen)
#define Position_Top_Rect CGRectMake(0, -2*Height_Screen, Width_Screen, Height_Screen)

#define Screen_Center_Y [UIScreen mainScreen].bounds.size.height/2

typedef NS_ENUM(NSInteger, PVSCurrentViewState)
{
    PVSCurrentViewStateMiddle,
    PVSCurrentViewStateTop,
    PVSCurrentViewStateBottom,
    PVSCurrentViewStateUnknown
};

@interface PVSMainViewController ()

@property (strong, nonatomic) PVSCurrentViewController *currentViewController;
@property (strong, nonatomic) UIView *currentView, *topView, *bottomView, *middleView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) PVSCurrentViewState currentViewState;
@property (assign, nonatomic) CGPoint currentCenter;

@end

@implementation PVSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCurrentViewController];
    [self configPanGesture];
    self.currentViewState = PVSCurrentViewStateMiddle;
    self.currentCenter = self.currentView.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadCurrentViewController
{
    self.currentViewController = [[PVSCurrentViewController alloc] init];
    self.currentViewController.view.frame = Position_Default_Rect;
    self.currentView = self.currentViewController.view;
    self.middleView = self.currentViewController.middleView;
    self.topView = self.currentViewController.topView;
    self.bottomView = self.currentViewController.bottomView;
    [self.view addSubview:self.currentViewController.view];
}

- (void)configPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.currentViewController.view addGestureRecognizer:panGesture];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    self.panGesture = panGesture;
}

- (void)didPan:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStatePossible:
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            [self moveCurrentViewCallback:pan];
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
        case UIGestureRecognizerStateEnded:
            [self panGestureEndedCallback:pan];
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        default:
            break;
    }
}

- (void)panGestureEndedCallback:(UIPanGestureRecognizer *)pan
{
    CGFloat distance = pan.view.center.y-self.currentCenter.y;
    if (fabs(distance) > 80)
    {
        PVSCurrentViewState state = self.currentViewState;
        CGPoint offset = CGPointZero;
        if (distance > 0) //向下滑
        {
            if (state == PVSCurrentViewStateMiddle)
            {
                offset = CGPointMake(0, 0);
                self.currentViewState = PVSCurrentViewStateTop;
            }
            if (state == PVSCurrentViewStateBottom)
            {
                offset = CGPointMake(0, -Height_Screen);
                self.currentViewState = PVSCurrentViewStateMiddle;
            }
            if (state == PVSCurrentViewStateTop)
            {
                offset = CGPointMake(0, 0);
                self.currentViewState = PVSCurrentViewStateTop;
            }
        }
        else
        {
            if (state == PVSCurrentViewStateMiddle)
            {
                offset = CGPointMake(0, -2*Height_Screen);
                self.currentViewState = PVSCurrentViewStateBottom;
            }
            if (state == PVSCurrentViewStateBottom)
            {
                offset = CGPointMake(0, -2*Height_Screen);
                self.currentViewState = PVSCurrentViewStateBottom;
            }
            if (state == PVSCurrentViewStateTop)
            {
                offset = CGPointMake(0, -Height_Screen);
                self.currentViewState = PVSCurrentViewStateMiddle;
            }
        }
//        __weak id weakSelf = self;
//        [self.currentView setContentOffset:offset animated:YES duration:0.3 completion:^(BOOL finished)
//        {
//            __strong id strongSelf = weakSelf;
//            [strongSelf resetPositionForCurrentView];
//        }];
        [self.currentView setContentOffset:offset animated:YES];
        self.currentCenter = pan.view.center;
    }
    else
    {
        [self resetPositionForCurrentViewAnimated:YES];
    }
}

- (void)moveCurrentViewCallback:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];
    pan.view.center = CGPointMake(pan.view.center.x, pan.view.center.y+translation.y);
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)resetPositionForCurrentViewAnimated:(BOOL)animated
{
    if (self.currentView == nil)
    {
        return;
    }
    if (animated)
    {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.currentView.frame = Position_Default_Rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        self.currentView.frame = Position_Default_Rect;
    }
}

- (void)resetPositionForCurrentView
{
    [self resetPositionForCurrentViewAnimated:NO];
}

@end
