//
//  DPSSStackView.m
//  TestStackView
//
//  Created by Basil Al-Tamimi on 2/23/16.
//  Copyright © 2016 Basil Al-Tamimi. All rights reserved.
//

#import "DPSSStackView.h"
#import "DPSSStackView+UILayout.h"
#import "DPSSStackViewProxy.h"

static void * const DPSSStackViewKVOContext = (void*)&DPSSStackViewKVOContext;

@interface DPSSStackView () <UIScrollViewDelegate,DPTabViewDelegate>
{
    NSInteger _lastSentIndex;
    NSInteger _currentIndex;
}

@property (nonatomic)           BOOL inited;
@property (nonatomic, strong)   DPSSStackViewProxy *stackProxy;

@property (nonatomic, weak)     UIView *headerContainerView;
@property (nonatomic, weak)     UIView *childeContainerView;
@property (nonatomic, weak)     UIScrollView *currScrollView;

@end
@implementation DPSSStackView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)dealloc
{
    // sanity check
    if (_currScrollView.delegate == _stackProxy)
    {
        _currScrollView.delegate = _stackProxy.mainDelegate;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currScrollView removeObserver:self forKeyPath:@"contentSize" context:DPSSStackViewKVOContext];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _lastSentIndex = -1;
    _currentIndex = -1;
    self.inited = NO;
    [self setupUI];
}

- (void)setupUI {
    
    [self setupHeaderContainerView];
    [self setupChildeContainerView];
}

- (void)setupHeaderContainerView {
    
    self.headerContainerView = [self headerContainer];
    // Header Container Method is not implemented yet
    if(self.headerContainerView == nil) {
        NSAssert(false, @"DPSSStackView's stackHeaderContainerForStackView method must be implemented");
    }
    
    CGFloat headerHeight = [self frameHeight:self.headerContainerView.frame];
    [self.headerContainerView setFrame:CGRectMake(0, 0, [self width], headerHeight)];
    [self addSubview:self.headerContainerView];
}

- (void)setupChildeContainerView {
    
    self.childeContainerView = [self tableViewContainer];
    if(self.childeContainerView == nil) {
        self.childeContainerView = [self tabViewContainer];
        id<DPTabViewDelegate>delegate = ((DPTabView *)self.childeContainerView).delegate;
        self.stackProxy = [DPSSStackViewProxy proxyWithMainDelegate:self other:@[delegate]];
    } else {
        
        id<UIScrollViewDelegate>delegate = ((UIScrollView *)self.childeContainerView).delegate;
        self.stackProxy = [DPSSStackViewProxy proxyWithMainDelegate:self other:@[delegate]];
    }
    
    // Childe Containers Methods are not implemented yet
    if(self.childeContainerView == nil) {
        NSAssert(false, @"DPSSStackView's tableViewChildeContainerForStackView method must be implemented");
    }
    
    CGFloat margin = [self containersMargin];
    CGFloat headerHeight = [self frameHeight:self.headerContainerView.frame];
    margin = margin + headerHeight;
    CGFloat containerHeight = [self height] - margin;
    self.childeContainerView.frame = CGRectMake(0, margin, [self width], containerHeight);
    [self addSubview:self.headerContainerView];
}

#pragma Setters methods

- (void)setDataSource:(id<DPSSStackViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.inited = NO;
}

- (void)setDelegate:(id<DPSSStackViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setCurrScrollView:(UIScrollView *)currScrollView
{
    [_currScrollView removeObserver:self forKeyPath:@"contentSize" context:DPSSStackViewKVOContext];
    
    if (_currScrollView.delegate == self.stackProxy)
    {
        _currScrollView.delegate = self.stackProxy.mainDelegate;
    }
    
    _currScrollView = currScrollView;
    
    if (_currScrollView.delegate != self.stackProxy)
    {
        self.stackProxy.mainDelegate = _currScrollView.delegate;
        _currScrollView.delegate = (id)self.stackProxy;
    }
    
    [_currScrollView addObserver:self forKeyPath:@"contentSize" options:0 context:DPSSStackViewKVOContext];
}

#pragma Public methods

- (void)reloadData {
    
}

#pragma Private methods

- (CGFloat)containersMargin {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stackViewContainersMargin)]) {
        return [self.dataSource stackViewContainersMargin];
    }
    return 0;
}

- (UIView *)headerContainer {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stackHeaderContainerForStackView:)]) {
        UIView *headerContainer = [self.dataSource stackHeaderContainerForStackView:self];
        headerContainer.backgroundColor = [UIColor clearColor];
        headerContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        return headerContainer;
    }
    return nil;
}

- (DPTabView *)tabViewContainer {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewChildeContainerForStackView:)]) {
        return [self.dataSource tabViewChildeContainerForStackView:self];
    }
    return nil;
}

- (UITableView *)tableViewContainer {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableViewChildeContainerForStackView:)]) {
        return [self.dataSource tableViewChildeContainerForStackView:self];
    }
    return nil;
}



@end
