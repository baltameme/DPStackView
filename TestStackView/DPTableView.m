//
//  DPTableView.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/25/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPTableView.h"

static NSUInteger const kCellNum = 40;
static NSUInteger const kRowHeight = 44;
static NSString * const kCellIdentify = @"cell";

@implementation DPTableView

#pragma mark - getter and setter

+ (UITableView *)tableView
{
    DPTableView *_tableView = [[DPTableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = _tableView;
    _tableView.dataSource = _tableView;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentify];
    return _tableView;
}

#pragma mark - tableView Delegate and dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kCellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"test %ld",(long)indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

@end
