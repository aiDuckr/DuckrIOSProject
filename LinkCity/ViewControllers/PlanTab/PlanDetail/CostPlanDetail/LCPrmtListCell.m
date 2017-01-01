//
//  prmtListCell.m
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPrmtListCell.h"

static BOOL isAutoScrolling = NO;
static NSInteger autoScrollTimeInterval = 3;
#define scrollViewWidth DEVICE_WIDTH

@interface LCPrmtListCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation LCPrmtListCell

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCPrmtListCell" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPrmtListCell class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCPrmtListCell *)v;
        }
    }
    
    return nil;
}

- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
        [_buttonArray addObject:self.btnA];
        [_buttonArray addObject:self.btnB];
        [_buttonArray addObject:self.btnC];
    }
    return _buttonArray;
}

- (void)setImageUrlArray:(NSArray *)imageUrlArray{
    if (_imageUrlArray != imageUrlArray) {
        _imageUrlArray = imageUrlArray;
        _showingPageIndex = 0;
        
        [self updateShow];
    }
}

- (void)startAutoScroll{
    if (isAutoScrolling) {
        [self stopAutoScroll];
    }
    
    isAutoScrolling = YES;
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:autoScrollTimeInterval];
    
}
- (void)stopAutoScroll{
    if (isAutoScrolling) {
        isAutoScrolling = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
    }
}

//如果有n个活动，则有n+1页
- (void)autoScroll {
    // 如果只有一个内容，不滚动
    if (self.imageUrlArray.count <= 1) {
        return;
    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(scrollViewWidth * 2, 0, scrollViewWidth, self.frame.size.height) animated:YES];
    //一段时间后，进行下一次自动滚
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:autoScrollTimeInterval];
}

- (void)updateShow {
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    
    for (UIButton *btn in self.buttonArray){
        btn.layer.masksToBounds = YES;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setAdjustsImageWhenHighlighted:NO];
    }
    
    self.pageControl.numberOfPages = self.imageUrlArray.count;
    self.pageControl.pageIndicatorTintColor = UIColorFromR_G_B_A(255, 255, 255, 0.3);
    //只有存在page时，才有currentPageIndicator，否则设置self.pageControl.currentPageIndicatorTintColor会导致崩溃
    if (self.pageControl.numberOfPages > 0) {
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGBA(DUCKER_YELLOW, 1);
    }
    
    [self setShowPageIndex:self.showingPageIndex];
}


- (void)buttonAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(prmtListCell:didSelectTopListIndex:)]) {
        [self.delegate prmtListCell:self didSelectTopListIndex:self.showingPageIndex];
    }
}

#pragma mark 
// been called after user pan scrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x <= scrollViewWidth) {
        //scroll to left
        self.showingPageIndex --;
    }else if(scrollView.contentOffset.x >= scrollViewWidth*2) {
        //scroll to right
        self.showingPageIndex ++;
    }
    
    if (self.showingPageIndex < 0) {
        self.showingPageIndex = self.imageUrlArray.count-1;
    }else if (self.showingPageIndex >= self.imageUrlArray.count) {
        self.showingPageIndex = 0;
    }
    
    [self setShowPageIndex:self.showingPageIndex];
    
    //重新开始自动滚：用户手动滚后，再经过一段时间才自动滚，防止立刻滚
    [self stopAutoScroll];
    [self startAutoScroll];
}
// benn called after scrollview auto scroll
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x <= scrollViewWidth) {
        //scroll to left
        self.showingPageIndex --;
    }else if(scrollView.contentOffset.x >= scrollViewWidth*2) {
        //scroll to right
        self.showingPageIndex ++;
    }
    
    if (self.showingPageIndex < 0) {
        self.showingPageIndex = self.imageUrlArray.count-1;
    }else if (self.showingPageIndex >= self.imageUrlArray.count) {
        self.showingPageIndex = 0;
    }
    
    [self setShowPageIndex:self.showingPageIndex];
}

- (void)setShowPageIndex:(NSInteger)pageIndex{
    self.pageControl.currentPage = pageIndex;
    
    [self.scrollView scrollRectToVisible:CGRectMake(scrollViewWidth, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    
    
    NSInteger categoryIndex = pageIndex-1;
    if (categoryIndex < 0) {
        categoryIndex = self.imageUrlArray.count-1;
    }
    UIButton *btn = [self.buttonArray objectAtIndex:0];
    NSString *anUrlStr = [self.imageUrlArray objectAtIndex:categoryIndex];
    [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:anUrlStr] placeholderImage:nil];
    
    categoryIndex = pageIndex;
    btn = [self.buttonArray objectAtIndex:1];
    anUrlStr = [self.imageUrlArray objectAtIndex:categoryIndex];
    [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:anUrlStr] placeholderImage:nil];
    
    categoryIndex = pageIndex+1;
    if (categoryIndex > self.imageUrlArray.count-1) {
        categoryIndex = 0;
    }
    btn = [self.buttonArray objectAtIndex:2];
    anUrlStr = [self.imageUrlArray objectAtIndex:categoryIndex];
    [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:anUrlStr] placeholderImage:nil];
    
    
}

@end
