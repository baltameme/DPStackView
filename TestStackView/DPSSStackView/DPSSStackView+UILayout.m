//
//  DPSSStackView+UILayout.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackView+UILayout.h"

@interface DPSSStackView ()

@end
@implementation DPSSStackView (UILayout)

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
    return CGRectGetWidth(frame);
}

@end
