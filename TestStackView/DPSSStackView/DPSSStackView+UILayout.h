//
//  DPSSStackView+UILayout.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackView.h"

@interface DPSSStackView (UILayout)

@property (nonatomic, weak)     UIScrollView *currScrollView;
@property (nonatomic, weak)     UIView *headerContainerView;
@property (nonatomic, weak)     UIView *childeContainerView;

@property (nonatomic)           CGFloat previousYOffset;
@property (nonatomic)           CGFloat resistanceConsumed;

@property (nonatomic)           NSNumber *expansionResistance;      // default 200
@property (nonatomic)           CGFloat contractionResistance;    // default 0

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)frameWidth:(CGRect)frame;
- (CGFloat)frameHeight:(CGRect)frame;

@end
