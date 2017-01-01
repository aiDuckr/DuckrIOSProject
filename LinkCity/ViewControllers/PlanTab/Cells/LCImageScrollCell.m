//
//  LCImageScrollCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCImageScrollCell.h"

static BOOL isAutoScrolling = NO;
static NSInteger autoScrollTimeInterval = 3;
static CGFloat viewHeight = 205;

@interface LCImageScrollCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation LCImageScrollCell
+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCImageScrollCell" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCImageScrollCell class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCImageScrollCell *)v;
        }
    }
    
    return nil;
}

- (void)updateShowCell:(NSArray *)bannerArr withType:(LCImageScrollCellViewType)type {
    self.type = type;
    [self setHomeCategoryArray:bannerArr];
    [self startAutoScroll];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    
    return _buttonArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (void)setHomeCategoryArray:(NSArray *)homeCategoryArray {
    _homeCategoryArray = homeCategoryArray;
    
    if (nil != homeCategoryArray && homeCategoryArray.count > 1) {
        self.scrollView.scrollEnabled = YES;
    } else {
        self.scrollView.scrollEnabled = NO;
    }
    
    [self updateShow];
}

- (void)startAutoScroll {
    if (isAutoScrolling) {
        [self stopAutoScroll];
    }
    
    isAutoScrolling = YES;
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:autoScrollTimeInterval];
}

- (void)stopAutoScroll{
    if (isAutoScrolling) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
    }
}

//如果有n个活动，则有n+1页
- (void)autoScroll {
    if (1 == self.homeCategoryArray.count) {
        return ;
    }
    NSInteger pageIndex = [self getPageIndex];
    
    if (pageIndex >= self.homeCategoryArray.count + 1) {
        pageIndex = 1;
    }
    
    if (pageIndex <= 0) {
        pageIndex = self.homeCategoryArray.count;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(pageIndex * DEVICE_WIDTH, 0, self.scrollView.frame.size.width, 10.0f) animated:NO];
    
    // 动画滚到下一页
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * (pageIndex + 1), 0, self.frame.size.width, 10.0f) animated:NO];
    
    //如果动画滚完后在第n+2页，跳到首页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger pageIndex = [self getPageIndex];
        if (pageIndex >= self.homeCategoryArray.count + 1) {
            pageIndex = 1;
        }
        
        if (pageIndex <= 0) {
            pageIndex = self.homeCategoryArray.count;
        }
        [self.scrollView scrollRectToVisible:CGRectMake(pageIndex * DEVICE_WIDTH, 0, self.scrollView.frame.size.width, 10.0f) animated:NO];
    });
    
    //下方小圆点更新显示为下一页
    pageIndex++;
    if (pageIndex >= self.homeCategoryArray.count + 1) {
        pageIndex = 1;
    }
    
    if (pageIndex > 0) {
        self.pageControl.currentPage = pageIndex - 1;
    } else {
        self.pageControl.currentPage = 0;
    }
    
    //一段时间后，进行下一次自动滚
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:autoScrollTimeInterval];
}

- (void)updateShow {
    for (UIButton *btn in self.buttonArray){
        [btn removeFromSuperview];
    }
    for (UIImageView *image in self.imageArray) {
        [image removeFromSuperview];
    }
    /// 前面多加一个按钮，就于右滑循环滚动.
    if (self.homeCategoryArray && self.homeCategoryArray.count > 0) {
        LCHomeCategoryModel *aCategory = [self.homeCategoryArray lastObject];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, viewHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:aCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.imageArray addObject:imageView];
        [self.scrollView addSubview:imageView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, viewHeight)];
        btn.tag = self.homeCategoryArray.count;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:btn];
        [self.scrollView addSubview:btn];
    }
    
    [self.homeCategoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LCHomeCategoryModel *aCategory = (LCHomeCategoryModel *)obj;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * (idx + 1), 0, DEVICE_WIDTH, viewHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:aCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.imageArray addObject:imageView];
        [self.scrollView addSubview:imageView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * (idx + 1), 0, DEVICE_WIDTH, viewHeight)];
        btn.tag = idx;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:btn];
        [self.scrollView addSubview:btn];
    }];
    
    /// 再多加一个按钮，就于最后一张左滑循环滚动.
    if (self.homeCategoryArray && self.homeCategoryArray.count > 0) {
        LCHomeCategoryModel *aCategory = [self.homeCategoryArray firstObject];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * (self.homeCategoryArray.count + 1), 0, DEVICE_WIDTH, viewHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:aCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.imageArray addObject:imageView];
        [self.scrollView addSubview:imageView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * (self.homeCategoryArray.count + 1), 0, DEVICE_WIDTH, viewHeight)];
        btn.tag = 0;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:btn];
        [self.scrollView addSubview:btn];
        //        [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:aCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }
    
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH * (self.homeCategoryArray.count + 2), 10.0f);
    self.scrollView.delegate = self;
    
    if (self.homeCategoryArray.count <= 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    self.pageControl.numberOfPages = self.homeCategoryArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = UIColorFromR_G_B_A(255, 255, 255, 0.3);
    // 只有存在page时，才有currentPageIndicator，否则设置self.pageControl.currentPageIndicatorTintColor会导致崩溃
    if (self.pageControl.numberOfPages > 0) {
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGBA(DUCKER_YELLOW, 1);
    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH, 0, self.scrollView.frame.size.width, 10.0f) animated:NO];
}

- (void)buttonAction:(UIButton *)sender {
    [MobClick event:V5_HOMEPAGE_BANNER_CLICK];
    NSInteger index = sender.tag;
    if ([self.delegate respondsToSelector:@selector(imageScrollCell:didSelectTopListIndex:)]) {
        [self.delegate imageScrollCell:self didSelectTopListIndex:index];
    }
}

#pragma mark
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pageIndex = [self getPageIndex];
    
    if (pageIndex >= self.homeCategoryArray.count + 1) {
        pageIndex = 1;
    }
    
    if (pageIndex <= 0) {
        pageIndex = self.homeCategoryArray.count;
    }
    [scrollView scrollRectToVisible:CGRectMake(pageIndex * DEVICE_WIDTH, 0, scrollView.frame.size.width, 10.0f) animated:NO];
    
    if (pageIndex > 0) {
        self.pageControl.currentPage = pageIndex - 1;
    } else {
        self.pageControl.currentPage = 0;
    }
    
    //如果用户操作了，并且正在自动滚，重新对自动滚进行计时
    if (isAutoScrolling) {
        [self startAutoScroll];
    }
}

- (NSInteger)getPageIndex {
    float offsetX = self.scrollView.contentOffset.x;
    NSInteger pageIndex = (offsetX + 10) / self.frame.size.width;
    return pageIndex;
}


@end
