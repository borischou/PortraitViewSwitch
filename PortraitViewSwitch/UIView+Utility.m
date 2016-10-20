//
//  UIView+Utility.m
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated
{
    [self setContentOffset:offset animated:animated duration:0.5];
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated duration:(CGFloat)duration
{
    if (animated)
    {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(offset.x, offset.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        self.frame = CGRectMake(offset.x, offset.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated duration:(CGFloat)duration completion:(void (^)(BOOL))completion
{
    if (animated)
    {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(offset.x, offset.y, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            completion(finished);
        }];
    }
    else
    {
        self.frame = CGRectMake(offset.x, offset.y, self.frame.size.width, self.frame.size.height);
    }
}


@end
