//
//  PVSCurrentViewController.h
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVSBackgroundView.h"

@interface PVSCurrentViewController : UIViewController

@property (strong, nonatomic) PVSBackgroundView *topView;
@property (strong, nonatomic) PVSBackgroundView *bottomView;
@property (strong, nonatomic) PVSBackgroundView *middleView;

- (void)rearrangeSubviewLayoutFromState:(PVSCurrentViewState)state;

@end
