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
        self.topView = [[PVSBackgroundView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen)];
        [self.view addSubview:self.topView];
    }
    if (self.middleView == nil)
    {
        self.middleView = [[PVSBackgroundView alloc] initWithFrame:CGRectMake(0, Height_Screen, Width_Screen, Height_Screen)];
        self.middleView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:self.middleView];
    }
    if (self.bottomView == nil)
    {
        self.bottomView = [[PVSBackgroundView alloc] initWithFrame:CGRectMake(0, 2*Height_Screen, Width_Screen, Height_Screen)];
        [self.view addSubview:self.bottomView];
    }
}

@end
