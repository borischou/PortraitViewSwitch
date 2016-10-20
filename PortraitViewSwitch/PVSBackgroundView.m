//
//  PVSBackgroundView.m
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import "PVSBackgroundView.h"

@implementation PVSBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor darkGrayColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
