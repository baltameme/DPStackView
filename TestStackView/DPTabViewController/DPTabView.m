//
//  DPTabView.h
//  IntigralPrototypApplications
//
//  Created by Oleksandr Latyntsev on 9/11/14.
//  Copyright (c) 2014 intigral. All rights reserved.
//

#if DEBUG
#define IDX_TEST(index) NSAssert(index >= 0 &&  (index < [self numberOfTabs]), @"Index Error");
#else
#define IDX_TEST(index);
#endif

#import "DPTabView.h"

@interface DPTabView () <UIScrollViewDelegate>

@property (nonatomic) BOOL inited;
@property (nonatomic) CGRect lastFrame;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger lastSentIndex;
@property (nonatomic, strong) NSMutableIndexSet *visibalIndexSet;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) UIView *cursorView;

- (CGFloat)contentElementWidth;
- (CGFloat)contentElementHeight;
- (CGRect)frameOfElementAtIndex:(NSInteger)index;



@end



@implementation DPTabView

@synthesize cursorView = _cursorView;
@synthesize contentScrollView = _contentScrollView;
@synthesize tabButtons = _tabButtons;

- (void)setSelectedIndex:(NSInteger)index {
    IDX_TEST(index)
    [self selectedTabAtIndex:index];
    self.currentIndex = index;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
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
    self.lastSentIndex = -1;
    _currentIndex = -1;
    self.inited = NO;
    self.animatedTabs = NO;
    self.scrollEnabled = YES;
    [self contentScrollView];
}

- (void)setDataSource:(id<DPTabViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.inited = NO;
}

- (void)setDelegate:(id<DPTabViewDelegate>)delegate {
    
    if(_dataSource == nil) {
        NSAssert(false, @"DPTabView - DataSource is nil, DPTabView DataSource must be set before DPTabView's Delegate");
    }
    
    _delegate = delegate;
    [self  reloadData];
}

- (void)reloadData {
    self.tabButtons = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if (view != self.contentScrollView) {
            [view removeFromSuperview];
        }
    }
    
    
    
    
    self.lastFrame = CGRectZero;
    NSInteger numberOfTabs = [self numberOfTabs];
    if (numberOfTabs > 0) {
        [self updateTabButtons];
        self.cursorView = nil;
        if (self.currentIndex < 0) {
            self.currentIndex = 0;
        }
        if (self.currentIndex > numberOfTabs) {
            self.currentIndex = numberOfTabs - 1;
        }
        
        if (self.cursorView && self.currentIndex >= 0) {
            [self configurateCursore:self.cursorView forButton:[self tabButtonAtIndex:self.currentIndex] atIndex:self.currentIndex];
        }
        
        
        
        self.visibalIndexSet = [NSMutableIndexSet indexSet];
        for (UIView *view in self.contentScrollView.subviews) {
            [view removeFromSuperview];
        }
        [self scrollViewDidScroll:self.contentScrollView];
    }
    
    self.inited = YES;
}

- (void)updateTabButtons {
    NSInteger numberOfTabs = [self numberOfTabs];
    CGFloat horMargin = [self tabBarHorizontalMargin];
    CGFloat tabButtonWidth = ([self contentElementWidth] / numberOfTabs) - horMargin;
    CGSize tabButtonSize = CGSizeMake(tabButtonWidth, [self tabBarHeight]);
    
    for (NSInteger i = 0; i < numberOfTabs; i++) {
        UIButton *tabButton;
        if (self.tabButtons.count > i) {
            tabButton = self.tabButtons[i];
        }
        
        if (!tabButton && self.delegate != nil) {
            tabButton = [[UIButton alloc] init];
            [self.tabButtons insertObject:tabButton atIndex:i];
            [tabButton addTarget:self action:@selector(onSelectTab:) forControlEvents:UIControlEventTouchUpInside];
            
            tabButton.tag = i;
            tabButton.frame = (CGRect){tabButtonSize.width * i + horMargin, 0, tabButtonSize};
            [tabButton setTitle:[self labelForIndex:i] forState:UIControlStateNormal];
            tabButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            [self insertSubview:tabButton atIndex:0];
        }
        [self configurateButton:tabButton forIndex:i withState:DPTabViewButtonState_init];
    }
}

- (void)selectedTabAtIndex:(NSInteger)index {
    [self selectedTabAtIndex:index withAnimation:NO];
}

- (void)selectedTabAtIndex:(NSInteger)index withAnimation:(BOOL)animation {
    [self selectedTabAtIndex:index reload:NO withAnimation:animation];
}

- (void)selectedTabAtIndex:(NSInteger)index reload:(BOOL)reload withAnimation:(BOOL)animation {
    if ((index != self.currentIndex || reload)) {
        
        CGRect frame = [self frameOfElementAtIndex:index];
        [self.contentScrollView setContentOffset:frame.origin animated:animation];
        if (reload) {
            [self scrollViewDidScroll:self.contentScrollView];
        }
        
        [self didSelectTabAtIndex:index];
    }
}

