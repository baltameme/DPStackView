//
//  DPSSStackViewProxy.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackViewProxy.h"

@interface DPSSStackViewProxy ()

@property (nonatomic,strong)	NSPointerArray *delegatesPointerArray;

@end

@implementation DPSSStackViewProxy

#pragma mark - Initialization -

+ (id) proxyWithMainDelegate:(id)mainDelegate other:(NSArray *) delegates {
    return [[self alloc] initWithMainDelegate:mainDelegate other:delegates];
}

- (id)initWithMainDelegate:(id) mainDelegate other:(NSArray *) delegates {
    [self setDelegates:delegates];
    [self setMainDelegate:mainDelegate];
    return self;
}

- (id) newProxyWithDelegates:(NSArray *) aDelegates {
    [self setDelegates:aDelegates];
    return self;
}

#pragma mark - Message Forwarding -

- (NSMethodSignature *) methodSignatureForSelector:(SEL)selector {
    return [[self.mainDelegate class] instanceMethodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.mainDelegate respondsToSelector:aSelector])
        return YES;
    for (id delegateObj in self.delegatesPointerArray.allObjects)
        if ([delegateObj respondsToSelector:aSelector])
            return YES;
    return NO;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // check if method can return something
    BOOL methodReturnSomething = (![[NSString stringWithCString:invocation.methodSignature.methodReturnType encoding:NSUTF8StringEncoding] isEqualToString:@"v"]);
    
    // send invocation to the main delegate and use it's return value
    if ([self.mainDelegate respondsToSelector:invocation.selector])
        [invocation invokeWithTarget:self.mainDelegate];
    
    // make another fake invocation with the same method signature and send the same messages to the other delegates (ignoring return values)
    NSInvocation *targetInvocation = invocation;
    if (methodReturnSomething) {
        targetInvocation = [NSInvocation invocationWithMethodSignature:invocation.methodSignature];
        [targetInvocation setSelector:invocation.selector];
    }
    
    for (id delegateObj in self.delegatesPointerArray.allObjects) {
        if ([delegateObj respondsToSelector:invocation.selector])
            [targetInvocation invokeWithTarget:delegateObj];
    }
}

#pragma mark - Properties -

- (void)setDelegates:(NSArray *)newDelegates {
    self.delegatesPointerArray = [NSPointerArray weakObjectsPointerArray];
    [newDelegates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.delegatesPointerArray addPointer:(void *)obj];
    }];
}

- (NSArray *) delegates {
    return self.delegatesPointerArray.allObjects;
}

@end
