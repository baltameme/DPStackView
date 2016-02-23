//
//  DPSSStackViewProtocol.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPTabView.h"

@class DPSSStackView;

@protocol DPSSStackViewDataSource <NSObject>

/*!
 @brief Return a DPTabView instance used as a childe container
 */
- (DPTabView *)tabViewChildeContainerForStackView:(DPSSStackView *)stackView;

@optional

/*!
 @brief Return a DPSSStackView containers vertical marginal distance. by def
 */
- (CGFloat)stackViewContainersMargin;

/*!
 @brief Return number of child containters for DPSSStackView
 
 @param stackView Refference to DPSSStackView
 */
- (NSInteger)stackViewNumberOfContainers:(DPSSStackView *)stackView;

/*!
 @brief Return number of child containters for DPSSStackView
 
 @param stackView Refference to DPSSStackView
 @param index An Index of child containter
 */
- (UIScrollView *)scrollView:(DPSSStackView *)stackView viewForIndex:(NSInteger)index;

/*!
 @brief Return a UIView instance used as a header container
 */
- (UIView *)stackHeaderContainerForStackView:(DPSSStackView *)stackView;


/*!
 @brief Return a UITableView instance used as a childe container
 */
- (UITableView *)tableViewChildeContainerForStackView:(DPSSStackView *)stackView;

@end


@protocol DPSSStackViewDelegate <NSObject>

@end

