//
//  DPSSStackView+UILayout.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackView.h"

@interface DPSSStackView (UILayout)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)frameWidth:(CGRect)frame;
- (CGFloat)frameHeight:(CGRect)frame;

@end
