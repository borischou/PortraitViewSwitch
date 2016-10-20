//
//  UIView+Utility.h
//  PortraitViewSwitch
//
//  Created by  bolizhou on 10/20/16.
//  Copyright © 2016  bolizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated duration:(CGFloat)duration;
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated duration:(CGFloat)duration completion:(void (^)(BOOL))completion;

@end
