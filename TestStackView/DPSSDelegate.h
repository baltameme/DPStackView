//
//  DPSSDelegate.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/25/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DPTabView.h"

typedef enum : NSUInteger {
    DPSSDelegateTypeIPhone,
    DPSSDelegateTypeIPad
} DPSSDelegateType;

@interface DPSSDelegate : NSObject<DPTabViewDataSource,DPTabViewDelegate>

+ (instancetype)ssDelegateWithType:(DPSSDelegateType)type;

@end

@interface DPSSDelegateIPhone : DPSSDelegate

@end

@interface DPSSDelegateIPad : DPSSDelegate

@end