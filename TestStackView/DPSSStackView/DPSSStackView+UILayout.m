//
//  DPSSStackView+UILayout.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackView+UILayout.h"
#import <objc/runtime.h>

@interface DPSSStackView ()

@property (nonatomic, assign) BOOL contracting;
@property (nonatomic, assign) BOOL previousContractionState;

@end

@implementation DPSSStackView (UILayout)

@dynamic currScrollView,headerContainerView,childeContainerView;
@dynamic previousYOffset,resistanceConsumed;
@dynamic expansionResistance,contractionResistance;

#pragma ------------
#pragma Setters methods

- (void)setExpansionResistance:(NSNumber *)expanResis {
    objc_setAssociatedObject(self, @selector(expansionResistance), expanResis, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat) expanResistance {
    return ((NSNumber *)objc_getAssociatedObject(self, @selector(expansionResistance))).floatValue;
}

#pragma ------------
#pragma Getters methods

#pragma ------------
#pragma Helpers methods

- (CGFloat)width {
    return [self frameWidth:self.frame];
}

- (CGFloat)height {
    return [self frameHeight:self.frame];
}

- (CGFloat)frameWidth:(CGRect)frame {
    return CGRectGetWidth(frame);
}

- (CGFloat)frameHeight:(CGRect)frame {
    return CGRectGetHeight(frame);
}

#pragma ------------
#pragma UILayout methods

- (CGFloat)headerContainerHeight {

    return [self.headerContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)_handleScrolling
{
//    if (![self _shouldHandleScrolling])
//    {
//        return;
//    }
//    
    if (!isnan(self.previousYOffset))
    {
        // 1 - Calculate the delta
        CGFloat deltaY = (self.previousYOffset - self.currScrollView.contentOffset.y);
        
        // 2 - Ignore any scrollOffset beyond the bounds
        CGFloat start = -self.currScrollView.contentInset.top;
        if (self.previousYOffset < start)
        {
            deltaY = MIN(0, deltaY - (self.previousYOffset - start));
        }
        
        /* rounding to resolve a dumb issue with the contentOffset value */
        CGFloat end = floorf(self.currScrollView.contentSize.height - CGRectGetHeight(self.currScrollView.bounds) + self.currScrollView.contentInset.bottom - 0.5f);
        if (self.previousYOffset > end && deltaY > 0)
        {
            deltaY = MAX(0, deltaY - self.previousYOffset + end);
        }
        
        // 3 - Update contracting variable
        if (fabs(deltaY) > FLT_EPSILON)
        {
            self.contracting = deltaY < 0;
        }
        
        // 4 - Check if contracting state changed, and do stuff if so
        if (self.contracting != self.previousContractionState)
        {
            self.previousContractionState = self.contracting;
            self.resistanceConsumed = 0;
        }
        
        // GTH: Calculate the exact point to avoid expansion resistance
        // CGFloat statusBarHeight = [self.statusBarController calculateTotalHeightRecursively];
        
        // 5 - Apply resistance
        // 5.1 - Always apply resistance when contracting
        if (self.contracting)
        {
            CGFloat availableResistance = self.contractionResistance - self.resistanceConsumed;
            self.resistanceConsumed = MIN(self.contractionResistance, self.resistanceConsumed - deltaY);
            
            deltaY = MIN(0, availableResistance + deltaY);
        }
        // 5.2 - Only apply resistance if expanding above the status bar
        else if (self.currScrollView.contentOffset.y > 0)
        {
            CGFloat availableResistance = [self expanResistance] - self.resistanceConsumed;
            self.resistanceConsumed = MIN([self expanResistance], self.resistanceConsumed + deltaY);
            
            deltaY = MAX(0, deltaY - availableResistance);
        }
        
        [self updateYOffset:deltaY];
    }
    
    self.previousYOffset = self.currScrollView.contentOffset.y;
}

- (void)updateYOffset:(CGFloat)deltaY {

}

@end
