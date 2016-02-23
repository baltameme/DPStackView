//
//  DPSSStackView.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPSSStackViewProtocol.h"

@interface DPSSStackView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<DPSSStackViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<DPSSStackViewDelegate> delegate;

- (void)reloadData;

@end