#pragma mark - Private Methods
- (UIScrollView *)contentScrollView {

    if (!_contentScrollView) {
        UIScrollView *theContentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView = theContentScrollView;
        [self addSubview:theContentScrollView];
        
        
        theContentScrollView.pagingEnabled = YES;
        theContentScrollView.delegate = self;
        theContentScrollView.scrollEnabled = self.scrollEnabled;
    }

    return _contentScrollView;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    if (_contentScrollView) {
        _contentScrollView.scrollEnabled = self.scrollEnabled;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    IDX_TEST(currentIndex)
    if (_currentIndex != currentIndex) {
        NSInteger previousIndex = _currentIndex;
        _currentIndex = currentIndex;
        if (self.inited) {
            if (previousIndex >= 0) {
                [self updateButtonState:DPTabViewButtonState_deselected atIndex:previousIndex];
            }
            [self updateButtonState:DPTabViewButtonState_selected atIndex:currentIndex];
            
            if (self.cursorView) {
                [self configurateCursore:self.cursorView forButton:[self tabButtonAtIndex:currentIndex] atIndex:currentIndex];
            }
        }
    }
}


#pragma mark Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.lastFrame, self.frame)) {
        return;
    }
    
    self.lastFrame = self.frame;
    
    
    [self updateTabBar];
    CGSize viewSize = self.frame.size;
    
    NSInteger currentIndex = self.currentIndex;
    if (currentIndex > 0) {
        [self selectedTabAtIndex:self.currentIndex reload:YES withAnimation:NO];
    }
    
    self.contentScrollView.frame = CGRectMake(0, [self tabBarHeight], viewSize.width, viewSize.height - [self tabBarHeight]);
    
    CGFloat contentWidht = ([self numberOfTabs]) * self.contentElementWidth;
    CGFloat contentHeight = self.contentElementHeight;
    
    self.contentScrollView.contentSize = CGSizeMake(contentWidht, contentHeight);
    
    if (currentIndex >= 0) {
        self.currentIndex = currentIndex;
    }
    if (self.currentIndex >= 0) {
        [self selectedTabAtIndex:self.currentIndex reload:YES withAnimation:NO];
    }
    
    
    for (UIView *view in self.contentScrollView.subviews) {
        view.frame = [self frameOfElementAtIndex:view.tag];
    }
    
    if (self.cursorView && self.currentIndex >= 0) {
        [self configurateCursore:self.cursorView forButton:[self tabButtonAtIndex:self.currentIndex] atIndex:self.currentIndex];
    }
}

- (CGFloat)contentElementWidth {
    return self.frame.size.width;
}

- (CGFloat)contentElementHeight {
    return self.frame.size.height - [self tabBarHeight];
}

- (CGRect)frameOfElementAtIndex:(NSInteger)index {
    CGFloat x = self.contentScrollView.frame.size.width * index;
    CGFloat y = 0;
    return (CGRect){x, y, self.contentScrollView.frame.size};
}

- (BOOL)animatedTabs {
    return _animatedTabs;
}

#pragma mark Tab Bar
- (void)updateButtonState:(DPTabViewButtonState)state atIndex:(NSInteger)index {
    UIButton *button = [self tabButtonAtIndex:index];

    if (self.animatedTabs) {
        UIView *privState = [button snapshotViewAfterScreenUpdates:NO];
        
        privState.frame = button.frame;
        
        [button.superview addSubview:privState];
        button.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            privState.alpha = 0;
            button.alpha = 1;
        } completion:^(BOOL finished) {
            [privState removeFromSuperview];
        }];
    } else {
        
    }
    [self configurateButton:button forIndex:index withState:state];
}

- (NSMutableArray *)tabButtons {
    if (!_tabButtons) {
        _tabButtons = [NSMutableArray array];
    }
    return _tabButtons;
}

- (void)setTabButtons:(NSMutableArray *)tabButtons {
    _tabButtons = tabButtons;
}

- (UIButton *)tabButtonAtIndex:(NSInteger)index {
    IDX_TEST(index)
    return self.tabButtons[index];
}

- (void)updateTabBar {
    NSInteger numberOfTabs = [self numberOfTabs];
    CGFloat horMargin = [self tabBarHorizontalMargin];
    CGFloat tabButtonWidth = ([self contentElementWidth] / numberOfTabs) - horMargin;
    CGSize tabButtonSize = CGSizeMake(tabButtonWidth, [self tabBarHeight]);

    for (NSInteger i = 0; i < numberOfTabs; i++) {
        UIButton *tabButton = [self tabButtonAtIndex:i];
        
        tabButton.frame = (CGRect){tabButtonSize.width * i + horMargin, 0, tabButtonSize};
        [tabButton setTitle:[self labelForIndex:i] forState:UIControlStateNormal];
        
        if (self.currentIndex == i) {
            [self configurateButton:tabButton forIndex:i withState:DPTabViewButtonState_selected];
        } else {
            [self configurateButton:tabButton forIndex:i withState:DPTabViewButtonState_deselected];
        }
        
    }
    [self scrollViewDidScroll:self.contentScrollView];
}

