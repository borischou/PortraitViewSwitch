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

#define Frame_Default_Rect CGRectMake(0, -Height_Screen, Width_Screen, 3*Height_Screen)
#define Frame_Top_Rect CGRectMake(0, 0, Width_Screen, 3*Height_Screen)
#define Frame_Bottom_Rect CGRectMake(0, -2*Height_Screen, Width_Screen, 3*Height_Screen)

#define CenterY_Top_Current Height_Screen/2
#define CenterY_Middle_Current Height_Screen/2+Height_Screen
#define CenterY_Bottom_Current Height_Screen/2+2*Height_Screen

#define Screen_Center_Y [UIScreen mainScreen].bounds.size.height/2

#define Switch_Trigger_Min_Height [UIScreen mainScreen].bounds.size.height/2

@interface PVSMainViewController ()

@property (strong, nonatomic) PVSCurrentViewController *currentViewController;
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) PVSBackgroundView *topView, *bottomView, *middleView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) PVSCurrentViewState currentViewState;
@property (assign, nonatomic) CGFloat currentCenterY;
@property (strong, nonatomic) NSArray<UIImage *> *items;
@property (strong, nonatomic) UIImage *currentMiddleImage, *currentTopImage, *currentBottomImage;

@end

@implementation PVSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCurrentViewController];
    [self configPanGesture];
    [self initItems];
    self.currentViewState = PVSCurrentViewStateMiddle;
    self.currentCenterY = self.currentView.center.y;
}

- (void)initItems
{
    self.items = @[[UIImage imageNamed:@"1.PNG"],
                   [UIImage imageNamed:@"2.PNG"],
                   [UIImage imageNamed:@"3.PNG"],
                   [UIImage imageNamed:@"4.PNG"]].mutableCopy;
}

- (void)loadCurrentViewController
{
    self.currentViewController = [[PVSCurrentViewController alloc] init];
    self.currentViewController.view.frame = Frame_Default_Rect;
    self.currentView = self.currentViewController.view;
    self.middleView = self.currentViewController.middleView;
    self.topView = self.currentViewController.topView;
    self.bottomView = self.currentViewController.bottomView;
    [self.view addSubview:self.currentViewController.view];
    
    [self loadInitialImages];
}

- (void)loadInitialImages
{
    [self.middleView setImage:[UIImage imageNamed:@"1.PNG"]];
    [self.topView setImage:[UIImage imageNamed:@"2.PNG"]];
    [self.bottomView setImage:[UIImage imageNamed:@"3.PNG"]];
    
    self.currentTopImage = self.topView.image;
    self.currentBottomImage = self.bottomView.image;
    self.currentMiddleImage = self.middleView.image;
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
    CGFloat distance = pan.view.center.y-self.currentCenterY; //滑动的相对位移
    if (fabs(distance) >= Switch_Trigger_Min_Height)
    {
        PVSCurrentViewState state = self.currentViewState;
        CGPoint offset = CGPointZero;
        BOOL isDown;
        if (distance > 0) //向下滑
        {
            isDown = YES;
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
            isDown = NO;
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
        
        __weak id weakSelf = self;
        [self.currentView setContentOffset:offset animated:YES duration:0.3 completion:^(BOOL finished)
        {
            __strong PVSMainViewController *strongSelf = weakSelf;
            [strongSelf replaceItemBeforeSwitchAfterScrolling:isDown];
            [strongSelf resetPositionState:PVSCurrentViewStateMiddle];
            [strongSelf replaceItemAfterSwitchAfterScrolling:isDown];
        }];
    }
    else
    {
        [self resetCurrentPostionAnimated:YES];
    }
}

- (void)replaceItemBeforeSwitchAfterScrolling:(BOOL)isDown //YES: down NO: up
{
    if (isDown)
    {
        [self replaceItemInView:self.middleView withNewItem:self.currentTopImage];
        NSInteger index = [self.items indexOfObject:self.currentMiddleImage]+1;
        if (self.items.count > index)
        {
            UIImage *image = [self.items objectAtIndex:index];
            [self replaceItemInView:self.bottomView withNewItem:image];
        }
        
    }
    else
    {
        [self replaceItemInView:self.middleView withNewItem:self.currentBottomImage];
        NSInteger index = [self.items indexOfObject:self.currentMiddleImage]-1;
        if (self.items.count > index)
        {
            UIImage *image = [self.items objectAtIndex:index];
            [self replaceItemInView:self.topView withNewItem:image];
        }
    }
}

- (void)replaceItemAfterSwitchAfterScrolling:(BOOL)isDown //YES: down NO: up
{
    if (isDown)
    {
        NSInteger index = [self.items indexOfObject:self.currentMiddleImage]-1;
        if (self.items.count > index)
        {
            UIImage *image = [self.items objectAtIndex:index];
            [self replaceItemInView:self.topView withNewItem:image];
        }
    }
    else
    {
        NSInteger index = [self.items indexOfObject:self.currentMiddleImage]+1;
        if (self.items.count > index)
        {
            UIImage *image = [self.items objectAtIndex:index];
            [self replaceItemInView:self.bottomView withNewItem:image];
        }
    }
}

- (void)replaceItemInView:(PVSBackgroundView *)view withNewItem:(UIImage *)image
{
    if (view == nil || image == nil)
    {
        return;
    }
    [view setImage:image];
    
    if ([view isEqual:self.bottomView])
    {
        self.currentBottomImage = image;
    }
    else if ([view isEqual:self.topView])
    {
        self.currentTopImage = image;
    }
    else if ([view isEqual:self.middleView])
    {
        self.currentMiddleImage = image;
    }
}

- (void)switchBackgroundViewToMiddle
{
    if (self.currentViewState == PVSCurrentViewStateBottom)
    {
        [self.currentViewController rearrangeSubviewLayoutFromState:PVSCurrentViewStateMiddle];
    }
    if (self.currentViewState == PVSCurrentViewStateTop)
    {
        [self.currentViewController rearrangeSubviewLayoutFromState:PVSCurrentViewStateBottom];
    }
    if (self.currentViewState == PVSCurrentViewStateMiddle)
    {
        [self.currentViewController rearrangeSubviewLayoutFromState:PVSCurrentViewStateTop];
    }
}

- (void)moveCurrentViewCallback:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];
    pan.view.center = CGPointMake(pan.view.center.x, pan.view.center.y+translation.y);
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)resetCurrentPostionAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self resetCurrentPosition];
        }];
    }
    else
    {
        [self resetCurrentPosition];
    }
}

- (void)resetPositionState:(PVSCurrentViewState)state
{
    self.currentViewState = state;
    switch (state)
    {
        case PVSCurrentViewStateTop:
            self.currentView.frame = Frame_Top_Rect;
            break;
        case PVSCurrentViewStateBottom:
            self.currentView.frame = Frame_Bottom_Rect;
            break;
        case PVSCurrentViewStateMiddle:
            self.currentView.frame = Frame_Default_Rect;
            break;
        default:
            break;
    }
    self.currentCenterY = self.currentView.center.y;
}

- (void)resetCurrentPosition
{
    PVSCurrentViewState state = self.currentViewState;
    switch (state)
    {
        case PVSCurrentViewStateTop:
            self.currentView.frame = Frame_Top_Rect;
            break;
        case PVSCurrentViewStateBottom:
            self.currentView.frame = Frame_Bottom_Rect;
            break;
        case PVSCurrentViewStateMiddle:
            self.currentView.frame = Frame_Default_Rect;
            break;
        default:
            break;
    }
}

@end
