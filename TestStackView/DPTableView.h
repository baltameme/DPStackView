//
//  DPTableView.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/25/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

+ (UITableView *)tableView;

@end
