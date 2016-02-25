//
//  ViewController.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "ViewController.h"
#import "DPSSDelegate.h"
#import "DPTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (CGFloat)stackViewContainersMargin {
    return 10;
}

- (UIView *)stackHeaderContainerForStackView:(DPSSStackView *)stackView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 150)];
    [view setBackgroundColor:[UIColor redColor]];
    return view;
}

- (DPTabView *)tabViewChildeContainerForStackView:(DPSSStackView *)stackView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    DPTabView *tabView = [[DPTabView alloc] initWithFrame:CGRectMake(0,  0,width,height - 40 -70)];
    tabView.dataSource = self;
    tabView.delegate = [DPSSDelegate ssDelegateWithType:DPSSDelegateTypeIPhone];;
    return tabView;
}

#pragma --------------
#pragma DPTabView methods

- (NSInteger)tabViewNumberOfTabs:(DPTabView *)tabView {
    return 2;
}

- (NSString *)tabView:(DPTabView *)tabView labelForIndex:(NSInteger)index {
    return @[@"Hello",@"Hello"][index];
}

- (UIView *)tabView:(DPTabView *)tabView viewForIndex:(NSInteger)index {
    return [DPTableView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