- (void)onSelectTab:(UIButton *)button {
    [self selectedTabAtIndex:button.tag withAnimation:YES];
}

#pragma mark Selection Cursor
- (UIView *)cursorView {
    if (!_cursorView) {
        self.cursorView = [self selectionCursor];
    }
    return _cursorView;
}

- (void)setCursorView:(UIView *)cursorView {
    if (!cursorView) {
        [cursorView removeFromSuperview];
    } else {
        [self addSubview:cursorView];
    }
    _cursorView = cursorView;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.numberOfTabs < 1) {
         return;
    }
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat shift = (long)contentOffsetX % (long)self.contentElementWidth;
    
    NSInteger startIndex = (long)contentOffsetX / (long)self.contentElementWidth;
    
    if (shift > self.contentElementWidth / 2) {
        self.currentIndex = MIN(startIndex + 1,[self numberOfTabs] - 1);
    } else {
        self.currentIndex = startIndex;
    }
    
    NSInteger endIndex = startIndex;
    if (shift > 0) {
        endIndex += 1;
        endIndex = MIN(endIndex, [self numberOfTabs] - 1);
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:(NSRange){startIndex, endIndex - startIndex + 1}];
 
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        IDX_TEST(idx)
        if (![self.visibalIndexSet containsIndex:idx]) {
            [self.visibalIndexSet addIndex:idx];
            UIView *view = [self viewForIndex:idx];
            view.tag = idx;
            [self.contentScrollView addSubview:view];
            view.frame = [self frameOfElementAtIndex:idx];
        }
    }];
    
    CGFloat level = (contentOffsetX / self.contentElementWidth - self.currentIndex);
    [self configurateButtonLayout:self.tabButtons forIndex:self.currentIndex andLevel:level];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self didSelectTabAtIndex:self.currentIndex];
}

#pragma mark - DPTabViewDataSource
- (NSInteger)numberOfTabs {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewNumberOfTabs:)]) {
        return [self.dataSource tabViewNumberOfTabs:self];
    }
    return 0;
}

- (NSString *)labelForIndex:(NSInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabView:labelForIndex:)]) {
        IDX_TEST(index)
        return [self.dataSource tabView:self labelForIndex:index];
    }
    return nil;
}

- (UIView *)viewForIndex:(NSInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabView:viewForIndex:)]) {
        IDX_TEST(index)
        return [self.dataSource tabView:self viewForIndex:index];
    }
    return nil;
}

- (void)didSelectTabAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectTabAtIndex:)]) {
        IDX_TEST(index)
        if (self.lastSentIndex != index) {
            self.lastSentIndex = index;
            [self.delegate tabView:self didSelectTabAtIndex:index];
        }
    }

    // Pass selected
    [self didSelectView:[self viewForIndex:index] AtIndex:index];
}

- (void)didSelectView:(UIView *)view AtIndex:(NSInteger)index {

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectView:AtIndex:)]) {
        IDX_TEST(index)
        if (self.lastSentIndex != index) {
            self.lastSentIndex = index;
            [self.delegate tabView:self didSelectView:view AtIndex:index];
        }
    }
}

- (CGFloat)tabBarHeight {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabViewTabBarHeight:)]) {
        return [self.delegate tabViewTabBarHeight:self];
    }
    return 50;
}

- (CGFloat)tabBarHorizontalMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabViewTabBarHorizontalMargin:)]) {
        return [self.delegate tabViewTabBarHorizontalMargin:self];
    }
    return 0;
}


- (void)configurateButton:(UIButton *)button forIndex:(NSInteger)index withState:(DPTabViewButtonState)state {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:configurateButton:forIndex:withState:)]) {
        IDX_TEST(index)
        [self.delegate tabView:self configurateButton:button forIndex:index withState:state];
    }
}

- (UIView *)selectionCursor {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabViewSelectionCursor:)]) {
        return [self.delegate tabViewSelectionCursor:self];
    }
    return nil;
}

- (void)configurateCursore:(UIView *)cursor forButton:(UIButton *)button atIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:configurateCursore:forButton:atIndex:)]) {
        IDX_TEST(index)
        [self.delegate tabView:self configurateCursore:cursor forButton:button atIndex:index];
    }
}

- (void)configurateButtonLayout:(NSArray *)buttons forIndex:(NSInteger)index andLevel:(CGFloat)level {
    IDX_TEST(index)
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:configurateButtonLayout:forIndex:andLevel:)]) {
        [self.delegate tabView:self configurateButtonLayout:buttons forIndex:index andLevel:level];
    }
}

@end
