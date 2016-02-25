//
//  ViewController.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPSSStackView.h"

@interface ViewController : UIViewController <DPSSStackViewDataSource,DPTabViewDataSource>

@property (nonatomic, weak) IBOutlet DPSSStackView    *stackView;

@end

