//
//  DPSSDelegate.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/25/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSDelegate.h"

#define kMainColor [UIColor colorWithRed:190/255. green:10/255. blue:30/255. alpha:1]
#define kSupportColor [UIColor colorWithRed:209/255. green:29/255. blue:51/255. alpha:1]

@implementation DPSSDelegate

+ (instancetype)ssDelegateWithType:(DPSSDelegateType)type {
    
    if (type == DPSSDelegateTypeIPhone) {
        return [DPSSDelegateIPhone new];
    } else {
        return [DPSSDelegateIPad new];
    }
}

- (CGFloat)tabViewTabBarHorizontalMargin:(DPTabView *)tabView {return 0;}

- (CGFloat)tabViewTabBarHeight:(DPTabView *)tabView {
    NSAssert(false, @"tabViewNumberOfTabs needs to be implemented in the subclass");
    return 0;
}

- (UIView *)tabViewSelectionCursor:(DPTabView *)tabView {
    return [UIView new];
}

@end

@implementation DPSSDelegateIPhone

- (NSInteger)tabViewNumberOfTabs:(DPTabView *)tabView {
    return 2;
}

- (CGFloat)tabViewTabBarHorizontalMargin:(DPTabView *)tabView {
    return 10;
}

- (CGFloat)tabViewTabBarHeight:(DPTabView *)tabView {
    return 40;
}

- (void)tabView:(DPTabView *)tabView configurateButton:(UIButton *)button forIndex:(NSInteger)index withState:(DPTabViewButtonState)state {
    static CALayer *upperBorder;
    if (!upperBorder) {
        upperBorder = [CALayer layer];
        upperBorder.backgroundColor = [kSupportColor CGColor];
    }
    
    switch (state) {
        case DPTabViewButtonState_init: {
            button.layer.cornerRadius = 2;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.clipsToBounds = YES;
            break;
        }
            
        case DPTabViewButtonState_selected: {
            button.backgroundColor = kMainColor;
            upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(button.frame), 1.0f);
            [button.layer addSublayer:upperBorder];
            break;
        }
            
        case DPTabViewButtonState_deselected: {
            button.backgroundColor = [UIColor clearColor];
            break;
        }
    }
}

- (UIView *)tabViewSelectionCursor:(DPTabView *)tabView {
    CGFloat lineHeight = 3;
    CGFloat horMargin = [tabView tabBarHorizontalMargin];
    CGFloat cursorWidth = tabView.frame.size.width - (horMargin * 2);
    
    UIView *cursor = [[UIView alloc] initWithFrame:(CGRect){horMargin,[tabView tabBarHeight] - lineHeight, cursorWidth, lineHeight}];
    cursor.backgroundColor = kMainColor;
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [kSupportColor CGColor];
    upperBorder.frame = CGRectMake(0, 0, cursorWidth, 1.0f);
    [cursor.layer addSublayer:upperBorder];
    
    return cursor;
}


@end

@implementation DPSSDelegateIPad

@end