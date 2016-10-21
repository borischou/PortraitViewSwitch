//
//  PVSCurrentViewController.m
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import "PVSCurrentViewController.h"

#define Width_Screen [UIScreen mainScreen].bounds.size.width
#define Height_Screen [UIScreen mainScreen].bounds.size.height

#define Top_Frame_Rect CGRectMake(0, 0, Width_Screen, Height_Screen)
#define Middle_Frame_Rect CGRectMake(0, Height_Screen, Width_Screen, Height_Screen)
#define Bottom_Frame_Rect CGRectMake(0, 2*Height_Screen, Width_Screen, Height_Screen)

@interface PVSCurrentViewController ()

@end

@implementation PVSCurrentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self loadBackgroundViews];
}

- (void)loadBackgroundViews
{
    if (self.topView == nil)
    {
        self.topView = [[PVSBackgroundView alloc] initWithFrame:Top_Frame_Rect];
        [self.view addSubview:self.topView];
    }
    if (self.middleView == nil)
    {
        self.middleView = [[PVSBackgroundView alloc] initWithFrame:Middle_Frame_Rect];
        self.middleView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:self.middleView];
    }
    if (self.bottomView == nil)
    {
        self.bottomView = [[PVSBackgroundView alloc] initWithFrame:Bottom_Frame_Rect];
        [self.view addSubview:self.bottomView];
    }
}

- (void)rearrangeSubviewLayoutFromState:(PVSCurrentViewState)state
{
    UIImage *bottomImage = self.bottomView.image;
    UIImage *middleImage = self.middleView.image;
    UIImage *topImage = self.topView.image;
    
    if (state == PVSCurrentViewStateBottom)
    {
        if (self.bottomView)
        {
            self.bottomView.frame = Top_Frame_Rect;
            [self.bottomView setImage:topImage];
        }
        if (self.topView)
        {
            self.topView.frame = Middle_Frame_Rect;
            [self.topView setImage:middleImage];
        }
        if (self.middleView)
        {
            self.middleView.frame = Bottom_Frame_Rect;
            [self.middleView setImage:bottomImage];
        }
    }
    if (state == PVSCurrentViewStateTop)
    {
        if (self.bottomView)
        {
            self.bottomView.frame = Bottom_Frame_Rect;
            [self.bottomView setImage:bottomImage];
        }
        if (self.topView)
        {
            self.topView.frame = Top_Frame_Rect;
            [self.topView setImage:topImage];
        }
        if (self.middleView)
        {
            self.middleView.frame = Middle_Frame_Rect;
            [self.middleView setImage:middleImage];
        }
    }
    if (state == PVSCurrentViewStateMiddle)
    {
        if (self.bottomView)
        {
            self.bottomView.frame = Middle_Frame_Rect;
            [self.bottomView setImage:middleImage];
        }
        if (self.topView)
        {
            self.topView.frame = Bottom_Frame_Rect;
            [self.topView setImage:bottomImage];
        }
        if (self.middleView)
        {
            self.middleView.frame = Top_Frame_Rect;
            [self.middleView setImage:topImage];
        }
    }
}

@end
