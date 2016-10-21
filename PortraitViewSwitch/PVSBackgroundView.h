//
//  PVSBackgroundView.h
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PVSCurrentViewState)
{
    PVSCurrentViewStateMiddle,
    PVSCurrentViewStateTop,
    PVSCurrentViewStateBottom,
    PVSCurrentViewStateUnknown
};

@interface PVSBackgroundView : UIView

- (void)setImage:(UIImage *)image;

- (UIImage *)image;

@end
