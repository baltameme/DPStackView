//
//  DPSSStackViewProxy.h
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPSSStackViewProxy : NSProxy


/**
*  Set delegates which receive messages from an object.
*  @warning Delegate objects are not retained!
*/
@property (nonatomic,strong)	NSArray		*delegates;

/**
 *  Main delegate is like any other delegate but it's used to get the value for method which need something to return
 */
@property (nonatomic,weak)      id			 mainDelegate;

/**
 *  Allocate a new proxy object which can handle multiple delegates. Set it as delegate for your target class.
 *
 *  @param aMainDelegate main delegate will be used for all method which need to get a return value
 *  @param aDelegates    other delegates will receive all events but when a method needs to return something returned value is ignored
 *
 *  @return a new proxy object. You are responsible of it's ownership.
 */
+ (id) proxyWithMainDelegate:(id)mainDelegate other:(NSArray *)delegates;

@end
